"""
The datastructure to store a directed graph.
"""
mutable struct DirectedGraph
	adjlist::Vector{Set{Int64}}  # List of adjacent vertices for each vertex
	deltaplus::Vector{Int64}     # Out-degree for each vertex
	deltaminus::Vector{Int64}    # In-degree for each vertex
	ingoing::Vector{Set{Int64}}  # List of ingoing vertices for each vertex
	outgoing::Vector{Set{Int64}} # List of outgoing vertices for each vertex
end

"""
The datastructure to store a partially directed graph.
"""
mutable struct HybridGraph
	g1::DirectedGraph    # Represents undirected edges
	g2::DirectedGraph    # Represents directed edges
	alpha::Vector{Int64} # Number of undirected neighbors that are adjacent
	                     # to another undirected neighbor for each vertex
	beta::Vector{Int64}  # Number of undirected neighbors that are adjacent
	                     # to an ingoing neighbor for each vertex
end

"""
	init_hs(n::Int64)::HybridGraph

Allocate memory for the HybridGraph datastructure
representing a graph with n vertices.

# Examples
```julia-repl
julia> g = init_hs(3)
HybridGraph(
	DirectedGraph(
		Set{Int64}[Set(), Set(), Set()],
		[0, 0, 0], [0, 0, 0],
		Set{Int64}[Set(), Set(), Set()],
		Set{Int64}[Set(), Set(), Set()]
	),
	DirectedGraph(
		Set{Int64}[Set(), Set(), Set()],
		[0, 0, 0],
		[0, 0, 0],
		Set{Int64}[Set(), Set(), Set()],
		Set{Int64}[Set(), Set(), Set()]
	),
	[0, 0, 0],
	[0, 0, 0]
)
```
"""
function init_hs(n::Int64)::HybridGraph
	HybridGraph(
		DirectedGraph(
			[Set{Int64}() for _ in 1:n],
			fill(0, n),
			fill(0, n),
			[Set{Int64}() for _ in 1:n],
			[Set{Int64}() for _ in 1:n]
		),
		DirectedGraph(
			[Set{Int64}() for _ in 1:n],
			fill(0, n),
			fill(0, n),
			[Set{Int64}() for _ in 1:n],
			[Set{Int64}() for _ in 1:n]
		),
		fill(0, n),
		fill(0, n)
	)
end

"""
	is_adjacent_hs(g::HybridGraph, u::Int64, v::Int64)::Bool

Check whether vertices u and v are adjacent in graph g.

# Examples
```julia-repl
julia> g = init_hs(3)
...
julia> is_adjacent_hs(g, 1, 2)
false
julia> insert_arc_hs!(g, 1, 2)
julia> is_adjacent_hs(g, 1, 2)
true
```
"""
function is_adjacent_hs(g::HybridGraph, u::Int64, v::Int64)::Bool
	(v in g.g1.adjlist[u]) || (v in g.g2.adjlist[u])
end

"""
	insert_arc_hs!(g::HybridGraph, u::Int64, v::Int64)

Insert an arc (a directed edge) from u to v into g.

# Examples
```julia-repl
julia> g = init_hs(3)
...
julia> insert_arc_hs!(g, 1, 2)
julia> is_adjacent_hs(g, 1, 2)
true
```
"""
function insert_arc_hs!(g::HybridGraph, u::Int64, v::Int64)
	insert_arc_hs!(g.g2, u, v)
	update_alphabeta_hs!(g, u, v, +1)
end

"""
	insert_arc_hs!(g::DirectedGraph, u::Int64, v::Int64)

Insert an arc (a directed edge) from u to v into g.

Is called internally and should not be called by hand! For inserting
arcs, use the function insert_arc_hs! directly on the HybridGraph
datastructure instead.
```
"""
function insert_arc_hs!(g::DirectedGraph, u::Int64, v::Int64)
	g.deltaplus[u] += 1
	g.deltaminus[v] += 1

	push!(g.outgoing[u], v)
	push!(g.ingoing[v], u)
	push!(g.adjlist[u], v)
	push!(g.adjlist[v], u)
end

