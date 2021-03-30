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

	# Set up the datastructure.
	undirected = Set{String}()
	for edge in edges(g)
		isundirected = has_edge(g, edge.dst, edge.src)

		if isundirected
			key = "$(edge.src)-$(edge.dst)"
			!(key in undirected) && insert_edge!(hg, edge.src, edge.dst)
			push!(undirected, join(reverse(split(key, "-")), "-"))
		else
			insert_arc!(hg, edge.src, edge.dst)
		end
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

	# The graph is not extendable if no potential sinks are left but there
	# are still edges in the graph.
	isassigned(hg.g1.deltaplus) || (hg.g1.deltaplus = Vector{Int64}())
	isassigned(hg.g2.deltaplus) || (hg.g2.deltaplus = Vector{Int64}())
	sum(hg.g1.deltaplus) + sum(hg.g2.deltaplus) == 0 || return SimpleDiGraph(0)

	result
end