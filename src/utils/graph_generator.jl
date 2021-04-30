using LightGraphs

"""
	barbellgraph(n::Int64; filepath::String = "")::SimpleGraph

Create a barbell graph with `n` vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
TODO
```
"""
function barbellgraph(n::Int64; filepath::String = "")::SimpleGraph
	n1 = convert(Int, floor(n/2))
	n2 = convert(Int, ceil(n/2))
	g = barbell_graph(n1, n2)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	bintreegraph(n::Int64; filepath::String = "")::SimpleGraph

Create a binary tree with `n` vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
TODO
```
"""
function bintreegraph(n::Int64; filepath::String = "")::SimpleGraph
	g = SimpleGraph(n)
	for i = 1:convert(Int, floor(n/2))
		add_edge!(g, i, 2*i)
		2*i+1 <= n && add_edge!(g, i, 2*i+1)
	end
	filepath != "" && save2file(g, filepath)
	g
end

"""
	centipedegraph(n::Int64; filepath::String = "")::SimpleGraph

Create a centipede graph with `n` vertices. Note that `n` has to be equal.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
TODO
```
"""
function centipedegraph(n::Int64; filepath::String = "")::SimpleGraph
	n % 2 == 0 || error("Invalid value: n has to be equal.")
	g = SimpleGraph(n)
	mid = convert(Int, n/2)
	for i = 1:mid
		add_edge!(g, i, i+mid)
		i != mid && add_edge!(g, i, i+1)
	end
	filepath != "" && save2file(g, filepath)
	g
end

"""
	completegraph(n::Int64; filepath::String = "")::SimpleGraph

Create a complete graph with `n` vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
TODO
```
"""
function completegraph(n::Int64; filepath::String = "")::SimpleGraph
	g = complete_graph(n)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	completebipartitegraph(n::Int64; filepath::String = "")::SimpleGraph

Create a complete bipartite graph with `n` vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
TODO
```
"""
function completebipartitegraph(n::Int64; filepath::String = "")::SimpleGraph
	n1 = convert(Int, floor(n/2))
	n2 = convert(Int, ceil(n/2))
	g = complete_bipartite_graph(n1, n2)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	cyclegraph(n::Int64; filepath::String = "")::SimpleGraph

Create a cycle with `n` vertices. Note that `n` has to be greater or
equal to 3.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
TODO
```
"""
function cyclegraph(n::Int64; filepath::String = "")::SimpleGraph
	n >= 3 || error("Invalid value: n must be greater than or equal to 3.")
	g = cycle_graph(n)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	friendshipgraph(n::Int64; filepath::String = "")::SimpleGraph

Create a friendship graph with `n` vertices. Note that `n` has to be odd.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
TODO
```
"""
function friendshipgraph(n::Int64; filepath::String = "")::SimpleGraph
	n % 2 != 0 || error("Invalid value: n has to be odd.")
	g = SimpleGraph(n)
	for i = 2:n
		add_edge!(g, 1, i)
	end
	for i = 2:2:n-1
		add_edge!(g, i, i+1)
	end
	filepath != "" && save2file(g, filepath)
	g
end

"""
pathgraph(n::Int64; filepath::String = "")::SimpleGraph

Create a path with `n` vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
TODO
```
"""
function pathgraph(n::Int64; filepath::String = "")::SimpleGraph
	g = path_graph(n)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	stargraph(n::Int64; filepath::String = "")::SimpleGraph

Create a star graph with `n` vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
TODO
```
"""
function stargraph(n::Int64; filepath::String = "")::SimpleGraph
	g = star_graph(n)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	sunletgraph(n::Int64; filepath::String = "")::SimpleGraph

