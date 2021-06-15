using LightGraphs

@isdefined(DtGraph) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")
@isdefined(buckets) || include("connected_components.jl")
@isdefined(ispeo) || include("../implementation_hs/maximum_cardinality_search_hs.jl")

"""
TODO

Assumes that the input graph is an MPDAG and only works on MPDAGs.
"""
function mpdag2dag(g::SimpleDiGraph)::SimpleDiGraph
	result = copy(g)
	graph = setup_hs(g)

	for bucket in buckets(graph)
		(indices, ordering) = amo(graph, bucket)
		ispeo(graph, (indices, ordering)) || return SimpleDiGraph(0)
		for i = length(ordering):-1:1
			v = ordering[i]

			for w in graph.undirected[v]
				rem_edge!(result, v, w)
			end

			remove_vertex_hs!(graph, v)
		end
	end

	result
end

"""
TODO
"""
function amo(g::DtGraph, bucket::Set{Int64})::Tuple{Vector{Int64}, Vector{Int64}}

end