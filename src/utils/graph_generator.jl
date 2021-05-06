using LightGraphs

"""
	barabasialbertgraph(n::Int64, k::Int64; seed = 123, filepath = "")::SimpleGraph

Create a Barabási–Albert model random graph with `n` vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> barabasialbertgraph(50, 3)
{50, 141} undirected simple Int64 graph
```
"""
function barabasialbertgraph(n::Int64, k::Int64; seed = 123, filepath = "")::SimpleGraph
	g = barabasi_albert(n, k, seed = seed)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	barbellgraph(n::Int64; filepath::String = "")::SimpleGraph

Create a barbell graph with `n` vertices.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> barbellgraph(6)
{6, 7} undirected simple Int64 graph
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
julia> bintreegraph(7)
{7, 6} undirected simple Int64 graph
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
julia> centipedegraph(8)
{8, 7} undirected simple Int64 graph
```
"""
function centipedegraph(n::Int64; filepath::String = "")::SimpleGraph
	n % 2 == 0 || error("Invalid value: n has to be equal.")
	g = SimpleGraph(n)
	mid = convert(Int, floor(n/2))
	for i = 1:mid
		add_edge!(g, i, i+mid)
		i != mid && add_edge!(g, i, i+1)
	end
	filepath != "" && save2file(g, filepath)
	g
end


function cliquegraph(n::Int64; filepath::String = "")::SimpleGraph
	n % 2 == 0 || error("Invalid value: n has to be equal.")
	g = SimpleGraph(n)
	mid = convert(Int, floor(n/2))
	for i = mid+1:n # Change to 1:mid for different numbering
		for j = mid+1:n # Change to 1:mid for different numbering
			i != j && add_edge!(g, i, j)
		end
	end
	for i = 1:mid
		add_edge!(g, i, i+mid)
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
julia> completegraph(4)
{4, 6} undirected simple Int64 graph
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
julia> completebipartitegraph(6)
{6, 9} undirected simple Int64 graph
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
julia> cyclegraph(8)
{8, 8} undirected simple Int64 graph
```
"""
function cyclegraph(n::Int64; filepath::String = "")::SimpleGraph
	n >= 3 || error("Invalid value: n must be greater than or equal to 3.")
	g = cycle_graph(n)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	dorogovtsevmendesgraph(n::Int64; seed = 123, filepath = "")::SimpleGraph

Create a Dorogovtsev-Mendes graph with `n` vertices.
Note that `n` has to be greater or equal to 3. The generated graphs are
always planar.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> dorogovtsevmendesgraph(12)
{12, 21} undirected simple Int64 graph
```
"""
function dorogovtsevmendesgraph(n::Int64; seed = 123, filepath = "")::SimpleGraph
	n >= 3 || error("Invalid value: n must be greater than or equal to 3.")
	g = dorogovtsev_mendes(n, seed = seed)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	erdosrenyigraph(n::Int64, ne::Int64; seed = 123, filepath = "")::SimpleGraph

Create an Erdős–Rényi random graph with `n` vertices and `ne` edges.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> erdosrenyigraph(12, 20)
{12, 20} undirected simple Int64 graph
```
"""
function erdosrenyigraph(n::Int64, ne::Int64; seed = 123, filepath = "")::SimpleGraph
	g = erdos_renyi(n, ne, seed = seed)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	friendshipgraph(n::Int64; filepath::String = "")::SimpleGraph

Create a friendship graph with `n` vertices. Note that `n` has to be odd.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> friendshipgraph(7)
{7, 9} undirected simple Int64 graph
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
julia> pathgraph(10)
{10, 9} undirected simple Int64 graph
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
julia> stargraph(11)
{11, 10} undirected simple Int64 graph
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
julia> sunletgraph(8)
{8, 8} undirected simple Int64 graph
```
"""
function sunletgraph(n::Int64; filepath::String = "")::SimpleGraph
	n % 2 == 0 || error("Invalid value: n has to be equal.")
	g = SimpleGraph(n)
	mid = convert(Int, floor(n/2))
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

"""
	graph2digraph(g::SimpleGraph)::SimpleDiGraph

