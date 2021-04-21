using LightGraphs

"""
The datastructure to store a partially directed graph, using the
LightGraphs library internally.
"""
mutable struct Graph
	g::SimpleDiGraph     # The actual graph
	alpha::Vector{Int64} # Number of undirected neighbors that are adjacent
	                     # to another undirected neighbor for each vertex
	beta::Vector{Int64}  # Number of undirected neighbors that are adjacent
	                     # to an ingoing neighbor for each vertex
	deltaplus_dir::Vector{Int64}    # Out-degree for each vertex (directed)
	deltaplus_undir::Vector{Int64}  # Out-degree for each vertex (undirected)
	deltaminus_dir::Vector{Int64}   # In-degree for each vertex (directed)
	deltaminus_undir::Vector{Int64} # In-degree for each vertex (undirected)
end

"""
	init_lg(g::SimpleDiGraph)::Graph

Allocate memory for the HybridGraph datastructure
representing a graph with n vertices.

# Examples
```julia-repl
julia> g = init_lg(SimpleDiGraph(3))
Graph(
	{3, 0} directed simple Int64 graph,
	[0, 0, 0],
	[0, 0, 0],
	[0, 0, 0],
	[0, 0, 0],
	[0, 0, 0],
	[0, 0, 0]
)
```
"""
function init_lg(g::SimpleDiGraph)::Graph
	n = nv(g)

	Graph(
		copy(g),
		fill(0, n),
		fill(0, n),
		fill(0, n),
		fill(0, n),
		fill(0, n),
		fill(0, n)
	)
end

"""
	is_adjacent_lg(graph::Graph, u::Int64, v::Int64)::Bool

Check whether vertices u and v are adjacent in the given graph.

# Examples
```julia-repl
julia> g = init_lg(3)
...
julia> is_adjacent_lg(g, 1, 2)
false
julia> insert_arc_lg!(g, 1, 2)
julia> is_adjacent_lg(g, 1, 2)
true
```
"""
function is_adjacent_lg(graph::Graph, u::Int64, v::Int64)::Bool
	has_edge(graph.g, u, v) || has_edge(graph.g, v, u)
end

"""
	is_directed_lg(graph::Graph, u::Int64, v::Int64)::Bool

Check whether the given graph contains a directed edge from u to v.

# Examples
```julia-repl
julia> g = init_lg(3)
...
julia> insert_arc_lg!(g, 1, 2)
julia> is_directed_lg(g, 1, 2)
true
```
"""
function is_directed_lg(graph::Graph, u::Int64, v::Int64)::Bool
	!has_edge(graph.g, v, u) && has_edge(graph.g, u, v)
end

"""
	is_undirected_lg(graph::Graph, u::Int64, v::Int64)::Bool

Check whether the given graph contains an undirected edge between u and v.

# Examples
```julia-repl
julia> g = init_lg(3)
...
julia> insert_arc_lg!(g, 1, 2)
julia> is_undirected_lg(g, 1, 2)
false
```
"""
function is_undirected_lg(graph::Graph, u::Int64, v::Int64)::Bool
	has_edge(graph.g, u, v) && has_edge(graph.g, v, u)
end

"""
	insert_arc_lg!(graph::Graph, u::Int64, v::Int64)

Insert an arc (a directed edge) from u to v into the given graph.

# Examples
```julia-repl
julia> g = init_lg(3)
...
julia> insert_arc_lg!(g, 1, 2)
julia> is_adjacent_lg(g, 1, 2)
true
```
"""
function insert_arc_lg!(graph::Graph, u::Int64, v::Int64)
	graph.deltaplus_dir[u] += 1
	graph.deltaminus_dir[v] += 1
end

"""
	insert_edge_lg!(graph::Graph, u::Int64, v::Int64)

Insert an undirected edge between u and v into the given graph.

# Examples
```julia-repl
julia> g = init_lg(3)
...
julia> insert_edge_lg!(g, 2, 3)
julia> is_adjacent_lg(g, 2, 3)
true
```
"""
function insert_edge_lg!(graph::Graph, u::Int64, v::Int64)
	graph.deltaplus_undir[u] += 1
	graph.deltaminus_undir[v] += 1
	graph.deltaplus_undir[v] += 1
	graph.deltaminus_undir[u] += 1
end

