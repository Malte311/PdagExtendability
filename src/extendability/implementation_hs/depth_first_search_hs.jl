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
	return iscyclic!(graph) ? SimpleDiGraph(0) : copy(g)
end

"""
	iscyclic!(g::DtGraph)::Bool

Checks whether `g` is cyclic by computing a topological sorting using
Kahn's algorithm.
Note that `g` must be fully directed (undirected edges are forbidden).

**Important:** The input must not contain two edges between the same
two nodes (i.e., if an edge u->v exists, v->u is forbidden) because
the internal data structure treats such edges as undirected edges.

# References
Kahn, Arthur B. (1962). Topological sorting of large networks.
Communications of the ACM, 5

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 1, 3)
true
julia> iscyclic!(setup_hs(g))
false
```
"""
function iscyclic!(g::DtGraph)::Bool
	n = g.numvertices
	order = Vector{Int64}(undef, n)

	# Stack with vertices that do not have incoming edges
	stack = Vector{Int64}()
	for v = 1:n
		isempty(g.ingoing[v]) && push!(stack, v)
	end

	index = 0
	while !isempty(stack)
		v = pop!(stack)
		order[index += 1] = v
		for u in g.outgoing[v]
			delete!(g.ingoing[u], v)
			isempty(g.ingoing[u]) && push!(stack, u)
		end
	end

	# If there are edges left in the graph, it contains a cycle
	reduce(&, map(x -> isempty(x), g.ingoing), init = true) ? false : true
end