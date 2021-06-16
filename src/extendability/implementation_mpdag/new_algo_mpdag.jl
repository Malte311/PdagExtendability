using LightGraphs

@isdefined(DtGraph) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")
@isdefined(buckets) || include("connected_components.jl")

"""
TODO

Assumes that the input graph is an MPDAG and only works on MPDAGs.
"""
function mpdag2dag(g::SimpleDiGraph)::SimpleDiGraph
	result = copy(g)
	graph = setup_hs(g)

	for bucket in buckets(graph)
		(indices, ordering) = amo(subgraph(bucket))
		# TODO: Test peo only on bucket, not on whole graph!!
		#isamo(graph, bucket, (indices, ordering)) || return SimpleDiGraph(0)
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
function subgraph(g::DtGraph, bucket::Set{Int64})::DtGraph
	n = length(bucket)
	result = DtGraph(
		n,
		Set{Int64}([i for i in 1:n]),
		[],
		[Set{Int64}() for _ in 1:n],
		[Set{Int64}() for _ in 1:n],
		[Set{Int64}() for _ in 1:n]
	)
	done = Set{String}()

	for vertex in bucket
		for dir in g.outgoing[vertex]
			(dir in bucket) && insert_edge_hs!(result, vertex, dir, true)
		end
		for undir in g.undirected[vertex]
			# No need to check (undir in bucket) as undirected neighbors
			# must be in the same bucket.
			isdone = ("$vertex-$undir" in done)
			!isdone && insert_edge_hs!(result, vertex, undir, false)
			!isdone && push!(done, "$undir-$vertex")
		end
	end

	result
end

"""
TODO
"""
function amo(g::DtGraph)::Tuple{Vector{Int64}, Vector{Int64}}

end

"""
TODO
"""
function isamo()
	
end