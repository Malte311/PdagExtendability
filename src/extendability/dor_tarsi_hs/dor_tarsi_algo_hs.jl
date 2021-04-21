using LightGraphs

include("dor_tarsi_algo_datastructure_hs.jl")

function pdag2dag_hs(g::SimpleDiGraph)::SimpleDiGraph
	result = copy(g)
	temp = setup_hs(g)

	# If one vertex is left there are no edges to other vertices anymore,
	# so we can stop (no need to do another iteration for nv(temp) == 1).
	while length(temp.vertices) > 1
		x = sink_hs(temp)
		x != -1 || return SimpleDiGraph(0)

		# Direct all adjacent edges towards x
		for neighbor in temp.undirected[x]
			rem_edge!(result, x, neighbor)
		end

		remove_vertex_hs!(temp, x)
	end

	result
end


function sink_hs(graph::DtGraph)::Int64
	for vertex in graph.vertices
		isempty(graph.outgoing[vertex]) || continue

		# All vertices connected to x via an undirected edge
		# must be adjacent to all vertices adjacent to x.
		for neighbor in graph.undirected[vertex]
			for other in union(graph.ingoing[vertex], graph.undirected[vertex])
				neighbor != other || continue
				isadjacent_hs(graph, neighbor, other) || @goto outer
			end
		end

		return vertex

		@label outer
	end

	-1
end