"""
	remove_arc_lg!(graph::Graph, u::Int64, v::Int64)

Remove an arc (a directed edge) from u to v from the given graph.

# Examples
```julia-repl
julia> g = init_lg(3)
...
julia> insert_arc_lg!(g, 1, 2)
julia> is_adjacent_lg(g, 1, 2)
true
julia> remove_arc_lg!(g, 1, 2)
julia> is_adjacent_lg(g, 1, 2)
false
```
"""
function remove_arc_lg!(graph::Graph, u::Int64, v::Int64)
	rem_edge!(graph.g, u, v)

	graph.deltaplus_dir[u] -= 1
	graph.deltaminus_dir[v] -= 1

	update_alphabeta_lg!(graph, u, v, -1, true)
end

"""
	remove_edge_lg!(graph::Graph, u::Int64, v::Int64)

Remove an undirected edge between u and v from the given graph.

# Examples
```julia-repl
julia> g = init_lg(3)
...
julia> insert_edge_lg!(g, 2, 3)
julia> is_adjacent_lg(g, 2, 3)
true
julia> remove_edge_lg!(g, 2, 3)
julia> is_adjacent_lg(g, 2, 3)
false
```
"""
function remove_edge_lg!(graph::Graph, u::Int64, v::Int64)
	rem_edge!(graph.g, u, v)
	rem_edge!(graph.g, v, u)

	graph.deltaplus_undir[u] -= 1
	graph.deltaminus_undir[v] -= 1
	graph.deltaplus_undir[v] -= 1
	graph.deltaminus_undir[u] -= 1

	update_alphabeta_lg!(graph, u, v, -1, false)
end

"""
	update_alphabeta_lg!(g::Graph, u::Int64, v::Int64, val::Int64, is_uv_dir::Bool)

Update values for alpha and beta in g. Either add to (positive value for val)
or subtract from (negative value for val) alpha and beta. The parameter
is_uv_dir indicates whether the edge between u and v is directed from u to v.

Is called internally whenever an edge (both directed and undirected) is
inserted or removed. Do not call this function by hand.
"""
function update_alphabeta_lg!(g::Graph, u::Int64, v::Int64, val::Int64, is_uv_dir::Bool)
	for x in all_neighbors(g.g, u)
		is_adjacent_lg(g, x, v) || continue

		is_ux_undir = is_undirected_lg(g, u, x)
		is_vx_undir = is_undirected_lg(g, v, x)

		!is_uv_dir && is_ux_undir && (g.alpha[u] += val)
		!is_uv_dir && is_directed_lg(g, x, u) && (g.beta[u] += val)

		!is_uv_dir && is_vx_undir && (g.alpha[v] += val)
		is_uv_dir  && is_vx_undir && (g.beta[v] += val)
		!is_uv_dir && is_directed_lg(g, x, v) && (g.beta[v] += val)

		is_ux_undir && is_vx_undir && (g.alpha[x] += val)
		is_vx_undir && is_directed_lg(g, u, x) && (g.beta[x] += val)
		is_ux_undir && is_directed_lg(g, v, x) && (g.beta[x] += val)
	end
end

"""
	TODO
"""
function init_auxvectors_lg!(g::Graph)
	done = Set{String}()

	for e in edges(g.g)
		u = e.src
		v = e.dst

		!("$u-$v" in done) || continue

		is_uv_dir = !has_edge(g.g, v, u)
		is_uv_dir && insert_arc_lg!(g, u, v)
		!is_uv_dir && insert_edge_lg!(g, u, v)

		for x in all_neighbors(g.g, u)
			is_adjacent_lg(g, x, v) || continue

			is_ux_undir = is_undirected_lg(g, u, x)
			(!("$u-$x" in done) && (!is_ux_undir || !("$x-$u" in done))) || continue
			is_vx_undir = is_undirected_lg(g, v, x)
			(!("$v-$x" in done) && (is_vx_undir || !("$x-$v" in done))) || continue
	
			!is_uv_dir && is_ux_undir && (g.alpha[u] += 1)
			!is_uv_dir && is_directed_lg(g, x, u) && (g.beta[u] += 1)
	
			!is_uv_dir && is_vx_undir && (g.alpha[v] += 1)
			is_uv_dir  && is_vx_undir && (g.beta[v] += 1)
			!is_uv_dir && is_directed_lg(g, x, v) && (g.beta[v] += 1)
	
			is_ux_undir && is_vx_undir && (g.alpha[x] += 1)
			is_vx_undir && is_directed_lg(g, u, x) && (g.beta[x] += 1)
			is_ux_undir && is_directed_lg(g, v, x) && (g.beta[x] += 1)
		end

		push!(done, "$u-$v")
		!is_uv_dir && push!(done, "$v-$u")
	end
