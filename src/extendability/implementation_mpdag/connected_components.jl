
@isdefined(DtGraph) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")

"""
	buckets(g::DtGraph)::Vector{Set{Int64}}

Compute all buckets, i.e., maximum undirected subcomponents, of `g`.

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
julia> buckets(setup_hs(g))
Set{Int64}[]
julia> add_edge!(g, 3, 2)
true
julia> buckets(setup_hs(g))
1-element Vector{Set{Int64}}:
 Set([2, 3])
```
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
	dfs!(g::DtGraph, u::Int64, visited::BitArray)::Set{Int64}

Start a depth first search at vertex `u` in graph `g` and visit
only previously unvisited vertices. `visited` specifies for each
vertex whether it was visited before or not and is updated accordingly.
The result is a set of vertices reachable from `u` via _undirected_
edges only.

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
julia> dfs!(setup_hs(g), 1, falses(3))
Set{Int64} with 1 element:
  1
julia> dfs!(setup_hs(g), 2, falses(3))
Set{Int64} with 2 elements:
  2
  3
```
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