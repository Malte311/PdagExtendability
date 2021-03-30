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

	println(hg.g1.deltaplus)
	println(hg.g1.deltaminus)
	println(hg.g2.deltaplus)
	println(hg.g2.deltaminus)

	for edge in edges(g)
		isundirected = has_edge(g, edge.dst, edge.src)
		# TODO: Use the general insert functions
		# because alpha & beta are not updated otherwise
		insert_arc!(isundirected ? hg.g1 : hg.g2, edge.src, edge.dst)
	end

	ps = list_ps(hg)

	while !isempty(ps)
		s = pop!(ps)

		# Direct all edges incident to ps towards ps
		isassigned(hg.g1.adjlist, s) || (hg.g1.adjlist[s] = Set{Int64}())
		for undirected in hg.g1.adjlist[s]
			rem_edge!(result, s, undirected)
		end
		
		newps = pop_ps!(hg, s)
		isempty(newps) || push!(ps, newps...)
	end

	SimpleDiGraph(0)
end

g = SimpleDiGraph(3)
add_edge!(g, 1, 2)
add_edge!(g, 2, 3)
add_edge!(g, 3, 2)
fastpdag2dag(g)

# TODO: Add examples in comments, test if everything works, try to optimize
# after verifying that it works
# g = init(3)
# insert_arc!(g, 1, 2)
# insert_edge!(g, 2, 3)
# print_graph(g)
# for i = 1:3
# 	println("$i is a potential sink? => $(is_ps(g, i))")
# end