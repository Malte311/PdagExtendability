"""
The datastructure to store a directed graph.
"""
mutable struct DirectedGraph
	adjlist::Vector{Set}      # List of adjacent vertices for each vertex
	deltaplus::Vector{Int64}  # Out-degree for each vertex
	deltaminus::Vector{Int64} # In-degree for each vertex
	ingoing::Vector{Set}      # List of ingoing vertices for each vertex
	outgoing::Vector{Set}     # List of outgoing vertices for each vertex
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
	init(n::Int64)::HybridGraph

Allocate uninitialized memory for the HybridGraph datastructure
representing a graph with n vertices.
"""
function init(n::Int64)::HybridGraph
	HybridGraph(
		DirectedGraph(
			Vector(undef, n),
			Vector(undef, n),
			Vector(undef, n),
			Vector(undef, n),
			Vector(undef, n)
		),
		DirectedGraph(
			Vector(undef, n),
			Vector(undef, n),
			Vector(undef, n),
			Vector(undef, n),
			Vector(undef, n)
		),
		Vector(undef, n),
		Vector(undef, n)
	)
end

"""
	insertarc!(g::HybridGraph, u::Int64, v::Int64)

Insert an arc (a directed edge) from u to v into g.
"""
function insertarc!(g::HybridGraph, u::Int64, v::Int64)
	insertarc!(g.g2, u, v)
end

"""
	insertarc!(g::DirectedGraph, u::Int64, v::Int64)

Insert an arc (a directed edge) from u to v into g.
"""
function insertarc!(g::DirectedGraph, u::Int64, v::Int64)
	g.deltaplus[u] += 1
	g.deltaminus[v] += 1
	isassigned(g.outgoing, u) || (g.outgoing[u] = Set())
	push!(g.outgoing[u], v)
	isassigned(g.ingoing, v) || (g.ingoing[v] = Set())
	push!(g.ingoing[v], u)
	isassigned(g.adjlist, u) || (g.adjlist[u] = Set())
	push!(g.adjlist[u], v)
end

"""
	insertedge!(g::HybridGraph, u::Int64, v::Int64)

Insert an undirected edge between u and v into g.
"""
function insertedge!(g::HybridGraph, u::Int64, v::Int64)
	insertarc!(g.g1, u, v)
	insertarc!(g.g1, v, u)
end

"""
	removearc!(g::HybridGraph, u::Int64, v::Int64)

Remove an arc (a directed edge) from u to v from g.
"""
function removearc!(g::HybridGraph, u::Int64, v::Int64)
	removearc!(g.g2, u, v)
end

"""
	removearc!(g::DirectedGraph, u::Int64, v::Int64)

Remove an arc (a directed edge) from u to v from g.
"""
function removearc!(g::DirectedGraph, u::Int64, v::Int64)
	g.deltaplus[u] -= 1
	g.deltaminus[v] -= 1
	delete!(g.outgoing[u], v)
	delete!(g.ingoing[v], u)
	delete!(g.adjlist[u], v)
end

"""
	removeedge!(g::HybridGraph, u::Int64, v::Int64)

Remove an undirected edge between u and v from g.
"""
function removeedge!(g::HybridGraph, u::Int64, v::Int64)
	removearc!(g.g1, u, v)
	removearc!(g.g1, v, u)
end

function isadjacent(g::DirectedGraph, u::Int64, v::Int64)::Bool
	false
end

function nextedge(g::DirectedGraph, u::Int64, v::Int64)
	
end

function nextoutarc(g::DirectedGraph, u::Int64, v::Int64)
	
end

function nextinarc(g::DirectedGraph, u::Int64, v::Int64)
	
end

function isps(g::DirectedGraph, s::Int64)::Bool
	false
end

function listps(g::DirectedGraph)
	
end

function popps!(g::DirectedGraph, s::Int64)

end

for i = 1:10
	for n in [5, 50, 500, 5000]
		@time init(n)
	end
end