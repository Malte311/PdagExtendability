using LightGraphs

@isdefined(DtGraph) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")

"""
TODO
"""
function pdag2mpdag(g::SimpleDiGraph)::SimpleDiGraph
	graph = setup_hs(g)
	result = copy(g)

	for u in graph.vertices
		for v in graph.undirected[u] # undirected edges u-v
			for other in graph.ingoing[u]
				if !isadjacent_hs(graph, u, other) # Rule 1
					delete!(graph.undirected[u], v)
					delete!(graph.undirected[v], u)
					push!(graph.ingoing[v], u)
					push!(graph.outgoing[u], v)
					rem_edge!(result, v, u)
				elseif other in graph.outgoing[v] # Rule 2
					delete!(graph.undirected[u], v)
					delete!(graph.undirected[v], u)
					push!(graph.ingoing[u], v)
					push!(graph.outgoing[v], u)
					rem_edge!(result, u, v)
				end
			end
		end
	end

	result
end