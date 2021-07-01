using LightGraphs

@isdefined(DtGraph) || include("../extendability/implementation_hs/dor_tarsi_algo_datastructure_hs.jl")
@isdefined(pdag2mpdag) || include("../extendability/implementation_mpdag/meek_rules.jl")

"""
TODO
"""
function enumerate_v2(g::SimpleDiGraph)::Vector{DtGraph}
	graph = setup_hs(g)

	undiredges = Vector{Tuple{Int64, Int64}}()
	for u in graph.vertices
		for v in graph.undirected[u]
			edge = (u < v ? u : v, u < v ? v : u)
			!(edge in undiredges) && push!(undiredges, edge)
		end
	end

	extsmeek_rec!(graph, countvstructs(graph), undiredges)
end

"""
TODO
"""
function extsmeek_rec!(g::DtGraph, numvstr::UInt, undiredges::Vector)::Vector
	mpdag = pdag2mpdag(g, nocopy = true)

	(hasdircycle(mpdag) || countvstructs(mpdag) != numvstr) && return []

	for (u, v) in undiredges
		u in mpdag.undirected[v] || delete!(undiredges, (u, v))
	end

	isempty(undiredges) && return [g]

	# Take any undirected edge, direct it in both directions and recurse.
	nxtedge = pop!(undiredges)
	gcpyfirst = deepcopy(mpdag)
	delete!(gcpyfirst.undirected[nxtedge[1]], nxtedge[2])
	delete!(gcpyfirst.undirected[nxtedge[2]], nxtedge[1])
	gcpysecond = deepcopy(gcpyfirst)

	push!(gcpyfirst.ingoing[nxtedge[1]], nxtedge[2])
	push!(gcpyfirst.outgoing[nxtedge[2]], nxtedge[1])
	first = extensions_rec!(gcpyfirst, numvstr, copy(undiredges))

	push!(gcpysecond.ingoing[nxtedge[2]], nxtedge[1])
	push!(gcpysecond.outgoing[nxtedge[1]], nxtedge[2])
	second = extensions_rec!(gcpysecond, numvstr, copy(undiredges))

	return vcat(first, second)
end