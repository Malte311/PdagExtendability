using LightGraphs

@isdefined(DtGraph) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")

"""
TODO
"""
function pdag2mpdag(g::SimpleDiGraph)::DtGraph
	graph = setup_hs(g)

	for u in graph.vertices
		for v in graph.undirected[u] # undirected edges u-v
			for other in graph.ingoing[u]
				if !isadjacent_hs(graph, u, other) # Rule 1
					delete!(graph.undirected[u], v)
					delete!(graph.undirected[v], u)
					push!(graph.ingoing[v], u)
					push!(graph.outgoing[u], v)
				elseif other in graph.outgoing[v] # Rule 2
					delete!(graph.undirected[u], v)
					delete!(graph.undirected[v], u)
					push!(graph.ingoing[u], v)
					push!(graph.outgoing[v], u)
				end
			end
		end

		for v in graph.outgoing[u] # directed edges u->v
			for other in intersect(graph.undirected[u], graph.undirected[v])
				# There must be an undirected edge between an ingoing vertex
				# of v and o1 because R1 or R2 would have been applied otherwise.
				# Note that u is element of graph.ingoing[v], thus checking
				# whether graph.ingoing[v] is empty is not sufficient. 
				if length(graph.ingoing[v]) > 1 # Rule 3
					delete!(graph.undirected[other], v)
					delete!(graph.undirected[v], other)
					push!(graph.ingoing[v], other)
					push!(graph.outgoing[other], v)
				end
			end
		end
	end

	graph
end