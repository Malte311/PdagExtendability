using LightGraphs

@isdefined(setup_hs) || include("dor_tarsi_algo_datastructure_hs.jl")

"""
	pdag2dag_debug_hs(g::SimpleDiGraph)::SimpleDiGraph

Debug version of [`pdag2dag_hs`](@ref). The debug version logs the
average number of iterations needed to find a sink.
"""
function pdag2dag_debug_hs(g::SimpleDiGraph)::SimpleDiGraph
	result = copy(g)
	temp = setup_hs(g)

	iterations = 0
	runs = 0

	# If one vertex is left there are no edges to other vertices anymore,
	# so we can stop (no need to do another iteration for nv(temp) == 1).
	while length(temp.vertices) > 1
		runs += 1
		(x, iter) = sink_debug_hs(temp)
		iterations += iter

		x != -1 || @info "Average iterations: $(iterations / runs)"
		x != -1 || return SimpleDiGraph(0)

		# Direct all adjacent edges towards x
		for neighbor in temp.undirected[x]
			rem_edge!(result, x, neighbor)
		end

		remove_vertex_hs!(temp, x)
	end

	@info "Average iterations: $(iterations / runs)"

	result
end

"""
	sink_debug_hs(graph::DtGraph)::Tuple{Int64, Int64}

Debug version of [`sink_hs`](@ref). The debug version counts
the number of iterations needed to find a sink and computes
the average number of iterations needed in the whole algorithm. 
"""
function sink_debug_hs(graph::DtGraph)::Tuple{Int64, Int64}
	iterations = 0

	for vertex in graph.vertices
		iterations += 1

		isempty(graph.outgoing[vertex]) || continue

		# All vertices connected to x via an undirected edge
		# must be adjacent to all vertices adjacent to x.
		for neighbor in graph.undirected[vertex]
			for other in union(graph.ingoing[vertex], graph.undirected[vertex])
				iterations += 1
				neighbor != other || continue
				isadjacent_hs(graph, neighbor, other) || @goto outer
			end
		end

		return (vertex, iterations)

		@label outer
	end

	(-1, iterations)
end