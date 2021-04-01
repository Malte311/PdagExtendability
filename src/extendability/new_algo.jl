using LightGraphs

include("new_algo_datastructure.jl")
include("new_algo_optimization.jl")

"""
	fastpdag2dag(g::SimpleDiGraph, optimize::Bool = false)::SimpleDiGraph

Convert a partially directed acyclic graph (PDAG) into a fully
directed acyclic graph (DAG). If this is not possible, an empty
graph is returned.

Undirected edges are represented as two directed edges.

If the parameter optimize is omitted or set to false, the algorithm runs in
time O(Δm) with Δ being the maximum degree of g and m the number of edges in
g. Setting optimize to true will yield an algorithm in time O(dm), where d
is the degeneracy of the skeleton.

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
julia> dag = fastpdag2dag(g)
{3, 2} directed simple Int64 graph
julia> collect(edges(dag))
2-element Array{LightGraphs.SimpleGraphs.SimpleEdge{Int64},1}:
 Edge 1 => 2
 Edge 2 => 3
julia> dag = fastpdag2dag(g, true)
{3, 2} directed simple Int64 graph
julia> collect(edges(dag))
2-element Array{LightGraphs.SimpleGraphs.SimpleEdge{Int64},1}:
 Edge 1 => 2
 Edge 2 => 3
```
"""
function fastpdag2dag(g::SimpleDiGraph, optimize::Bool = false)::SimpleDiGraph
	result = copy(g)
	
	# Set up the datastructure.
	hg = optimize ? optimizedsetup(g) : standardsetup(g)

	ps = list_ps(hg)

	while !isempty(ps)
		s = pop!(ps)

		# Direct all edges incident to ps towards ps.
		isassigned(hg.g1.adjlist, s) || (hg.g1.adjlist[s] = Set{Int64}())
		for undirected in hg.g1.adjlist[s]
			rem_edge!(result, s, undirected)
		end
		
		newps = pop_ps!(hg, s)
		isempty(newps) || push!(ps, newps...)
	end

	# The graph is not extendable if no potential sinks are left but there
	# are still edges in the graph.
	isassigned(hg.g1.deltaplus) || (hg.g1.deltaplus = Vector{Int64}())
	isassigned(hg.g2.deltaplus) || (hg.g2.deltaplus = Vector{Int64}())
	sum(hg.g1.deltaplus) + sum(hg.g2.deltaplus) == 0 || return SimpleDiGraph(0)

	result
end

"""
	standardsetup(g::SimpleDiGraph)::HybridGraph

Set up the datastructure for the algorithm with time complexity O(Δm).

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
julia> standardsetup(g)
HybridGraph(
	DirectedGraph(
		Set{Int64}[Set(), Set([3]), Set([2])],
		[0, 1, 1],
		[0, 1, 1],
		Set{Int64}[#undef, Set([3]), Set([2])],
		Set{Int64}[#undef, Set([3]), Set([2])]
	),
	DirectedGraph(
		Set{Int64}[Set([2]), Set([1]), Set()],
		[1, 0, 0],
		[0, 1, 0],
		Set{Int64}[#undef, Set([1]), #undef],
		Set{Int64}[Set([2]), Set(), Set()]
	),
	[0, 0, 0],
	[0, 0, 0]
)
```
"""
function standardsetup(g::SimpleDiGraph)::HybridGraph
	hg = init(nv(g))
	done = Set{String}()

	for e in edges(g)
		isundirected = has_edge(g, e.dst, e.src)

		if isundirected
			key = "$(e.src)-$(e.dst)"
			!("$(e.src)-$(e.dst)" in done) && insert_edge!(hg, e.src, e.dst)
			push!(done, "$(e.dst)-$(e.src)") # Mark edge as done
		else
			insert_arc!(hg, e.src, e.dst)
		end
	end

	hg
end

"""
	optimizedsetup(g::SimpleDiGraph)::HybridGraph

Set up the datastructure for the algorithm with time complexity O(dm).

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
julia> optimizedsetup(g)
HybridGraph(
	DirectedGraph(
		Set{Int64}[Set(), Set([3]), Set([2])],
		[0, 1, 1],
		[0, 1, 1],
		Set{Int64}[#undef, Set([3]), Set([2])],
		Set{Int64}[#undef, Set([3]), Set([2])]
	),
	DirectedGraph(
		Set{Int64}[Set([2]), Set([1]), Set()],
		[1, 0, 0],
		[0, 1, 0],
		Set{Int64}[#undef, Set([1]), #undef],
		Set{Int64}[Set([2]), Set(), Set()]
	),
	[0, 0, 0],
	[0, 0, 0]
)
```
"""
function optimizedsetup(g::SimpleDiGraph)::HybridGraph
	hg = init(nv(g))
	done = Set{String}()

	for v in degeneracy_ordering(g)
		for adj in all_neighbors(g, v)
			adj < v || continue # Insert edges to preceding neighbors only

			is_ingoing = has_edge(g, adj, v)
			is_outgoing = has_edge(g, v, adj)
			if is_ingoing && is_outgoing # Edge is undirected
				!("$v-$adj" in done) && insert_edge!(hg, v, adj)
				push!(done, "$adj-$v") # Mark edge as done
			else # Edge is directed
				is_ingoing && insert_arc!(hg, adj, v)
				is_outgoing && insert_arc!(hg, v, adj)
			end
		end
	end

	hg
end