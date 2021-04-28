using LightGraphs

@isdefined(setup_hs) || include("dor_tarsi_algo_datastructure_hs.jl")

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


function list_sinks_hs(graph::DtGraph)::Vector{Int64}
	result = Vector{Int64}()

	for vertex in graph.vertices
		is_sink_hs(graph, vertex) && push!(result, vertex)
	end

	result
end


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