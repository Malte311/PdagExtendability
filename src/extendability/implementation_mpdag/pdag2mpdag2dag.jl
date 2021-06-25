using LightGraphs

@isdefined(setup_hs) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")
@isdefined(pdag2mpdag) || include("meek_rules.jl")
@isdefined(mpdag2dag) || include("new_algo_mpdag.jl")


"""
TODO
"""
function pdag2mpdag2dag(g::SimpleDiGraph)::SimpleDiGraph
	graph = setup_hs(g)
	mpdag = pdag2mpdag(g)

	!hasdircycle(mpdag) || return SimpleDiGraph(0)
	countvstructs(graph) == countvstructs(mpdag) || return SimpleDiGraph(0)

	mpdag2dag(dtgraph2digraph(mpdag))
end

"""
TODO
"""
function countvstructs(g::DtGraph)::UInt
	n = g.numvertices
	counter = 0

	# a -> b <- c
	for a = 1:n, c = (a+1):n
		!isadjacent_hs(g, a, c) || continue
		counter += length(intersect(g.outgoing[a], g.outgoing[c]))
	end

	counter
end