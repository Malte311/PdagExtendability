using LightGraphs

@isdefined(setup_hs) || include("dor_tarsi_algo_datastructure_hs.jl")

"""
	dir2dag(g::SimpleDiGraph)::SimpleDiGraph

Convert a directed graph into a fully directed acyclic graph (DAG).
If this is not possible, an empty graph is returned.

Note that this function only works for fully directed input graphs
as it simply checks acyclicity of the input graph.

**Important:** The input must not contain two edges between the same
two nodes (i.e., if an edge u->v exists, v->u is forbidden) because
the internal data structure treats such edges as undirected edges.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 1, 3)
true
julia> collect(edges(dir2dag(g)))
2-element Vector{LightGraphs.SimpleGraphs.SimpleEdge{Int64}}:
 Edge 1 => 2
 Edge 1 => 3
```
"""
function dir2dag(g::SimpleDiGraph)::SimpleDiGraph
	graph = setup_hs(g)
	return iscyclic(graph) ? SimpleDiGraph(0) : copy(g)
end

"""
	iscyclic(g::DtGraph)::Bool

Checks whether `g` is cyclic using depth first search. Note that
`g` must be fully directed (undirected edges are forbidden).

**Important:** The input must not contain two edges between the same
two nodes (i.e., if an edge u->v exists, v->u is forbidden) because
the internal data structure treats such edges as undirected edges.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 1, 3)
true
julia> iscyclic(setup_hs(g))
false
```
"""
function iscyclic(g::DtGraph)::Bool
	n = g.numvertices
	n >= 1 || return false

	visited = falses(n)
	stack = Vector()
	push!(stack, 1) # We already made sure that at least one vertex exists

	while !isempty(stack)
		v = pop!(stack)
		!visited[v] || return true
		visited[v] = true
		for u in g.outgoing[v]
			!visited[u] || return true
			push!(stack, u)
		end
	end

	return false
end