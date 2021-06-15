
@isdefined(DtGraph) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")

"""
TODO
"""
function buckets!(g::DtGraph)::Vector{Set{Int64}}
	components = Vector{Int}(undef, g.numvertices)
	oReps = Vector{Int64}()
	oNodes = Vector{Int64}()
	marked = falses(g.numvertices)
	dfsNum = Vector{Int}(undef, g.numvertices)
	dfsPos = 1

	for u = 1:g.numvertices
		if !marked[u]
			marked[u] = true
			traverse!(u, oReps, oNodes, dfsNum, dfsPos)
			dfs!(u, oReps, oNodes, dfsNum, dfsPos, marked, components)
		end
	end
end

"""
TODO
"""
function dfs!(v, oReps, oNodes, dfsNum, dfsPos, marked, components)
	for w in undirected[v]
		if marked[w]
			handle_non_tree_edge!(w, oReps, oNodes, dfsNum)
		else
			traverse!(w, oReps, oNodes, dfsNum, dfsPos)
			marked[w] = true
			dfs!(w, oReps, oNodes, dfsNum, dfsPos, marked, components)
		end
	end
	backtrack!(v, oReps, oNodes, components)
end

"""
TODO
"""
function traverse!(v, oReps, oNodes, dfsNum, dfsPos)
	push!(v, oReps)
	push!(v, oNodes)
	dfsNum[v] = dfsPos
	dfsPos += 1
end

"""
TODO
"""
function handle_non_tree_edge!(v, oReps, oNodes, dfsNum)
	if v in oNodes
		while dfsNum[v] < dfsNum[last(oReps)]
			pop!(oReps)
		end
	end
end

"""
TODO
"""
function backtrack!(v, oReps, oNodes, components)
	if v == last(oReps)
		pop!(oReps)
		while (w = pop!(oNodes)) != v
			components[w] = v
		end
		components[v] = v
	end
end