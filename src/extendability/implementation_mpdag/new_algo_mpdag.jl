using LightGraphs

@isdefined(DtGraph) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")
@isdefined(buckets) || include("connected_components.jl")

"""
	mpdag2dag(g::SimpleDiGraph)::SimpleDiGraph

Convert a given MPDAG to a consistent DAG extension. Only works for MPDAGs.

# References
M. Wienöbst, M. Bannach, M. Liśkiewicz (2021).
Extendability of Causal Graphical Models: Algorithms and Computational Complexity.
37th Conference on Uncertainty in Artificial Intelligence, 2021 (UAI 2021).

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> collect(edges(mpdag2dag(g)))
2-element Vector{LightGraphs.SimpleGraphs.SimpleEdge{Int64}}:
 Edge 1 => 2
 Edge 2 => 3
```
"""
function mpdag2dag(g::SimpleDiGraph)::SimpleDiGraph
	result = copy(g)
	graph = setup_hs(g)

	for bucket in buckets(graph)
		mindex = 0
		mapping = Dict()
		invmapping = Dict()
		for v in bucket
			mapping[mindex += 1] = v
			invmapping[v] = mindex
		end
		sg = subgraph(graph, bucket, invmapping)
		(indices, ordering) = amo(sg)
		isamo(sg, (indices, ordering)) || return SimpleDiGraph(0)
		for i = length(ordering):-1:1
			v = mapping[ordering[i]]

			for w in graph.undirected[v]
				rem_edge!(result, v, w)
			end

			remove_vertex_hs!(graph, v)
		end
	end

	result
end

"""
	subgraph(g::DtGraph, bucket::Set{Int64}, m::Dict)::DtGraph

Compute the subgraph induces by the vertices in `bucket`.
`m` is a mapping for vertices which is necessary if the
vertices in `bucket` are not labelled from `1` to `length(bucket)`.
It has to map each vertex in `bucket` to a number between `1` and
`length(bucket)`.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> s = subgraph(setup_hs(g), Set([1, 2]), Dict(1 => 1, 2 => 2))
DtGraph(
	2,
	Set([2, 1]),
	Set{Int64}[],
	Set{Int64}[Set(), Set([1])],
	Set{Int64}[Set([2]), Set()],
	Set{Int64}[Set(), Set()]
)
julia> collect(edges(dtgraph2digraph(s)))
1-element Vector{LightGraphs.SimpleGraphs.SimpleEdge{Int64}}:
 Edge 1 => 2
```
"""
function subgraph(g::DtGraph, bucket::Set{Int64}, m::Dict)::DtGraph
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
			(dir in bucket) && insert_edge_hs!(result, m[vertex], m[dir], true)
		end
		for undir in g.undirected[vertex]
			# No need to check (undir in bucket) as undirected neighbors
			# must be in the same bucket.
			isdone = ("$vertex-$undir" in done)
			!isdone && insert_edge_hs!(result, m[vertex], m[undir], false)
			!isdone && push!(done, "$undir-$vertex")
		end
	end

	result
end

"""
	amo(g::DtGraph)::Tuple{Vector{Int64}, Vector{Int64}}

Compute an acyclic moral orientation (AMO) for a bucket in linear time.
If the input graph does not admit an AMO, the result will not be an AMO
but an arbitrary ordering. The result can be checked via [`isamo`](@ref).

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> amo(setup_hs(g))
([1, 2, 3], [1, 2, 3])
```
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
		push!(ingoing[i] == 0 ? set_noingoing[1] : set[1], i)
	end

	j = 1
	last_nonempty = 1
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
		while j >= 1 && isempty(set_noingoing[j])
			!isempty(set[j]) && (last_nonempty = j+1)
			j -= 1
		end
		j == 0 && (j = last_nonempty)
	end

	(alpha, alphainvers)
end

"""
	isamo(g::DtGraph, ordering::Tuple{Vector{Int64}, Vector{Int64}})::Bool

Check whether a given ordering is an acyclic moral orientation for a bucket.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> dtgraph = setup_hs(g)
DtGraph(
	3,
	Set([2, 3, 1]),
	Set{Int64}[],
	Set{Int64}[Set(), Set([1]), Set([2])],
	Set{Int64}[Set([2]), Set([3]), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
julia> isamo(dtgraph, amo(dtgraph))
true
```
"""
function isamo(g::DtGraph, ordering::Tuple{Vector{Int64}, Vector{Int64}})::Bool
	(orderindex, order) = ordering

	f = zeros(Int64, length(order))
	index = zeros(Int64, length(order))

	for i = length(order):-1:1
		w = order[i]
		f[w] = w
		index[w] = i
		neighbors = union(g.undirected[w], g.outgoing[w], g.ingoing[w])

		for v in neighbors
			orderindex[v] > i || continue
			index[v] = i
			f[v] == v && (f[v] = w)
		end

		for v in neighbors
			orderindex[v] > i && index[f[v]] > i && return false
		end
	end

	true
end