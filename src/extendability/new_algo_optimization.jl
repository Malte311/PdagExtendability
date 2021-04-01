using LightGraphs

"""
	degeneracy_ordering(g::SimpleDiGraph)::Vector{Int64}

Compute a degeneracy ordering for the skeleton of the graph g.

# References
David W. Matula, Leland L. Beck (1983).
Smallest-last ordering and clustering and graph coloring algorithms.
Journal of the ACM, 30(3):417–427.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> add_edge!(g, 3, 2)
true
julia> degeneracy_ordering(g)
3-element Array{Int64,1}:
 1
 2
 3
```
"""
function degeneracy_ordering(g::SimpleDiGraph)::Vector{Int64}
	j = nv(g)
	h = copy(g)
	result = Vector{Int64}(undef, j)

	# Compute initial degrees for each vertex, updated in each iteration
	(aux_array, deg_str) = deg_struct(g)

	while j > 0
		v = pop_min_deg_vertex!(deg_str)

		for adj in union(Set(inneighbors(h, v)), Set(outneighbors(h, v)))
			update_deg!(adj, aux_array, deg_str)
			has_edge(h, adj, v) && rem_edge!(h, adj, v)
			has_edge(h, v, adj) && rem_edge!(h, v, adj)
		end

		result[j] = v
		j -= 1
	end

	result
end

"""
	deg_struct(g::SimpleDiGraph)::Tuple{Vector{Int64}, Vector{Set{Int64}}}

Compute the degree structure for the graph g. Return a tuple consisting of an
array holding the degree for each vertex in g and an array where each index
represents a degree (index 1 for degree 0, index 2 for degree 1, ..., index n
for degree n-1) and holds a set of vertices which have that degree.

For example, if we have three vertices 1, 2, 3 with degree 1, 2, and 1,
respectively, we obtain the following degree structure:
([1, 2, 1], [Set(), Set([1, 3]), Set([2])])

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> add_edge!(g, 3, 2)
true
julia> deg_struct(g)
([1, 2, 1], Set{Int64}[#undef, Set([3, 1]), Set([2])])
```
"""
function deg_struct(g::SimpleDiGraph)::Tuple{Vector{Int64}, Vector{Set{Int64}}}
	n = nv(g)
	aux_array = Vector{Int64}(undef, n)
	deg_str = Vector{Set{Int64}}(undef, n)

	for v = 1:n
		deg = length(union(Set(inneighbors(g, v)), Set(outneighbors(g, v))))
		aux_array[v] = deg
		isassigned(deg_str, deg+1) || (deg_str[deg+1] = Set{Int64}())
		push!(deg_str[deg+1], v)
	end

	aux_array, deg_str
end

"""
	pop_min_deg_vertex!(degs::Vector{Set{Int64}})::Int64

Find the vertex with minimum degree in the given degree structure. The
vertex will be removed from the structure before returning it. In case
there are multiple vertices with the same minimum degree, there is no
specific order of choosing them, i.e., any of those vertices is returned.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> add_edge!(g, 3, 2)
true
julia> (_, degs) = deg_struct(g)
([1, 2, 1], Set{Int64}[#undef, Set([3, 1]), Set([2])])
julia> pop_min_deg_vertex!(degs)
3
```
"""
function pop_min_deg_vertex!(degs::Vector{Set{Int64}})::Int64
	for deg = 1:length(degs)
		isassigned(degs, deg) || continue
		!isempty(degs[deg]) && return pop!(degs[deg])
	end

	-1
end

"""
	update_deg!(v::Int64, aux::Vector{Int64}, degs::Vector{Set{Int64}})

Update the degree of a vertex after an adjacent vertex has been removed,
i.e., reduce the degree by one and move it into the correct set in the
degree structure.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> add_edge!(g, 3, 2)
true
julia> (aux, degs) = deg_struct(g)
([1, 2, 1], Set{Int64}[#undef, Set([3, 1]), Set([2])])
julia> update_deg!(3, aux, degs)
julia> (aux, degs)
([1, 2, 0], Set{Int64}[Set([3]), Set([1]), Set([2])])
```
"""
function update_deg!(v::Int64, aux::Vector{Int64}, degs::Vector{Set{Int64}})
	index = aux[v]+1 # Index 1 holds degree 0, index 2 degree 1, and so on
	delete!(degs[index], v)
	isassigned(degs, index-1) || (degs[index-1] = Set{Int64}())
	push!(degs[index-1], v)
	aux[v] -= 1
end