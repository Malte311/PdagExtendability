using LightGraphs

include("new_algo_datastructure_lg.jl")

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

	ordering = vertex_ordering_lg(graph)

	extendgraph_lg(g, ordering)
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

TODO
"""
function optimizedsetup_lg(g::SimpleDiGraph)::Graph
	graph = init_lg(g)
	graph
end

"""
	TODO
"""
function vertex_ordering_lg(graph::Graph)::Vector{Int64}
	result = Vector{Int64}(undef, nv(graph.g))
	index = 1

	ps = Set{Int64}(list_ps_lg(graph))

	while !isempty(ps)
		s = pop!(ps)

		result[index] = s
		index += 1

		newps = pop_ps_lg!(graph, s)
		isempty(newps) || push!(ps, newps...)
	end

	isempty(edges(graph.g)) || return []

	result
end


function extendgraph_lg(g::SimpleDiGraph, ordering::Vector{Int64})::SimpleDiGraph
	!isempty(ordering) || return SimpleDiGraph(0)

	result = copy(g)

	for s in ordering
		oldlength = length(result.fadjlist[s])
		filter!(u -> !has_edge(result, u, s), result.fadjlist[s])
		result.ne -= (oldlength - length(result.fadjlist[s]))
	end

	result
end