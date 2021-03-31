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
	(aux_array, deg_str) = deg_struct(g) # Compute degrees for each vertex

	# Hashtable for mappings of node labels because rem_vertex! swaps
	# the vertex to be deleted with vertex |V| and deletes vertex |V|
	# from the graph.
	ht = Dict()

	while j > 0
		v = pop_min_deg_vertex!(deg_str)
		v = get(ht, v, v)
		mindeg = aux_array[v]
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

		result[j] = v
		ht[v] = get(ht, get(ht, v, nv(h)), nv(h))
		rem_vertex!(h, v)
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