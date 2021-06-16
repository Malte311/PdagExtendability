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
		sg = subgraph(graph, bucket)
		(indices, ordering) = amo(sg)
		isamo(sg, (indices, ordering)) || return SimpleDiGraph(0)
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
	n = g.numvertices
	alpha = Vector{Int64}(undef, n)
	alphainvers = Vector{Int64}(undef, n)
	set = [Set{Int64}() for _ in 1:n+1]
	set_noingoing = [Set{Int64}() for _ in 1:n+1]
	size = Vector{Int64}(undef, n)
	ingoing = Vector{Int64}(undef, n)

	for i = 1:n
		size[i] = 1
		ingoing[i] = length(g.ingoing[i])
		push!(ingoing[i] > 0 ? set[1] : set_noingoing[1], i)
	end

	j = 1
	for i = 1:n
		v = pop!(set_noingoing[j])
		alpha[v] = i
		alphainvers[i] = v
		size[v] = 0

		for w in union(g.undirected[v], g.outgoing[v])
			size[w] >= 1 || continue
			delete!(ingoing[w] == 0 ? set_noingoing[size[w]] : set[size[w]], w)
			size[w] += 1
			(w in g.outgoing[v]) && (ingoing[w] -= 1)
			push!(ingoing[w] == 0 ? set_noingoing[size[w]] : set[size[w]], w)
		end

		j += 1

		while j >= 1 && isempty(set[j])
			j -= 1
		end
	end

	(alpha, alphainvers)
end

"""
TODO
"""
function isamo(g::DtGraph, ordering::Tuple{Vector{Int64}, Vector{Int64}})::Bool
	
end