Create a sunlet graph with `n` vertices. Note that `n` has to be equal.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
TODO
```
"""
function sunletgraph(n::Int64; filepath::String = "")::SimpleGraph
	n % 2 == 0 || error("Invalid value: n has to be equal.")
	g = SimpleGraph(n)
	mid = convert(Int, n/2)
	for i = 1:mid-1
		add_edge!(g, i, i+1)
	end
	mid != 1 && add_edge!(g, 1, mid)
	for i = 1:mid
		add_edge!(g, i, i+mid)
	end
	filepath != "" && save2file(g, filepath)
	g
end

function graph2digraph(g::SimpleGraph)::SimpleDiGraph
	result = SimpleDiGraph(nv(g))
	for e in edges(g)
		add_edge!(result, e.src, e.dst)
		add_edge!(result, e.dst, e.src)
	end
	result
end

"""
	save2file(g, file::String; is_only_undir::Bool = true)

`Save a graph g to a given file. Set is_only_undir to `false` if the graph
`contains directed edges.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> save2file(g, "../benchmarks/dummy/graph.txt")
```
"""
function save2file(g, file::String; is_only_undir::Bool = true)
	open(file, "w+") do io
		write(io, graph2str(g, is_only_undir = is_only_undir))
	end
end

"""
	graph2str(g; is_only_undir::Bool = false)::String

Convert a graph g to the corresponding string representation. Set
is_only_undir to `false` if the graph contains directed edges.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> graph2str(g)
"3 0\n"
```
"""
function graph2str(g; is_only_undir::Bool = false)::String
	typeof(g) == SimpleGraph && (is_only_undir = false)

	nedges = is_only_undir ? convert(Int, ne(g) / 2) : ne(g)
	g_str = "$(nv(g)) $nedges\n\n"

	done = Set{String}()

	for e in edges(g)
		if !is_only_undir || !("$(e.src)-$(e.dst)" in done)
			g_str = string(g_str, "$(e.src) $(e.dst)\n")
			is_only_undir && push!(done, "$(e.dst)-$(e.src)")
		end
	end

	g_str
end

"""
	generateall(n::Int64, dir::String)

Generate all available graphs with n vertices and write them to files
in the given directory. The files will be created on demand, i.e.,
providing an empty directory is sufficient.

# Examples
```julia-repl
julia> generateall(512, "../benchmarks/dummy/newdir/")
```
"""
function generateall(n::Int64, dir::String)
	(n % 2 == 0 && n >= 3) || error("n has to be equal and greater than 2.")

	barbellgraph(n, filepath = joinpath(dir, "barbell-n=$n.txt"))
	bintreegraph(n, filepath = joinpath(dir, "bintree-n=$n.txt"))
	centipedegraph(n, filepath = joinpath(dir, "centipede-n=$n.txt"))
	completegraph(n, filepath = joinpath(dir, "complete-n=$n.txt"))
	completebipartitegraph(n, filepath = joinpath(dir, "completebipartite-n=$n.txt"))
	cyclegraph(n, filepath = joinpath(dir, "cycle-n=$n.txt"))
	friendshipgraph(n+1, filepath = joinpath(dir, "friendship-n=$(n+1).txt"))
	pathgraph(n, filepath = joinpath(dir, "path-n=$n.txt"))
	stargraph(n, filepath = joinpath(dir, "star-n=$n.txt"))
	sunletgraph(convert(Int, n/2), filepath = joinpath(dir, "sunlet-n=$n.txt"))
end

# save2file(barabasi_albert(512, 3, is_directed = true, seed = 123), joinpath("../benchmarks/dummy/debug", "barabasi_albert-n=512-k=3.txt"), is_only_undir = false)
# save2file(barabasi_albert(512, 5, is_directed = true, seed = 123), joinpath("../benchmarks/dummy/debug", "barabasi_albert-n=512-k=5.txt"), is_only_undir = false)
# save2file(barabasi_albert(512, 10, is_directed = true, seed = 123), joinpath("../benchmarks/dummy/debug", "barabasi_albert-n=512-k=10.txt"), is_only_undir = false)