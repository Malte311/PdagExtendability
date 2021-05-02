"""
The datastructure to store a partially directed graph, using HashSets
internally.
"""
mutable struct DtGraph
	numvertices::Int64
	vertices::Vector{Set{Int64}}
	ingoing::Vector{Set{Int64}}
	outgoing::Vector{Set{Int64}}
	undirected::Vector{Set{Int64}}
end

"""
	setup_hs(g::SimpleDiGraph)::DtGraph

Initialize the datastructure from a given graph g.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> setup_hs(g)
DtGraph(
	Set([2, 3, 1]),
	Set{Int64}[Set(), Set([1]), Set()],
	Set{Int64}[Set([2]), Set(), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
```
"""
function setup_hs(g::SimpleDiGraph)::DtGraph
	n = nv(g)

	graph = DtGraph(
		n,
		[Set{Int64}() for _ in 1:n],
		[Set{Int64}() for _ in 1:n],
		[Set{Int64}() for _ in 1:n],
		[Set{Int64}() for _ in 1:n]
	)

	for e in edges(g)
		isundirected = has_edge(g, e.dst, e.src)
		insert_edge_hs!(graph, e.src, e.dst, !isundirected)
	end

	for v = 1:n
		degree = degree_hs(graph, v)
		push!(graph.vertices[degree+1], v)
	end

	graph
end

"""
	isadjacent_hs(graph::DtGraph, u::Int64, v::Int64)::Bool

Check whether vertices u and v are adjacent in the given graph.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> dtgraph = setup_hs(g)
DtGraph(
	Set([2, 3, 1]),
	Set{Int64}[Set(), Set([1]), Set()],
	Set{Int64}[Set([2]), Set(), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
julia> isadjacent_hs(dtgraph, 1, 2)
true
```
"""
function isadjacent_hs(graph::DtGraph, u::Int64, v::Int64)::Bool
	v in graph.ingoing[u] || v in graph.outgoing[u] || v in graph.undirected[u]
end

"""
	degree_hs(graph::DtGraph, u::Int64)::Int64

Compute the degree of vertix `u` in the given graph.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> dtgraph = setup_hs(g)
DtGraph(
	Set([2, 3, 1]),
	Set{Int64}[Set(), Set([1]), Set()],
	Set{Int64}[Set([2]), Set(), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
julia> degree_hs(dtgraph, 1)
1
```
"""
function degree_hs(graph::DtGraph, u::Int64)::Int64
	length(graph.ingoing[u]) + length(graph.outgoing[u]) + length(graph.undirected[u])
end

"""
	insert_edge_hs!(graph::DtGraph, u::Int64, v::Int64, isdir::Bool)

Insert an edge between u and v into the given graph. The parameter isdir
indicates whether the edge is directed or not.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> dtgraph = setup_hs(g)
DtGraph(
	Set([2, 3, 1]),
	Set{Int64}[Set(), Set([1]), Set()],
	Set{Int64}[Set([2]), Set(), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
julia> insert_edge_hs!(dtgraph, 2, 3, true)
julia> isadjacent_hs(dtgraph, 3, 2)
true
```
"""
function insert_edge_hs!(graph::DtGraph, u::Int64, v::Int64, isdir::Bool)
	if isdir
		push!(graph.outgoing[u], v)
		push!(graph.ingoing[v], u)
	else
		push!(graph.undirected[u], v)
		push!(graph.undirected[v], u)
	end
end

"""
	remove_vertex_hs!(graph::DtGraph, x::Int64)

Remove vertex x from the given graph. Note that this only
removes x from sets of other nodes and the sets of x itself
are left unchanged, so do not use index x anymore after the
removal.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> dtgraph = setup_hs(g)
DtGraph(
	Set([2, 3, 1]),
	Set{Int64}[Set(), Set([1]), Set()],
	Set{Int64}[Set([2]), Set(), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
julia> remove_vertex_hs!(dtgraph, 2)
julia> dtgraph
DtGraph(
	Set([3, 1]),
	Set{Int64}[Set(), Set([1]), Set()],
	Set{Int64}[Set(), Set(), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
```
"""
function remove_vertex_hs!(graph::DtGraph, x::Int64)
	for neighbor in union(graph.ingoing[x], graph.outgoing[x], graph.undirected[x])
		deg = degree_hs(graph, neighbor)
		delete!(graph.vertices[deg+1], neighbor)
		push!(graph.vertices[deg], neighbor)
	end

	for ingoing in graph.ingoing[x]
		delete!(graph.outgoing[ingoing], x)
	end

	for outgoing in graph.outgoing[x]
		delete!(graph.ingoing[outgoing], x)
	end

	for undirected in graph.undirected[x]
		delete!(graph.undirected[undirected], x)
	end

	delete!(graph.vertices[degree_hs(graph, x)+1], x)

	graph.numvertices -= 1
end

"""
	print_graph_hs(graph::DtGraph, io::Core.IO = stdout)

Print a given graph.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> dtgraph = setup_hs(g)
DtGraph(
	Set([2, 3, 1]),
	Set{Int64}[Set(), Set([1]), Set()],
	Set{Int64}[Set([2]), Set(), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
julia> print_graph_hs(dtgraph)
Vertex 1:
        Ingoing    = 
        Outgoing   = 2
        Undirected = 
Vertex 2:
        Ingoing    = 1
        Outgoing   = 
        Undirected = 
Vertex 3:
        Ingoing    = 
        Outgoing   = 
        Undirected = 
```
"""
function print_graph_hs(graph::DtGraph, io::Core.IO = stdout)
	for i = 1:length(graph.vertices)
		println(io, "Vertex $i:")
		println(io, "\tIngoing    = $(join(graph.ingoing[i], ", "))")
		println(io, "\tOutgoing   = $(join(graph.outgoing[i], ", "))")
		println(io, "\tUndirected = $(join(graph.undirected[i], ", "))")
	end
end