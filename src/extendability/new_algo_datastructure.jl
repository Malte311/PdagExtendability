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
	g1::DirectedGraph # Contains undirected edges
	g2::DirectedGraph # Contains directed edges
end

"""

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
		)
	)
end

function isadjacent(u::Vertex, v::Vertex)::Bool
	false
end

function insertedge!(u::Vertex ,v::Vertex)
	
end

function insertarc!(u::Vertex, v::Vertex)
	
end

function removeedge!(u::Vertex, v::Vertex)
	
end

function removearc!(u::Vertex, v::Vertex)
	
end

function nextedge(u::Vertex, v::Vertex)
	
end

function nextoutarc(u::Vertex, v::Vertex)
	
end

function nextinarc(u::Vertex, v::Vertex)
	
end

function isps(s::Vertex)::Bool
	false
end

function listps()
	
end

function popps!(s::Vertex)

end