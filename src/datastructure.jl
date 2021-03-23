mutable struct Vertex
	key::Int64
	outedges::Vector{Vertex}
	inedges::Vector{Vertex}
end

mutable struct DirectedGraph
	vertices::Vector{Vertex}
	adjmatrix::Vector{Vector{Bool}} # TODO: Not binary, stores pointers!
	deltaplus::Vector{Vertex}
	deltaminus::Vector{Vertex}
end

mutable struct HybridGraph
	g1::DirectedGraph # Contains undirected edges
	g2::DirectedGraph # Contains directed edges
end

function printgraph(g::HybridGraph)
	println(g.g1)
	println(g.g2)
end

function init(n::Int64)::HybridGraph
	HybridGraph(
		DirectedGraph(
			Vector{Vertex}(undef, n),
			[Vector{Bool}(undef, n) for _ in 1:n],
			Vector{Vertex}(undef, n),
			Vector{Vertex}(undef, n)
		),
		DirectedGraph(
			Vector{Vertex}(undef, n),
			[Vector{Bool}(undef, n) for _ in 1:n],
			Vector{Vertex}(undef, n),
			Vector{Vertex}(undef, n)
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

printgraph(init(2))
printgraph(init(3))