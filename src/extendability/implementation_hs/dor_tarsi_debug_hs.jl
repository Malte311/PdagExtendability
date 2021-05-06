using LightGraphs

@isdefined(setup_hs) || include("dor_tarsi_algo_datastructure_hs.jl")

"""
	pdag2dag_debug_hs(g::SimpleDiGraph, useheuristic::Bool = false)::SimpleDiGraph

Debug version of [`pdag2dag_hs`](@ref). The debug version logs the
average number of iterations needed to find a sink.
"""
function pdag2dag_debug_hs(g::SimpleDiGraph, useheuristic::Bool = false)::SimpleDiGraph
	result = copy(g)
	temp = setup_hs(g, useheuristic)

	iterations = 0
	runs = 0

	# If one vertex is left there are no edges to other vertices anymore,
	# so we can stop (no need to do another iteration for nv(temp) == 1).
	while temp.numvertices > 1
		runs += 1
		(x, iter, vertex_order) = sink_debug_hs(temp, useheuristic)
		iterations += iter

		@info "Checked sinks in iteration $runs: $vertex_order"

		x != -1 || @info "Average iterations per vertex: $(iterations / runs)"
		x != -1 || return SimpleDiGraph(0)

		# Direct all adjacent edges towards x
		for neighbor in temp.undirected[x]
			rem_edge!(result, x, neighbor)
		end

		remove_vertex_hs!(temp, x, useheuristic)
	end

	@info "Average iterations per vertex: $(iterations / runs)"

	result
end

"""
	sink_debug_hs(graph::DtGraph, useheuristic::Bool = false)::Tuple{Int64, Int64, Vector{Int64}}

Debug version of [`sink_hs`](@ref). The debug version counts
the number of iterations needed to find a sink and computes
the average number of iterations needed in the whole algorithm. 
"""
function sink_debug_hs(graph::DtGraph, useheuristic::Bool = false)::Tuple{Int64, Int64, Vector{Int64}}
	iterations = 0
	vertex_order = Vector{Int64}()

	if useheuristic
		for index = 1:length(graph.degrees)
			for vertex in graph.degrees[index]
				iterations += 1
				push!(vertex_order, vertex)
				(issink, iter) = is_sink_debug_hs(graph, vertex)
				iterations += iter
				issink && return (vertex, iterations, vertex_order)
			end
		end
	else
		for vertex in graph.vertices
			iterations += 1
			push!(vertex_order, vertex)
			(issink, iter) = is_sink_debug_hs(graph, vertex)
			iterations += iter
			issink && return (vertex, iterations, vertex_order)
		end
	end

	(-1, iterations, vertex_order)
end

"""
	is_sink_debug_hs(graph::DtGraph, x::Int64)::Tuple{Bool, Int64}

Debug version of [`is_sink_hs`](@ref). The debug version counts
the number of iterations needed to check whether x is a sink. 
"""
function is_sink_debug_hs(graph::DtGraph, x::Int64)::Tuple{Bool, Int64}
	iterations = 0

	isempty(graph.outgoing[x]) || return (false, iterations)

	# All vertices connected to x via an undirected edge
	# must be adjacent to all vertices adjacent to x.
	for neighbor in graph.undirected[x]
		for other in union(graph.ingoing[x], graph.undirected[x])
			iterations += 1
			neighbor != other || continue
			isadjacent_hs(graph, neighbor, other) || return (false, iterations)
		end
	end

	(true, iterations)
end