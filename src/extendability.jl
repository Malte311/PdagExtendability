using LightGraphs

"""
	pdag2dag(g::SimpleDiGraph)::SimpleDiGraph

Convert a partially directed acyclic graph (PDAG) into a fully
directed acyclic graph (DAG).

Undirected edges are represented as two directed edges.

# References
D. Dor, M. Tarsi (1992). A simple algorithm to construct a consistent
extension of a partially oriented graph.
Technicial Report R-185, Cognitive Systems Laboratory, UCLA

# Examples

"""
function pdag2dag(g::SimpleDiGraph)::SimpleDiGraph
	g
end

g = SimpleDiGraph(2)

add_edge!(g, 1, 2)
add_edge!(g, 2, 1)

println(pdag2dag(g))