"""
	insert_edge_hs!(g::HybridGraph, u::Int64, v::Int64)

Insert an undirected edge between u and v into g.

# Examples
```julia-repl
julia> g = init_hs(3)
...
julia> insert_edge_hs!(g, 2, 3)
julia> is_adjacent_hs(g, 2, 3)
true
```
"""
function insert_edge_hs!(g::HybridGraph, u::Int64, v::Int64)
	insert_arc_hs!(g.g1, u, v)
	insert_arc_hs!(g.g1, v, u)
	update_alphabeta_hs!(g, u, v, +1)
end

"""
	remove_arc_hs!(g::HybridGraph, u::Int64, v::Int64)

Remove an arc (a directed edge) from u to v from g.

# Examples
```julia-repl
julia> g = init_hs(3)
...
julia> insert_arc_hs!(g, 1, 2)
julia> is_adjacent_hs(g, 1, 2)
true
julia> remove_arc_hs!(g, 1, 2)
julia> is_adjacent_hs(g, 1, 2)
false
```
"""
function remove_arc_hs!(g::HybridGraph, u::Int64, v::Int64)
	update_alphabeta_hs!(g, u, v, -1)
	remove_arc_hs!(g.g2, u, v)
end

"""
	remove_arc_hs!(g::DirectedGraph, u::Int64, v::Int64)

Remove an arc (a directed edge) from u to v from g.

Is called internally and should not be called by hand! For removing
arcs, use the function remove_arc_hs! directly on the HybridGraph
datastructure instead.
"""
function remove_arc_hs!(g::DirectedGraph, u::Int64, v::Int64)
	g.deltaplus[u] -= 1
	g.deltaminus[v] -= 1
	delete!(g.outgoing[u], v)
	delete!(g.ingoing[v], u)
	delete!(g.adjlist[u], v)
	delete!(g.adjlist[v], u)
end

"""
	remove_edge_hs!(g::HybridGraph, u::Int64, v::Int64)

Remove an undirected edge between u and v from g.

# Examples
```julia-repl
julia> g = init_hs(3)
...
julia> insert_edge_hs!(g, 2, 3)
julia> is_adjacent_hs(g, 2, 3)
true
julia> remove_edge_hs!(g, 2, 3)
julia> is_adjacent_hs(g, 2, 3)
false
```
"""
function remove_edge_hs!(g::HybridGraph, u::Int64, v::Int64)
	update_alphabeta_hs!(g, u, v, -1)

	remove_arc_hs!(g.g1, u, v)
	remove_arc_hs!(g.g1, v, u)
end

"""
	update_alphabeta_hs!(g::HybridGraph, u::Int64, v::Int64, val::Int64)

Update values for alpha and beta in g. Either add to (positive value for val)
or subtract from (negative value for val) alpha and beta.

Is called internally whenever an edge (both directed and undirected) is
inserted or removed. Do not call this function by hand.
"""
function update_alphabeta_hs!(g::HybridGraph, u::Int64, v::Int64, val::Int64)
	for x in union(g.g1.adjlist[u], g.g2.adjlist[u])
		is_adjacent_hs(g, x, v) || continue
		(u in g.g1.adjlist[v]) && (u in g.g1.adjlist[x]) && (g.alpha[u] += val)
		(u in g.g1.adjlist[v]) && (u in g.g2.outgoing[x]) && (g.beta[u] += val)
		(u in g.g2.outgoing[v]) && (u in g.g1.adjlist[x]) && (g.beta[u] += val)

		(v in g.g1.adjlist[x]) && (v in g.g1.adjlist[u]) && (g.alpha[v] += val)
		(v in g.g1.adjlist[x]) && (v in g.g2.outgoing[u]) && (g.beta[v] += val)
		(v in g.g2.outgoing[x]) && (v in g.g1.adjlist[u]) && (g.beta[v] += val)

		(x in g.g1.adjlist[u]) && (x in g.g1.adjlist[v]) && (g.alpha[x] += val)
		(x in g.g2.outgoing[u]) && (x in g.g1.adjlist[v]) && (g.beta[x] += val)
		(x in g.g2.outgoing[v]) && (x in g.g1.adjlist[u]) && (g.beta[x] += val)
	end
end

"""
	is_ps_hs(g::HybridGraph, s::Int64)::Bool

Determine whether s is a potential sink in g.

# Examples
```julia-repl
julia> g = init_hs(3)
...
julia> is_ps_hs(g, 1)
true
julia> insert_arc_hs!(g, 1, 2)
julia> is_ps_hs(g, 1)
false
```
"""
function is_ps_hs(g::HybridGraph, s::Int64)::Bool
	g.g2.deltaplus[s] == 0 &&
	g.beta[s] == g.g1.deltaplus[s] * g.g2.deltaminus[s] &&
	g.alpha[s] == binomial(g.g1.deltaplus[s], 2)
