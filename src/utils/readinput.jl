using LightGraphs

"""
	readinputgraph(file::String, only_undir::Bool = false)::SimpleDiGraph

Read a graph from a file and return a SimpleDiGraph. The file must be
formatted as follows. The first line contains the number of vertices and
the number of edges, separated by a space. One empty line follows.
Afterwards, there is one line for each edge. Each line representing an
edge has a startvertex and an endvertex, separated by a space.
Undirected edges are represented by two directed edges.

The parameter only_undir can be set to true to indicate that the input
graph contains only undirected edges. This allows the input file to
contain only one edge for each undirected edge.

# Examples
```julia-repl
julia> g = readinputgraph("../benchmarks/example.txt")
{3, 3} directed simple Int64 graph
```
"""
function readinputgraph(file::String, only_undir::Bool = false)::SimpleDiGraph
	io = open(file, "r")

	(n, m) = parse.(Int, split(readline(io), " "))
	readline(io) # Remove the empty line
	result = SimpleDiGraph(n)

	for line = 1:m
		(u, v) = parse.(Int, split(readline(io), " "))
		add_edge!(result, u, v)
		only_undir && add_edge!(result, v, u)
	end

	close(io)

	result
end