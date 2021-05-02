"""
The datastructure to store a partially directed graph, using HashSets
internally.
"""
mutable struct DtGraph
	numvertices::Int64
	vertices::Set{Int64}
	degrees::Vector{Set{Int64}}
	ingoing::Vector{Set{Int64}}
	outgoing::Vector{Set{Int64}}
	undirected::Vector{Set{Int64}}
end

"""
	setup_hs(g::SimpleDiGraph, useheuristic::Bool = false)::DtGraph

Initialize the datastructure from a given graph g.

The parameter `useheuristic` indicates whether to maintain a
priority queue with vertices' degrees which is used to prefer
vertices with low degrees over ones with higher degrees.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> setup_hs(g)
DtGraph(
	3,
	Set{Int64}[Set([3]), Set([2, 1]), Set()],
	Set{Int64}[Set(), Set([1]), Set()],
	Set{Int64}[Set([2]), Set(), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
```
"""
function setup_hs(g::SimpleDiGraph, useheuristic::Bool = false)::DtGraph
	n = nv(g)

	graph = DtGraph(
		n,
		useheuristic ? Set{Int64}() : Set{Int64}([i for i in 1:n]),
		useheuristic ? [Set{Int64}() for _ in 1:n] : [],
		[Set{Int64}() for _ in 1:n],
		[Set{Int64}() for _ in 1:n],
		[Set{Int64}() for _ in 1:n]
	)

	for e in edges(g)
		isundirected = has_edge(g, e.dst, e.src)
		insert_edge_hs!(graph, e.src, e.dst, !isundirected)
	end

	if useheuristic
		for v = 1:n
			degree = degree_hs(graph, v)
			push!(graph.degrees[degree+1], v)
		end
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
	3,
	Set{Int64}[Set([3]), Set([2, 1]), Set()],
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
	3,
	Set{Int64}[Set([3]), Set([2, 1]), Set()],
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
	3,
	Set{Int64}[Set([3]), Set([2, 1]), Set()],
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
	remove_vertex_hs!(graph::DtGraph, x::Int64, useheuristic::Bool = false)

Remove vertex x from the given graph. Note that this only
removes x from sets of other nodes and the sets of x itself
are left unchanged, so do not use index x anymore after the
removal.

The parameter `useheuristic` indicates whether to update the
priority queue with vertices' degrees.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> dtgraph = setup_hs(g)
DtGraph(
	3,
	Set{Int64}[Set([3]), Set([2, 1]), Set()],
	Set{Int64}[Set(), Set([1]), Set()],
	Set{Int64}[Set([2]), Set(), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
julia> remove_vertex_hs!(dtgraph, 2)
julia> dtgraph
DtGraph(
	2,
	Set{Int64}[Set([3, 1]), Set(), Set()],
	Set{Int64}[Set(), Set([1]), Set()],
	Set{Int64}[Set(), Set(), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
```
"""
function remove_vertex_hs!(graph::DtGraph, x::Int64, useheuristic::Bool = false)
	if useheuristic
		for neighbor in union(graph.ingoing[x], graph.outgoing[x], graph.undirected[x])
			deg = degree_hs(graph, neighbor)
			delete!(graph.degrees[deg+1], neighbor)
			push!(graph.degrees[deg], neighbor)
		end
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

	if useheuristic
		delete!(graph.degrees[degree_hs(graph, x)+1], x)
	else
		delete!(graph.vertices, x)
	end

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
	3,
	Set{Int64}[Set([3]), Set([2, 1]), Set()],
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