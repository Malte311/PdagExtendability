
@isdefined(DtGraph) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")

"""
TODO
"""
function buckets(g::DtGraph)::Vector{Set{Int64}}
	buckets = Vector{Set{Int64}}()
	visited = falses(g.numvertices)

	for u = 1:g.numvertices
		if !visited[u]
			bucket = dfs!(g, u, visited)
			length(bucket) > 1 && push!(buckets, bucket)
		end
	end

	buckets
end

"""
TODO
"""
function dfs!(g::DtGraph, u::Int64, visited::BitArray)::Set{Int64}
	bucket = Set{Int64}()
	stack = Vector{Int64}([u])

	while !isempty(stack)
		v = pop!(stack)
		visited[v] = true
		push!(bucket, v)
		for w in g.undirected[v]
			!visited[w] && push!(stack, w)
		end
	end

	bucket
end