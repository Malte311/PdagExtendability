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
	(aux_array, deg_struct) = degree_structure(g)

	while j > 0
		v = find_min_degree_vertex(deg_struct)
		push!(result, v)
		rem_vertex!(h, v) # TODO: Mark as deleted or use mapping
		j -= 1
	end

	reverse(result)
end


function degree_structure(g::SimpleDiGraph)::(Vector{Int64}, Vector{Set{Int64}})
	n = nv(g)
	deg_struct = Vector{Set{Int64}}(undef, n)
	aux_array = Vector{Int64}(undef, n)

	for vertex = 1:n
		# TODO: How to obtain the degree efficiently? Problem is that undirected
		# edges are represented as two edges which must not be counted twice!
		degree = length(intersect(
			Set{Int64}(inneighbors(g, vertex)),
			Set{Int64}(outneighbors(g, vertex))
		))
		isassigned(deg_struct, degree) || (deg_struct[degree] = Set{Int64}())
		push!(deg_struct[degree], vertex)
		aux_array[vertex] = degree
	end

	(aux_array, deg_struct)
end

function find_min_degree_vertex(deg_struct::Vector{Set{Int64}})::Int64
	# TODO: Optimize by starting at last degree index, not at 1
	for deg = 1:length(deg_struct)
		isassigned(deg_struct, deg) || continue
		!isempty(deg_struct[deg]) && return pop!(deg_struct[deg])
	end

	-1
end