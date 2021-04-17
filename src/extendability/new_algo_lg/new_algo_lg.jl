using LightGraphs

include("new_algo_datastructure_lg.jl")

"""
	fastpdag2dag_lg(g::SimpleDiGraph)::SimpleDiGraph

Convert a partially directed acyclic graph (PDAG) into a fully
directed acyclic graph (DAG). If this is not possible, an empty
graph is returned.

Undirected edges are represented as two directed edges.

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
function fastpdag2dag_lg(g::SimpleDiGraph)::SimpleDiGraph
	graph = standardsetup_lg(g)

	extendgraph_lg(g, graph)
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
	graph = init_lg(nv(g))
	done = Set{String}()

	for e in edges(g)
		isundirected = fast_has_edge(g, e.dst, e.src)

		if isundirected
			!("$(e.src)-$(e.dst)" in done) && insert_edge_lg!(graph, e.src, e.dst)
			push!(done, "$(e.dst)-$(e.src)") # Mark edge as done
		else
			insert_arc_lg!(graph, e.src, e.dst)
		end
	end

	graph
end

"""
	extendgraph_lg(g::SimpleDiGraph, graph::Graph)::SimpleDiGraph

Extend a given graph represented by the datastructure.

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
Graph(
	{3, 3} directed simple Int64 graph,
	[0, 0, 0],
	[0, 0, 0],
	[1, 0, 0],
	[0, 1, 1],
	[0, 1, 0],
	[0, 1, 1]
)
julia> extendgraph_lg(g, graph)
{3, 2} directed simple Int64 graph
```
"""
function extendgraph_lg(g::SimpleDiGraph, graph::Graph)::SimpleDiGraph
	result = copy(g)

	ps = list_ps_lg(graph)

	while !isempty(ps)
		s = pop!(ps)

		for undirected in outneighbors(graph.g, s)
			rem_edge!(result, s, undirected)
		end

		newps = pop_ps_lg!(graph, s)
		isempty(newps) || push!(ps, newps...)
	end

	isempty(edges(graph.g)) || return SimpleDiGraph(0)

	result
end