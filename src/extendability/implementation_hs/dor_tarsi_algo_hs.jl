using LightGraphs

@isdefined(setup_hs) || include("dor_tarsi_algo_datastructure_hs.jl")

"""
	pdag2dag_hs(g::SimpleDiGraph)::SimpleDiGraph

Convert a partially directed acyclic graph (PDAG) into a fully
directed acyclic graph (DAG). If this is not possible, an empty
graph is returned.

Undirected edges are represented as two directed edges.

# References
D. Dor, M. Tarsi (1992). A simple algorithm to construct a consistent
extension of a partially oriented graph.
Technicial Report R-185, Cognitive Systems Laboratory, UCLA

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> add_edge!(g, 3, 2)
true
julia> dag = pdag2dag_hs(g)
{3, 2} directed simple Int64 graph
julia> collect(edges(dag))
2-element Array{LightGraphs.SimpleGraphs.SimpleEdge{Int64},1}:
 Edge 1 => 2
 Edge 2 => 3
```
"""
function pdag2dag_hs(g::SimpleDiGraph)::SimpleDiGraph
	result = copy(g)
	temp = setup_hs(g)

	# If one vertex is left there are no edges to other vertices anymore,
	# so we can stop (no need to do another iteration for nv(temp) == 1).
	while length(temp.vertices) > 1
		x = sink_hs(temp)
		x != -1 || return SimpleDiGraph(0)

		# Direct all adjacent edges towards x
		for neighbor in temp.undirected[x]
			rem_edge!(result, x, neighbor)
		end

		remove_vertex_hs!(temp, x)
	end

	result
end

"""
	sink_hs(graph::DtGraph)::Int64

Find a sink in a partially directed graph. The sink has no outgoing edges
and all vertices connected to it via an undirected edge are adjacent to all
adjacent vertices of the sink. If no sink is found, -1 is returned.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> add_edge!(g, 3, 2)
true
julia> x = sink_hs(g)
3
```
"""
function sink_hs(graph::DtGraph)::Int64
	for vertex in graph.vertices
		isempty(graph.outgoing[vertex]) || continue

		# All vertices connected to x via an undirected edge
		# must be adjacent to all vertices adjacent to x.
		for neighbor in graph.undirected[vertex]
			for other in union(graph.ingoing[vertex], graph.undirected[vertex])
				neighbor != other || continue
				isadjacent_hs(graph, neighbor, other) || @goto outer
			end
		end

		return vertex

		@label outer
	end

	-1
end