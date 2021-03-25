using LightGraphs

"""
	readinputgraph(file::String)::SimpleDiGraph

Read a graph from a file and return a SimpleDiGraph. The file must be
formatted as follows. The first line contains the number of vertices and
the number of edges, separated by a space. Afterwards, there is one line
for each edge. Each line representing an edge has a start vertex and an
end vertex, separated by a space. Undirected edges are represented by two
directed edges.

# Examples
```julia-repl
julia> g = readinputgraph("../benchmarks/example.txt")
{3, 3} directed simple Int64 graph
```
"""
function readinputgraph(file::String)::SimpleDiGraph
	io = open(file, "r")

	(n, m) = parse.(Int, split(readline(io), " "))
	result = SimpleDiGraph(n)

	for line = 1:m
		(u, v) = parse.(Int, split(readline(io), " "))
		add_edge!(result, u, v)
	end

	close(io)

	result
end