end

"""
	list_ps_hs(g::HybridGraph)::Vector{Int64}

List potential sinks in g.

# Examples
```julia-repl
julia> g = init_hs(3)
...
julia> list_ps_hs(g)
3-element Array{Int64,1}:
 1
 2
 3
julia> insert_arc_hs!(g, 1, 2)
julia> insert_edge_hs!(g, 2, 3)
julia> list_ps_hs(g)
1-element Array{Int64,1}:
 3
```
"""
function list_ps_hs(g::HybridGraph)::Vector{Int64}
	result = Vector{Int64}()

	for i = 1:length(g.alpha)
		is_ps_hs(g, i) && push!(result, i)
	end

	result
end

"""
	pop_ps_hs!(g::HybridGraph, s::Int64)::Vector{Int64}

Mark s as deleted and delete all edges (directed and undirected)
incident to s. Return a list of neighbors of s that became potential
sinks after the removal.

# Examples
```julia-repl
julia> g = init_hs(3)
...
julia> insert_arc_hs!(g, 1, 2)
julia> insert_edge_hs!(g, 2, 3)
julia> list_ps_hs(g)
1-element Array{Int64,1}:
 3
julia> pop_ps_hs!(g, 3)
1-element Array{Int64,1}:
 2
```
"""
function pop_ps_hs!(g::HybridGraph, s::Int64)::Vector{Int64}
	old_neighbors = union(g.g1.adjlist[s], g.g2.ingoing[s])

	# Delete directed edges first (since s is a sink, there are
	# only ingoing edges).
	for ingoing in g.g2.ingoing[s]
		for undirected in g.g1.adjlist[s]
			(ingoing in g.g1.adjlist[undirected]) && (g.alpha[undirected] += -1)
			(ingoing in g.g2.ingoing[undirected]) && (g.beta[undirected] += -1)
		end

		remove_arc_hs!(g.g2, ingoing, s) # O(1) because no update of alpha & beta
	end

	# Delete undirected edges incident to s.
	for undirected in g.g1.adjlist[s]
		remove_edge_hs!(g, s, undirected)
	end

	result = Vector{Int64}()

	for old_neighbor in old_neighbors
		is_ps_hs(g, old_neighbor) && push!(result, old_neighbor)
	end

	result
end

"""
	print_graph_hs(g::HybridGraph, io::Core.IO = stdout)

Print the components of a HybridGraph g.

# Examples
```julia-repl
julia> g = init_hs(1)
...
julia> print_graph_hs(g)
Vertex 1:
        Alpha   = 0     Beta    = 0
        δ+(G1)  = 0     δ-(G1)  = 0     δ+(G2)  = 0     δ-(G2)  = 0
        Adj(G1) =       Adj(G2) = 
        In(G1)  =       In(G2)  = 
        Out(G1) =       Out(G2) = 
```
"""
function print_graph_hs(g::HybridGraph, io::Core.IO = stdout)
	for i = 1:length(g.alpha)
		println(io, "Vertex $i:")
		print(io,   "\tAlpha   = $(g.alpha[i])")
		println(io, "\tBeta    = $(g.beta[i])")

		print(io,   "\tδ+(G1)  = $(g.g1.deltaplus[i])")
		print(io,   "\tδ-(G1)  = $(g.g1.deltaminus[i])")
		print(io,   "\tδ+(G2)  = $(g.g2.deltaplus[i])")
		println(io, "\tδ-(G2)  = $(g.g2.deltaminus[i])")

		print(io,   "\tAdj(G1) = $(join(collect(g.g1.adjlist[i]), ", "))")
		println(io, "\tAdj(G2) = $(join(collect(g.g2.adjlist[i]), ", "))")

		print(io,   "\tIn(G1)  = $(join(collect(g.g1.ingoing[i]), ", "))")
		println(io, "\tIn(G2)  = $(join(collect(g.g2.ingoing[i]), ", "))")

		print(io,   "\tOut(G1) = $(join(collect(g.g1.outgoing[i]), ", "))")
		println(io, "\tOut(G2) = $(join(collect(g.g2.outgoing[i]), ", "))")
	end
end