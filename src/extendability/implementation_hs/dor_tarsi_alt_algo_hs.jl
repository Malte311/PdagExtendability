using LightGraphs

@isdefined(setup_hs) || include("dor_tarsi_algo_datastructure_hs.jl")

"""
	altpdag2dag_hs(g::SimpleDiGraph)::SimpleDiGraph

Alternative implementation of [`pdag2dag_hs`](@ref). Computes a list
of sinks at the beginning. As long as there are sinks left, removes
a sink from the graph and checks for all previous neighbors if they
became a sink now. If so, adds them to the list of sinks.
Terminates when no sinks are left or all vertices are removed.

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
julia> dag = altpdag2dag_hs(g)
{3, 2} directed simple Int64 graph
julia> collect(edges(dag))
2-element Vector{LightGraphs.SimpleGraphs.SimpleEdge{Int64}}:
 Edge 1 => 2
 Edge 2 => 3
```
"""
function altpdag2dag_hs(g::SimpleDiGraph)::SimpleDiGraph
	result = copy(g)
	temp = setup_hs(g)

	# List of potential sinks.
	s = Set(list_sinks_hs(temp))

	while length(temp.vertices) > 1
		!isempty(s) || return SimpleDiGraph(0)
		x = pop!(s)

		# Direct all adjacent edges towards x
		for neighbor in temp.undirected[x]
			rem_edge!(result, x, neighbor)
		end

		old_neighbors = union(temp.ingoing[x], temp.undirected[x])
		
		remove_vertex_hs!(temp, x)

		# Check for previous neighbors if they are now a sink.
		for n in old_neighbors
			is_sink_hs(temp, n) && push!(s, n)
		end
	end

	result
end

"""
	list_sinks_hs(graph::DtGraph)::Vector{Int64}

Compute a list of sinks in the given graph.

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
julia> setup = setup_hs(g)
...
julia> list_sinks_hs(setup)
1-element Vector{Int64}:
 3
```
"""
function list_sinks_hs(graph::DtGraph)::Vector{Int64}
	result = Vector{Int64}()

	for vertex in graph.vertices
		is_sink_hs(graph, vertex) && push!(result, vertex)
	end

	result
end

"""
	is_sink_hs(graph::DtGraph, x::Int64)::Bool

Check whether vertex x is a sink in the given graph.

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
julia> setup = setup_hs(g)
...
julia> is_sink_hs(setup, 1)
false
julia> is_sink_hs(setup, 3)
true
```
"""
function is_sink_hs(graph::DtGraph, x::Int64)::Bool
	isempty(graph.outgoing[x]) || return false

	# All vertices connected to x via an undirected edge
	# must be adjacent to all vertices adjacent to x.
	for neighbor in graph.undirected[x]
		for other in union(graph.ingoing[x], graph.undirected[x])
			neighbor != other || continue
			isadjacent_hs(graph, neighbor, other) || return false
		end
	end

	true
end