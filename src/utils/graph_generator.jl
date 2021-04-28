using LightGraphs

"""
	barbellgraph(n::Int64; filepath::String = "")::SimpleDiGraph

Create a barbell graph with n vertices. Note that n has to be equal and
at n must be greater or equal than six.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> barbellgraph(6)
{6, 14} directed simple Int64 graph
```
"""
function barbellgraph(n::Int64; filepath::String = "")::SimpleDiGraph
	n >= 6 && n % 2 == 0 || error("Invalid value: n has to be equal and >= 6.")

	g = SimpleDiGraph(n)

	mid = convert(Int, n/2)

	for i = 1:mid
		for j = 1:mid
			i != j || continue
			add_edge!(g, i, j)
			add_edge!(g, j, i)
		end
	end

	for i = mid+1:n
		for j = mid+1:n
			i != j || continue
			add_edge!(g, i, j)
			add_edge!(g, j, i)
		end
	end

	add_edge!(g, 1, n)
	add_edge!(g, n, 1)

	filepath != "" && save2file(g, filepath)

	g
end

"""
	bintreegraph(n::Int64; filepath::String = "")::SimpleDiGraph

Create a binary tree with n vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> bintreegraph(10)
{10, 12} directed simple Int64 graph
```
"""
function bintreegraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n)

	for i = 1:convert(Int, floor(log2(n)))
		2*i <= n && add_edge!(g, i, 2*i)
		2*i <= n && add_edge!(g, 2*i, i)

		2*i+1 <= n && add_edge!(g, i, 2*i+1)
		2*i+1 <= n && add_edge!(g, 2*i+1, i)
	end

	filepath != "" && save2file(g, filepath)

	g
end

"""
	centipedegraph(n::Int64; filepath::String = "")::SimpleDiGraph

Create a centipede graph with n vertices. Note that n has to be equal.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> centipedegraph(24)
{24, 22} directed simple Int64 graph
```
"""
function centipedegraph(n::Int64; filepath::String = "")::SimpleDiGraph
	n % 2 == 0 || error("Invalid value: n has to be equal.")

	g = SimpleDiGraph(n)

	for i = 1:2:convert(Int, n/2)
		add_edge!(g, i, 2*i)
		add_edge!(g, 2*i, i)

		add_edge!(g, i, i+1)
		add_edge!(g, i+1, i)
	end

	filepath != "" && save2file(g, filepath)

	g
end

"""
	completegraph(n::Int64; filepath::String = "")::SimpleDiGraph

Create a complete graph with n vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> completegraph(12)
{12, 132} directed simple Int64 graph
```
"""
function completegraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n)

	for u = 1:n
		for v = 1:n
			u != v || continue
			add_edge!(g, u, v)
			add_edge!(g, v, u)
		end
	end

	filepath != "" && save2file(g, filepath)

	g
end

"""
	completebipartitegraph(n::Int64; filepath::String = "")::SimpleDiGraph

Create a complete bipartite graph with n vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> completebipartitegraph(20)
{20, 200} directed simple Int64 graph
```
"""
function completebipartitegraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n)

	for i = 1:2:n
		for j = 2:2:n
			add_edge!(g, i, j)
			add_edge!(g, j, i)
		end
	end

	filepath != "" && save2file(g, filepath)

	g
end

"""
	cyclegraph(n::Int64; filepath::String = "")::SimpleDiGraph

Create a cycle with n vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> cyclegraph(12)
{12, 24} directed simple Int64 graph
```
"""
function cyclegraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n)

	for i = 1:n-1
		add_edge!(g, i, i+1)
		add_edge!(g, i+1, i)
	end

	n != 1 && add_edge!(g, n, 1)
	n != 1 && add_edge!(g, 1, n)

	filepath != "" && save2file(g, filepath)

	g
end

"""
	friendshipgraph(n::Int64; filepath::String = "")::SimpleDiGraph

Create a friendship graph with n+1 vertices. Note that n has to be equal.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> friendshipgraph(8)
{9, 24} directed simple Int64 graph
```
"""
function friendshipgraph(n::Int64; filepath::String = "")::SimpleDiGraph
	n % 2 == 0 || error("Invalid value: n has to be equal.")

	g = SimpleDiGraph(n+1)

	for i = 2:n+1
		add_edge!(g, 1, i)
		add_edge!(g, i, 1)
	end

	for i = 2:2:n
		add_edge!(g, i, i+1)
		add_edge!(g, i+1, i)
	end

	filepath != "" && save2file(g, filepath)

	g
end

"""
pathgraph(n::Int64; filepath::String = "")::SimpleDiGraph

Create a path with n vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> pathgraph(10)
{10, 18} directed simple Int64 graph
```
"""
function pathgraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n)

	for i = 1:n-1
		add_edge!(g, i, i+1)
		add_edge!(g, i+1, i)
	end

	filepath != "" && save2file(g, filepath)

	g
end

"""
	stargraph(n::Int64; filepath::String = "")::SimpleDiGraph

Create a star graph with n+1 vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> stargraph(4)
{5, 8} directed simple Int64 graph
```
"""
function stargraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n+1)

	for i = 2:n+1
		add_edge!(g, 1, i)
		add_edge!(g, i, 1)
	end

	filepath != "" && save2file(g, filepath)

	g
end

"""
	sunletgraph(n::Int64; filepath::String = "")::SimpleDiGraph

Create a sunlet graph with 2n vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> sunletgraph(2)
{4, 6} directed simple Int64 graph
```
"""
function sunletgraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(2*n)

	add_edge!(g, n, 1)
	add_edge!(g, 1, n)

	for i = 1:n-1
		add_edge!(g, i, i+1)
		add_edge!(g, i+1, i)
	end

	for i = 1:n
		add_edge!(g, i, i+n)
		add_edge!(g, i+n, i)
	end

	filepath != "" && save2file(g, filepath)

	g
end

"""
	save2file(g::SimpleDiGraph, file::String; is_only_undir::Bool = true)

`Save a graph g to a given file. Set is_only_undir to `false` if the graph
`contains directed edges.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> save2file(g, "../benchmarks/dummy/graph.txt")
```
"""
function save2file(g::SimpleDiGraph, file::String; is_only_undir::Bool = true)
	open(file, "w+") do io
		write(io, graph2str(g, is_only_undir = is_only_undir))
	end
end

"""
	graph2str(g::SimpleDiGraph; is_only_undir::Bool = false)::String

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
function graph2str(g::SimpleDiGraph; is_only_undir::Bool = false)::String
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
	barbellgraph(n, filepath = joinpath(dir, "barbell-n=$n.txt"))
	bintreegraph(n, filepath = joinpath(dir, "bintree-n=$n.txt"))
	centipedegraph(n, filepath = joinpath(dir, "centipede-n=$n.txt"))
	completegraph(n, filepath = joinpath(dir, "complete-n=$n.txt"))
	completebipartitegraph(n, filepath = joinpath(dir, "completebipartite-n=$n.txt"))
	cyclegraph(n, filepath = joinpath(dir, "cycle-n=$n.txt"))
	friendshipgraph(n, filepath = joinpath(dir, "friendship-n=$n.txt"))
	pathgraph(n, filepath = joinpath(dir, "path-n=$n.txt"))
	stargraph(n, filepath = joinpath(dir, "star-n=$n.txt"))
	sunletgraph(n, filepath = joinpath(dir, "sunlet-n=$n.txt"))
end