using LightGraphs

include("new_algo_datastructure.jl")

"""

# References
David W. Matula, Leland L. Beck (1983).
Smallest-last ordering and clustering and graph coloring algorithms.
Journal of the ACM, 30(3):417–427.
"""
function degeneracy_ordering(g::SimpleDiGraph)::Vector{Int64}
	j = nv(g)
	h = copy(g)
	result = fill(0, j)
	(aux_array, deg_str) = deg_struct(g)

	ht = Dict()

	while j > 0
		v = find_min_degree_vertex!(deg_str)
		v = get(ht, v, v)
		adjlist = union(
			Set{Int64}(inneighbors(h, v)),
			Set{Int64}(outneighbors(h, v))
		)
		for adj in adjlist
			deg = aux_array[adj]+1
			delete!(deg_str[deg], adj)
			isassigned(deg_str, deg-1) || (deg_str[deg-1] = Set{Int64}())
			push!(deg_str[deg-1], adj)
			aux_array[adj] -= 1
		end

		push!(result, v)
		ht[v] = get(ht, get(ht, v, nv(h)), nv(h))
		rem_vertex!(h, v) # TODO: Mark as deleted or use mapping
		j -= 1
	end

	reverse(result)
end

"""

Compute the degree structure.
"""
function deg_struct(g::SimpleDiGraph)::Tuple{Vector{Int64}, Vector{Set{Int64}}}
	n = nv(g)
	deg_str = Vector{Set{Int64}}(undef, n)
	aux_array = Vector{Int64}(undef, n)

	for vertex = 1:n
		# TODO: How to obtain the degree efficiently? Problem is that
		# undirected edges are represented as two edges which must not be
		# counted twice!
		deg = length(union(
			Set{Int64}(inneighbors(g, vertex)),
			Set{Int64}(outneighbors(g, vertex))
		))
		isassigned(deg_str, deg+1) || (deg_str[deg+1] = Set{Int64}())
		push!(deg_str[deg+1], vertex)
		aux_array[vertex] = deg
	end

	aux_array, deg_str
end

function find_min_degree_vertex!(deg_str::Vector{Set{Int64}})::Int64
	# TODO: Optimize by starting at last degree index, not at 1,
	# remember that indice start at 1 but degree 0 is possible
	for deg = 1:length(deg_str)
		isassigned(deg_str, deg) || continue
		!isempty(deg_str[deg]) && return pop!(deg_str[deg])
	end

	-1
end

# g = SimpleDiGraph(3)
# add_edge!(g, 1, 2)
# add_edge!(g, 2, 3)
# add_edge!(g, 3, 2)
# println(degeneracy_ordering(g))