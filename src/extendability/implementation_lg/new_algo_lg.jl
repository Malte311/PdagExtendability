using LightGraphs

include("new_algo_datastructure_lg.jl")
include("new_algo_optimization_lg.jl")

"""
	fastpdag2dag_lg(g::SimpleDiGraph, optimize::Bool = false)::SimpleDiGraph

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
julia> dag = fastpdag2dag_lg(g)
{3, 2} directed simple Int64 graph
julia> collect(edges(dag))
2-element Array{LightGraphs.SimpleGraphs.SimpleEdge{Int64},1}:
 Edge 1 => 2
 Edge 2 => 3
```
"""
function fastpdag2dag_lg(g::SimpleDiGraph, optimize::Bool = false)::SimpleDiGraph
	graph = optimize ? optimizedsetup_lg(g) : standardsetup_lg(g)

	extendgraph_lg(graph)
end

"""
	standardsetup_lg(g::SimpleDiGraph)::Graph

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
julia> standardsetup_lg(g)
Graph(
	{3, 3} directed simple Int64 graph,
	[0, 0, 0],
	[0, 0, 0],
	[1, 0, 0],
	[0, 1, 1],
	[0, 1, 0],
	[0, 1, 1]
)
```
"""
function standardsetup_lg(g::SimpleDiGraph)::Graph
	graph = init_lg(g)

	init_auxvectors_lg!(graph)

	graph
end

"""
	optimizedsetup_lg(g::SimpleDiGraph)::Graph

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
julia> optimizedsetup_lg(g)
Graph(
	{3, 3} directed simple Int64 graph,
	[0, 0, 0],
	[0, 0, 0],
	[1, 0, 0],
	[0, 1, 1],
	[0, 1, 0],
	[0, 1, 1]
)
```
"""
function optimizedsetup_lg(g::SimpleDiGraph)::Graph
	graph = init_lg(g)
	done = Set{String}()

	for v in degeneracy_ordering_lg(g)
		for adj in all_neighbors(g, v)
			adj < v || continue # Insert edges to preceding neighbors only

			is_ingoing = has_edge(g, adj, v)
			is_outgoing = has_edge(g, v, adj)
			if is_ingoing && is_outgoing # Edge is undirected
				isdone = ("$v-$adj" in done)
				!isdone && insert_edge_lg!(graph, v, adj)
				!isdone && push!(done, "$adj-$v") # Mark edge as done
			else # Edge is directed
				is_ingoing && insert_arc_lg!(graph, adj, v)
				is_outgoing && insert_arc_lg!(graph, v, adj)
			end
		end
	end

	graph
end

"""
	extendgraph_lg(graph::Graph)::SimpleDiGraph

Compute the extension of the given graph.

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
julia> graph = standardsetup_lg(g)
...
julia> extendgraph_lg(graph)
{3, 2} directed simple Int64 graph
```
"""
function extendgraph_lg(graph::Graph)::SimpleDiGraph
	result = copy(graph.g)

	ps = Set{Int64}(list_ps_lg(graph))

	while !isempty(ps)
		s = pop!(ps)

		# Direct all adjacent edges towards x
		for neighbor in outneighbors(graph.g, s)
			rem_edge!(result, s, neighbor)
		end

		newps = pop_ps_lg!(graph, s)
		isempty(newps) || push!(ps, newps...)
	end

	isempty(edges(graph.g)) || return SimpleDiGraph(0)

	result
end