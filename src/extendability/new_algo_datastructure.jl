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
	insert_arc!(g::HybridGraph, u::Int64, v::Int64)

Insert an arc (a directed edge) from u to v into g.
"""
function insert_arc!(g::HybridGraph, u::Int64, v::Int64)
	insert_arc!(g.g2, u, v)
	update_alphabeta!(g, u, v, +1)
end

"""
	update_alphabeta!(g::HybridGraph, u::Int64, v::Int64, val::Int64)

Update values for alpha and beta in g. Either add to (positive value for val)
or subtract from (negative value for val) alpha and beta.
"""
function update_alphabeta!(g::HybridGraph, u::Int64, v::Int64, val::Int64)
	isassigned(g.g1.adjlist, u) || (g.g1.adjlist[u] = Set())
	isassigned(g.g1.adjlist, v) || (g.g1.adjlist[v] = Set())
	isassigned(g.g2.ingoing, u) || (g.g2.ingoing[u] = Set())
	isassigned(g.g2.outgoing, u) || (g.g2.outgoing[u] = Set())
	isassigned(g.g2.ingoing, v) || (g.g2.ingoing[v] = Set())
	isassigned(g.g2.outgoing, v) || (g.g2.outgoing[v] = Set())

	for x in union(g.g1.adjlist[u], g.g2.ingoing[u], g.g2.outgoing[u])
		(x in g.g1.adjlist[v]) || (x in g.g2.ingoing[v]) || (x in g.g2.outgoing[v]) || continue
		(x in g.g1.adjlist[v]) && add_beta(g, v, val)
		(x in g.g1.adjlist[u]) && (x in g.g1.adjlist[v]) && add_alpha(g, x, val)
		(x in g.g2.outgoing[u]) && (x in g.g1.adjlist[v]) && add_beta(g, x, val)
		(x in g.g2.outgoing[v]) && (x in g.g1.adjlist[u]) && add_beta(g, x, val)
	end
end

"""
	add_alpha(g::HybridGraph, index::Int64, val::Int64)

Add val to alpha at index in g.
"""
function add_alpha(g::HybridGraph, index::Int64, val::Int64)
	isassigned(g.alpha, index) || (g.alpha[index] = 0)
	g.alpha[index] += val
end

"""
	add_beta(g::HybridGraph, index::Int64, val::Int64)

Add val to beta at index in g.
"""
function add_beta(g::HybridGraph, index::Int64, val::Int64)
	isassigned(g.beta, index) || (g.beta[index] = 0)
	g.beta[index] += val
end

"""
	insert_arc!(g::DirectedGraph, u::Int64, v::Int64)

Insert an arc (a directed edge) from u to v into g.
"""
function insert_arc!(g::DirectedGraph, u::Int64, v::Int64)
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
	insert_edge!(g::HybridGraph, u::Int64, v::Int64)

Insert an undirected edge between u and v into g.
"""
function insert_edge!(g::HybridGraph, u::Int64, v::Int64)
	insert_arc!(g.g1, u, v)
	insert_arc!(g.g1, v, u)
	update_alphabeta!(g, u, v, +1)
end

"""
	remove_arc!(g::HybridGraph, u::Int64, v::Int64)

Remove an arc (a directed edge) from u to v from g.
"""
function remove_arc!(g::HybridGraph, u::Int64, v::Int64)
	remove_arc!(g.g2, u, v)
	update_alphabeta!(g, u, v, -1)
end

"""
	remove_arc!(g::DirectedGraph, u::Int64, v::Int64)

Remove an arc (a directed edge) from u to v from g.
"""
function remove_arc!(g::DirectedGraph, u::Int64, v::Int64)
	g.deltaplus[u] -= 1
	g.deltaminus[v] -= 1
	delete!(g.outgoing[u], v)
	delete!(g.ingoing[v], u)
	delete!(g.adjlist[u], v)
end

"""
	remove_edge!(g::HybridGraph, u::Int64, v::Int64)

Remove an undirected edge between u and v from g.
"""
function remove_edge!(g::HybridGraph, u::Int64, v::Int64)
	remove_arc!(g.g1, u, v)
	remove_arc!(g.g1, v, u)
	update_alphabeta!(g, u, v, -1)
end

"""
	is_ps(g::HybridGraph, s::Int64)::Bool

Determine whether s is a potential sink in g.
"""
function is_ps(g::HybridGraph, s::Int64)::Bool
	g.alpha[s] == binomial(g.g1.deltaplus[s], 2) &&
	g.beta[s] == g.g1.deltaplus[s] * g.g2.deltaminus[s] &&
	g.g2.deltaplus[s] == 0
end

function is_adjacent(g::HybridGraph, u::Int64, v::Int64)::Bool
	false
end

function next_edge(g::HybridGraph, u::Int64, v::Int64)
	
end

function next_out_arc(g::HybridGraph, u::Int64, v::Int64)
	
end

function next_in_arc(g::HybridGraph, u::Int64, v::Int64)
	
end



function list_ps(g::HybridGraph)
	
end

function pop_ps!(g::HybridGraph, s::Int64)

end

"""
	print_graph(g::HybridGraph, io::Core.IO = stdout)

Print the components of a HybridGraph g.
"""
function print_graph(g::HybridGraph, io::Core.IO = stdout)
	for i = 1:length(g.alpha)
		println(io, "Vertex $i:")
		print(io, "\tAlpha   = $(isassigned(g.alpha, i) ? g.alpha[i] : 0)")
		println(io, "\tBeta    = $(isassigned(g.beta, i) ? g.beta[i] : 0)")

		print(io, "\tδ+(G1)  = $(isassigned(g.g1.deltaplus, i) ? g.g1.deltaplus[i] : 0)")
		print(io, "\tδ-(G1)  = $(isassigned(g.g1.deltaminus, i) ? g.g1.deltaminus[i] : 0)")
		print(io, "\tδ+(G2)  = $(isassigned(g.g2.deltaplus, i) ? g.g2.deltaplus[i] : 0)")
		println(io, "\tδ-(G2)  = $(isassigned(g.g2.deltaminus, i) ? g.g2.deltaminus[i] : 0)")

		print(io, "\tAdj(G1) = $(isassigned(g.g1.adjlist, i) ? join(collect(g.g1.adjlist[i]), ", ") : "-")")
		println(io, "\tAdj(G2) = $(isassigned(g.g2.adjlist, i) ? join(collect(g.g2.adjlist[i]), ", ")  : "-")")

		print(io, "\tIn(G1)  = $(isassigned(g.g1.ingoing, i) ? join(collect(g.g1.ingoing[i]), ", ") : "-")")
		println(io, "\tIn(G2)  = $(isassigned(g.g2.ingoing, i) ? join(collect(g.g2.ingoing[i]), ", ")  : "-")")

		print(io, "\tOut(G1) = $(isassigned(g.g1.outgoing, i) ? join(collect(g.g1.outgoing[i]), ", ") : "-")")
		println(io, "\tOut(G2) = $(isassigned(g.g2.outgoing, i) ? join(collect(g.g2.outgoing[i]), ", ")  : "-")")
	end	
end

g = init(3)
insert_arc!(g, 1, 2)
insert_edge!(g, 2, 3)
print_graph(g)
for i = 1:3
	println("$i is a potential sink? => $(is_ps(g, i))")
end