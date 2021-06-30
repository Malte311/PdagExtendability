using LightGraphs

@isdefined(DtGraph) || include("../extendability/implementation_hs/dor_tarsi_algo_datastructure_hs.jl")
@isdefined(hasdircycle) || include("../extendability/implementation_mpdag/meek_rules.jl")
@isdefined(countvstructs) || include("../extendability/implementation_mpdag/pdag2mpdag2dag.jl")

"""
	enumerate_v1(g::SimpleDiGraph)::Vector{DtGraph}

Compute all consistent extensions of the input graph `g` by first
generating all fully directed graphs with the same edge directions
as in `g` and then removing the ones that are either cyclic or do
not have the same set of v-structures as `g`.

# Examples

TODO
"""
function enumerate_v1(g::SimpleDiGraph)::Vector{DtGraph}
	graph = pdag2mpdag(g)

	undiredges = Vector{Tuple{Int64, Int64}}()
	for u in graph.vertices
		for v in graph.undirected[u]
			edge = (u < v ? u : v, u < v ? v : u)
			!(edge in undiredges) && push!(undiredges, edge)
		end
	end

	extensions_rec!(graph, countvstructs(graph), undiredges)
end

"""
	extensions_rec!(g::DtGraph, numvstr::Uint, undiredges::Vector)::Vector

Compute all extensions of `g` recursively by generating all possible directions
and filter out those which are either cyclic or not consistent.

# Examples

TODO
"""
function extensions_rec!(g::DtGraph, numvstr::UInt, undiredges::Vector)::Vector
	if isempty(undiredges)
		isext = !hasdircycle(g) && numvstr == countvstructs(g)
		return isext ? [g] : []
	end

	# Take any undirected edge, direct it in both directions and recurse.
	nxtedge = pop!(undiredges)
	delete!(g.undirected[nxtedge[1]], nxtedge[2])
	delete!(g.undirected[nxtedge[2]], nxtedge[1])

	push!(g.ingoing[nxtedge[1]], nxtedge[2])
	push!(g.outgoing[nxtedge[2]], nxtedge[1])
	first = extensions_rec!(g, numvstr, undiredges)

	delete!(g.ingoing[nxtedge[1]], nxtedge[2])
	delete!(g.outgoing[nxtedge[2]], nxtedge[1])

	push!(g.ingoing[nxtedge[2]], nxtedge[1])
	push!(g.outgoing[nxtedge[1]], nxtedge[2])
	second = extensions_rec!(g, numvstr, undiredges)

	return vcat(first, second)
end