Convert an undirected graph (SimpleGraph) into a directed
graph (SimpleDiGraph).

# Examples
```julia-repl
julia> g = SimpleGraph(3)
{3, 0} undirected simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> collect(edges(graph2digraph(g)))
2-element Vector{LightGraphs.SimpleGraphs.SimpleEdge{Int64}}:
 Edge 1 => 2
 Edge 2 => 1
```
"""
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

Save a graph g to a given file. Set `is_only_undir` to `false` if the graph
contains directed edges.

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

Convert a graph `g` to the corresponding string representation. Set
`is_only_undir` to `false` if the graph contains directed edges.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> graph2str(g)
"3 0\n"
```
"""
function graph2str(g; is_only_undir::Bool = false)::String
	typeof(g) == SimpleGraph{Int64} && (is_only_undir = false)

	nedges = is_only_undir ? convert(Int, floor(ne(g)/2)) : ne(g)
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

Generate all available graphs with `n` vertices and write them to files
in the given directory. The files will be created on demand, i.e.,
providing an empty directory is sufficient.

# Examples
```julia-repl
julia> generateall(512, "../benchmarks/dummy/newdir/")
```
"""
function generateall(n::Int64, dir::String)
	(n % 2 == 0 && n >= 3) || error("n has to be equal and greater than 2.")

	n1 = convert(Int, ceil(n/2))
	n2 = convert(Int, floor(n/2))
	deg = convert(Int, floor(n/4))

	barbellgraph(n, filepath = joinpath(dir, "barbell-n=$n.txt"))
	bintreegraph(n, filepath = joinpath(dir, "bintree-n=$n.txt"))
	centipedegraph(n, filepath = joinpath(dir, "centipede-n=$n.txt"))
	completegraph(n, filepath = joinpath(dir, "complete-n=$n.txt"))
	completebipartitegraph(n, filepath = joinpath(dir, "completebipartite-n=$n.txt"))
	cyclegraph(n, filepath = joinpath(dir, "cycle-n=$n.txt"))
	friendshipgraph(n+1, filepath = joinpath(dir, "friendship-n=$(n+1).txt"))
	pathgraph(n, filepath = joinpath(dir, "path-n=$n.txt"))
	stargraph(n, filepath = joinpath(dir, "star-n=$n.txt"))
	sunletgraph(n, filepath = joinpath(dir, "sunlet-n=$n.txt"))

	save2file(circular_ladder_graph(n), joinpath(dir, "circular_ladder-n=$n.txt"))
	save2file(ladder_graph(n), joinpath(dir, "ladder-n=$n.txt"))
	save2file(lollipop_graph(n1, n2), joinpath(dir, "lollipop-n=$n.txt"))
	save2file(wheel_graph(n), joinpath(dir, "wheel-n=$n.txt"))

	for seed in [123, 456, 789]
		dorogovtsevmendesgraph(
			n,
			seed = seed,
			filepath = joinpath(dir, "dorogovtsev_mendes-n=$n-seed=$seed.txt")
		)
		erdosrenyigraph(
			n,
			n2,
			seed = seed,
			filepath = joinpath(dir, "erdos_renyi-n=$n-ne=$n2-seed=$seed.txt")
		)

		for k in [3, 5, 7, 10]
			barabasialbertgraph(
				n,
				k,
				seed = seed,
				filepath = joinpath(dir, "barabasi_albert-n=$n-k=$k-seed=$seed.txt")
			)

			for beta in [0.1, 0.2, 0.4, 0.6, 0.8]
				save2file(
					watts_strogatz(n, k, beta, seed = seed),
					joinpath(dir, "watts_strogatz-n=$n-k=$k-beta=$beta-seed=$seed.txt")
				)
			end
		end
	end
end

#cliquegraph(1024, filepath = joinpath("../benchmarks/undirected/clique/n=1024/", "clique-n=1024-3.txt"))