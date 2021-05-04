using LightGraphs

@isdefined(DtGraph) || include("dor_tarsi_algo_datastructure_hs.jl")

"""
TODO
"""
function undir2dag(g::SimpleDiGraph)::SimpleDiGraph
	graph = setup_hs(g)
	(indices, ordering) = mcs(graph)

	ispeo((indices, ordering)) || return SimpleDiGraph(0)

	result = copy(g)

	for v = length(ordering):-1:1
		for undirected in graph.undirected[v]
			rem_edge!(result, v, undirected)
		end

		remove_vertex_hs!(graph, v)
	end

	result
end

"""
	ispeo(ordering::Tuple{Vector{Int64}, Vector{Int64}})::Bool

Check whether `ordering` is a perfect elimination order.
That is, for each vertex v, v and all neighbors coming after v form a
clique.

# Examples
TODO
"""
function ispeo(ordering::Tuple{Vector{Int64}, Vector{Int64}})::Bool
	true
end

"""
	mcs(g::DtGraph)::Tuple{Vector{Int64}, Vector{Int64}}

Compute a vertex ordering using maximum cardinality search.

# References
Tarjan, Robert E.; Yannakakis, Mihalis (1984).
Simple Linear-Time Algorithms to Test Chordality of Graphs,
Test Acyclicity of Hypergraphs, and Selectively Reduce Acyclic Hypergraphs.
SIAM Journal on Computing, 13(3), 566–579.

# Examples
TODO
"""
function mcs(g::DtGraph)::Tuple{Vector{Int64}, Vector{Int64}}
	n = g.numvertices

	alpha = Vector{Int64}(undef, n)
	alphainvers = Vector{Int64}(undef, n)

	set = [Set{Int64}() for _ in 1:n]
	size = ones(Int64, n)

	for i = 1:n
		push!(set[1], i)
	end

	i = n
	j = 1
	while i >= 1
		v = pop!(set[j])
		alpha[v] = i
		alphainvers[i] = v
		size[v] -= 1

		for w in g.undirected[v] # algorithm only for undirected graphs
			size[w] >= 1 || continue
			delete!(set[size[w]], w)
			size[w] += 1
			push!(set[size[w]], w)
		end

		i -= 1
		j += 1

		while j >= 1 && isempty(set[j])
			j -= 1
		end
	end

	(alpha, alphainvers)
end