end

"""
	is_ps_lg(g::Graph, s::Int64)::Bool

Determine whether s is a potential sink in g.

# Examples
```julia-repl
julia> g = init_lg(3)
...
julia> is_ps_lg(g, 1)
true
julia> insert_arc_lg!(g, 1, 2)
julia> is_ps_lg(g, 1)
false
```
"""
function is_ps_lg(g::Graph, s::Int64)::Bool
	g.deltaplus_dir[s] == 0 &&
	g.beta[s] == g.deltaplus_undir[s] * g.deltaminus_dir[s] &&
	g.alpha[s] == binomial(g.deltaplus_undir[s], 2)
end

"""
	list_ps_lg(graph::Graph)::Vector{Int64}

List potential sinks in the given graph.

# Examples
```julia-repl
julia> g = init_lg(3)
...
julia> list_ps_lg(g)
3-element Vector{Int64}:
 1
 2
 3
julia> insert_arc_lg!(g, 1, 2)
julia> insert_edge_lg!(g, 2, 3)
julia> list_ps_lg(g)
1-element Vector{Int64}:
 3
```
"""
function list_ps_lg(graph::Graph)::Vector{Int64}
	result = Vector{Int64}()
	
	for i = 1:nv(graph.g)
		is_ps_lg(graph, i) && push!(result, i)
	end

	result
end

"""
	pop_ps_lg!(graph::Graph, s::Int64)::Vector{Int64}

Mark s as deleted and delete all edges (directed and undirected)
incident to s. Return a list of neighbors of s that became potential
sinks after the removal.

# Examples
```julia-repl
julia> g = init_lg(3)
...
julia> insert_arc_lg!(g, 1, 2)
julia> insert_edge_lg!(g, 2, 3)
julia> list_ps_lg(g)
1-element Vector{Int64}:
 3
julia> pop_ps_lg!(g, 3)
1-element Vector{Int64}:
 2
```
"""
function pop_ps_lg!(graph::Graph, s::Int64)::Vector{Int64}
	old_neighbors = copy(all_neighbors(graph.g, s))

	# Delete directed edges first (since s is a sink, there are
	# only ingoing edges which are directed).
	for ingoing in copy(inneighbors(graph.g, s))
		is_directed_lg(graph, ingoing, s) || continue

		# Since s is a sink, all outneighbors have undirected edges.
		for undir in outneighbors(graph.g, s)
			is_undirected_lg(graph, ingoing, undir) && (graph.alpha[undir] += -1)
			is_directed_lg(graph, ingoing, undir) && (graph.beta[undir] += -1)
		end

		rem_edge!(graph.g, ingoing, s) # TODO: Too expensive???
		graph.deltaplus_dir[ingoing] -= 1
		graph.deltaminus_dir[s] -= 1
	end

	# Delete undirected edges incident to s.
	for undir in copy(outneighbors(graph.g, s))
		remove_edge_lg!(graph, s, undir)
	end

	result = Vector{Int64}()

	for old_neighbor in old_neighbors
		is_ps_lg(graph, old_neighbor) && push!(result, old_neighbor)
	end

	result
end

"""
	print_graph_lg(graph::Graph, io::Core.IO = stdout)

Print the components of a given graph.

# Examples
```julia-repl
julia> g = init_lg(1)
...
julia> print_graph_lg(g)
Vertex 1:
        Alpha   = 0     Beta    = 0
        δ+(G1)  = 0     δ-(G1)  = 0     δ+(G2)  = 0     δ-(G2)  = 0
        Adj     = 
        In      = 
        Out     = 
```
"""
function print_graph_lg(graph::Graph, io::Core.IO = stdout)
	for i = 1:nv(graph.g)
		println(io, "Vertex $i:")
		print(io,   "\tAlpha   = $(graph.alpha[i])")
		println(io, "\tBeta    = $(graph.beta[i])")

		print(io,   "\tδ+(G1)  = $(graph.deltaplus_undir[i])")
		print(io,   "\tδ-(G1)  = $(graph.deltaminus_undir[i])")
		print(io,   "\tδ+(G2)  = $(graph.deltaplus_dir[i])")
		println(io, "\tδ-(G2)  = $(graph.deltaminus_dir[i])")

		println(io, "\tAdj     = $(join(all_neighbors(graph.g, i), ", "))")
		println(io, "\tIn      = $(join(inneighbors(graph.g, i), ", "))")
		println(io, "\tOut     = $(join(outneighbors(graph.g, i), ", "))")
	end
end