using LightGraphs


function degeneracy_ordering_lg(g::SimpleDiGraph)::Vector{Int64}
	j = nv(g)
	h = copy(g)
	result = Vector{Int64}(undef, j)

	# Compute initial degrees for each vertex, updated in each iteration
	(aux_array, deg_str) = deg_struct_lg(g)

	while j > 0
		v = pop_min_deg_vertex_lg!(deg_str)

		for adj in Set(all_neighbors(h, v))
			update_deg_lg!(adj, aux_array, deg_str)
			has_edge(h, adj, v) && rem_edge!(h, adj, v)
			has_edge(h, v, adj) && rem_edge!(h, v, adj)
		end

		result[j] = v
		j -= 1
	end

	result
end


function deg_struct_lg(g::SimpleDiGraph)::Tuple{Vector{Int64}, Vector{Set{Int64}}}
	n = nv(g)
	aux_array = Vector{Int64}(undef, n)
	deg_str = [Set{Int64}() for _ in 1:n]

	for v = 1:n
		deg = length(Set(all_neighbors(g, v)))
		aux_array[v] = deg
		push!(deg_str[deg+1], v)
	end

	aux_array, deg_str
end


function pop_min_deg_vertex_lg!(degs::Vector{Set{Int64}})::Int64
	for deg = 1:length(degs)
		!isempty(degs[deg]) && return pop!(degs[deg])
	end

	-1
end


function update_deg_lg!(v::Int64, aux::Vector{Int64}, degs::Vector{Set{Int64}})
	index = aux[v]+1 # Index 1 holds degree 0, index 2 degree 1, and so on
	delete!(degs[index], v)
	push!(degs[index-1], v)
	aux[v] -= 1
end