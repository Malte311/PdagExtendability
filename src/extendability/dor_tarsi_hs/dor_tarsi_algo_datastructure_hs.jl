
mutable struct DtGraph
	vertices::Set{Int64}
	ingoing::Vector{Set{Int64}}
	outgoing::Vector{Set{Int64}}
	undirected::Vector{Set{Int64}}
end


function setup_hs(g::SimpleDiGraph)::DtGraph
	n = nv(g)

	graph = DtGraph(
		Set{Int64}([i for i in 1:n]),
		[Set{Int64}() for _ in 1:n],
		[Set{Int64}() for _ in 1:n],
		[Set{Int64}() for _ in 1:n]
	)

	for e in edges(g)
		isundirected = has_edge(g, e.dst, e.src)
		insert_edge_hs!(graph, e.src, e.dst, isundirected)
	end

	graph
end


function isadjacent_hs(graph::DtGraph, u::Int64, v::Int64)::Bool
	v in graph.ingoing[u] || v in graph.outgoing[u] || v in graph.undirected[u]
end


function insert_edge_hs!(graph::DtGraph, u::Int64, v::Int64, isdir::Bool)
	if isdir
		push!(graph.outgoing[u], v)
		push!(graph.ingoing[v], u)
	else
		push!(graph.undirected[u], v)
		push!(graph.undirected[v], u)
	end
end


function remove_vertex_hs!(graph::DtGraph, x::Int64)
	for ingoing in graph.ingoing[x]
		delete!(graph.outgoing[ingoing], x)
	end

	for outgoing in graph.outgoing[x]
		delete!(graph.ingoing[outgoing], x)
	end

	for undirected in graph.undirected[x]
		delete!(graph.undirected[undirected], x)
	end

	delete!(graph.vertices, x)
end