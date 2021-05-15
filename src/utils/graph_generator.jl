using LightGraphs

@isdefined(save2file) || include("utils.jl")

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

"""
	cliquegraph(n::Int64; filepath::String = "")::SimpleGraph

Create a clique graph with `n` vertices. The graph contains a
clique of size `n/2`, where each vertex of that clique has one
additional neighbor which is not connected to any other vertex.
Note that `n` has to be equal.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> cliquegraph(8)
{8, 10} undirected simple Int64 graph
```
"""
function cliquegraph(n::Int64; filepath::String = "")::SimpleGraph
	n % 2 == 0 || error("Invalid value: n has to be equal.")
	g = SimpleGraph(n)
	mid = convert(Int, floor(n/2))
	for i = mid+1:n
		for j = mid+1:n
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
	doublestargraph(n::Int64; filepath = "")::SimpleGraph

Create a graph with `n` vertices, consisting of two connected stars.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> doublestargraph(8)
{8, 7} undirected simple Int64 graph
```
"""
function doublestargraph(n::Int64; filepath = "")::SimpleGraph
	g = SimpleGraph(n)
	mid = convert(Int, floor(n/2))
	for i = 2:mid
		add_edge!(g, 1, i)
	end
	for i = mid+2:n
		add_edge!(g, mid+1, i)
	end
	add_edge!(g, 1, mid+1)
	filepath != "" && save2file(g, filepath)
	g
end

"""
	extbarbellgraph(n::Int64; filepath::String = "")::SimpleGraph

Create an extended barbell graph with `n` vertices. That is, two cliques
connected by a path. The cliques and the path are of size `n/3` each.

If a filepath is provided, the graph will also be written to that file.

# Examples
```julia-repl
julia> extbarbellgraph(8)
{8, 7} undirected simple Int64 graph
```
"""
function extbarbellgraph(n::Int64; filepath::String = "")::SimpleGraph
	n1 = convert(Int, floor(n/3))
	n2 = convert(Int, floor(n/3))
	g = SimpleGraph(n)
	for i = 1:n1
		for j = 1:n1
			i < j && add_edge!(g, i, j)
		end
	end
	for i = n1+1:n1+n2
		for j = n1+1:n1+n2
			i < j && add_edge!(g, i, j)
		end
	end
	for i = n1+n2+1:n-1
		add_edge!(g, i, i+1)
	end
	add_edge!(g, n1, n1+n2+1)
	add_edge!(g, n1+n2, n)
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
	graph2pdag(g::SimpleDiGraph, prob::Float64)::SimpleDiGraph

Convert an undirected graph (encoded as a `SimpleDiGraph`) into a
partially directed graph.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 1)
true
julia> add_edge!(g, 1, 3)
true
julia> add_edge!(g, 3, 1)
true
julia> collect(edges(graph2pdag(g, 0.5)))
3-element Vector{LightGraphs.SimpleGraphs.SimpleEdge{Int64}}:
 Edge 1 => 2
 Edge 1 => 3
 Edge 2 => 1
```
"""
function graph2pdag(g::SimpleDiGraph, prob::Float64)::SimpleDiGraph
	result = copy(g)

	for v in vertices(g)
		rand() < prob || continue
		for u in all_neighbors(g, v)
			rem_edge!(result, v, u)
		end
	end

	result
end

include("readinput.jl")
g = readinputgraph("../benchmarks/undirected/chordal/n=10000/subtree-n=10000-1.txt", true)

for p in [0.1, 0.2, 0.5, 0.7, 0.9]
	for i = 1:5
		save2file(graph2pdag(g, p), "../benchmarks/pdirected/subtree-n=10000-1/subtree-n=10000-1-p=$p-$i.txt", is_only_undir = false)
	end
end