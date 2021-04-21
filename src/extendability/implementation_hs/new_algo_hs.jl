using LightGraphs

include("new_algo_datastructure_hs.jl")
include("new_algo_optimization_hs.jl")

"""
	fastpdag2dag_hs(g::SimpleDiGraph, optimize::Bool = false)::SimpleDiGraph

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
julia> dag = fastpdag2dag_hs(g)
{3, 2} directed simple Int64 graph
julia> collect(edges(dag))
2-element Array{LightGraphs.SimpleGraphs.SimpleEdge{Int64},1}:
 Edge 1 => 2
 Edge 2 => 3
julia> dag = fastpdag2dag_hs(g, true)
{3, 2} directed simple Int64 graph
julia> collect(edges(dag))
2-element Array{LightGraphs.SimpleGraphs.SimpleEdge{Int64},1}:
 Edge 1 => 2
 Edge 2 => 3
```
"""
function fastpdag2dag_hs(g::SimpleDiGraph, optimize::Bool = false)::SimpleDiGraph
	# Set up the datastructure.
	hg = optimize ? optimizedsetup_hs(g) : standardsetup_hs(g)

	# Compute result and return it.
	extendgraph_hs(g, hg)
end

"""
	standardsetup_hs(g::SimpleDiGraph)::HybridGraph

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
julia> standardsetup_hs(g)
HybridGraph(
	DirectedGraph(
		Set{Int64}[Set(), Set([3]), Set([2])],
		[0, 1, 1],
		[0, 1, 1],
		Set{Int64}[Set(), Set([3]), Set([2])],
		Set{Int64}[Set(), Set([3]), Set([2])]
	),
	DirectedGraph(
		Set{Int64}[Set([2]), Set([1]), Set()],
		[1, 0, 0],
		[0, 1, 0],
		Set{Int64}[Set(), Set([1]), Set()],
		Set{Int64}[Set([2]), Set(), Set()]
	),
	[0, 0, 0],
	[0, 0, 0]
)
```
"""
function standardsetup_hs(g::SimpleDiGraph)::HybridGraph
	hg = init_hs(nv(g))
	done = Set{String}()

	for e in edges(g)
		isundirected = has_edge(g, e.dst, e.src)

		if isundirected
			isdone = ("$(e.src)-$(e.dst)" in done)
			!isdone && insert_edge_hs!(hg, e.src, e.dst)
			!isdone && push!(done, "$(e.dst)-$(e.src)") # Mark edge as done
		else
			insert_arc_hs!(hg, e.src, e.dst)
		end
	end

	hg
end

"""
	optimizedsetup_hs(g::SimpleDiGraph)::HybridGraph

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
julia> optimizedsetup_hs(g)
HybridGraph(
	DirectedGraph(
		Set{Int64}[Set(), Set([3]), Set([2])],
		[0, 1, 1],
		[0, 1, 1],
		Set{Int64}[Set(), Set([3]), Set([2])],
		Set{Int64}[Set(), Set([3]), Set([2])]
	),
	DirectedGraph(
		Set{Int64}[Set([2]), Set([1]), Set()],
		[1, 0, 0],
		[0, 1, 0],
		Set{Int64}[Set(), Set([1]), Set()],
		Set{Int64}[Set([2]), Set(), Set()]
	),
	[0, 0, 0],
	[0, 0, 0]
)
```
"""
function optimizedsetup_hs(g::SimpleDiGraph)::HybridGraph
	hg = init_hs(nv(g))
	done = Set{String}()

	for v in degeneracy_ordering_hs(g)
		for adj in all_neighbors(g, v)
			adj < v || continue # Insert edges to preceding neighbors only

			is_ingoing = has_edge(g, adj, v)
			is_outgoing = has_edge(g, v, adj)
			if is_ingoing && is_outgoing # Edge is undirected
				!("$v-$adj" in done) && insert_edge_hs!(hg, v, adj)
				push!(done, "$adj-$v") # Mark edge as done
			else # Edge is directed
				is_ingoing && insert_arc_hs!(hg, adj, v)
				is_outgoing && insert_arc_hs!(hg, v, adj)
			end
		end
	end

	hg
end

"""
	extendgraph_hs(g::SimpleDiGraph, hg::HybridGraph)::SimpleDiGraph

Compute the extension of graph hg.

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
julia> hg = standardsetup_hs(g)
...
julia> extendgraph_hs(g, hg)
{3, 2} directed simple Int64 graph
```
"""
function extendgraph_hs(g::SimpleDiGraph, hg::HybridGraph)::SimpleDiGraph
	result = copy(g)

	ps = list_ps_hs(hg)

	while !isempty(ps)
		s = pop!(ps)

		# Direct all edges incident to ps towards ps.
		for undirected in hg.g1.adjlist[s]
			rem_edge!(result, s, undirected)
		end

		newps = pop_ps_hs!(hg, s)
		isempty(newps) || push!(ps, newps...)
	end

	# The graph is not extendable if no potential sinks are left but there
	# are still edges in the graph.
	sum(hg.g1.deltaplus) + sum(hg.g2.deltaplus) == 0 || return SimpleDiGraph(0)

	result
end