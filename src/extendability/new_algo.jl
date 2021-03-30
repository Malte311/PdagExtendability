using LightGraphs

include("new_algo_datastructure.jl")

"""
Convert a partially directed acyclic graph (PDAG) into a fully
directed acyclic graph (DAG). If this is not possible, an empty
graph is returned.

Undirected edges are represented as two directed edges.

# References
TODO

# Examples
TODO
"""
function fastpdag2dag(g::SimpleDiGraph)::SimpleDiGraph
	result = copy(g)
	hg = init(nv(g))

	for edge in edges(g)
		isundirected = has_edge(g, edge.dst, edge.src)
		insert_arc!(isundirected ? hg.g1 : hg.g2, edge.src, edge.dst)
	end

	ps = list_ps(hg)

	while !isempty(ps)
		# Direct all edges incident to ps towards ps
		for undirected in hg.g1.adjlist[ps]
			rem_edge!(result, ps, undirected)
		end
		newps = pop_ps!(hg, pop!(ps))
		isempty(newps) || push!(ps, newps...)
	end


end

g = SimpleDiGraph(3)
add_edge!(g, 1, 2)
add_edge!(g, 2, 3)
add_edge!(g, 3, 2)
fastpdag2dag(g)