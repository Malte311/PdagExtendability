using LightGraphs

@isdefined(DtGraph) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")

"""
	pdag2mpdag(g::SimpleDiGraph)::DtGraph

Apply the four Meek Rules to the input PDAG in order to obtain an MPDAG.

# References
Meek, C. (1995). Causal Inference and Causal Explanation with Background Knowledge.
In Proceedings of the Eleventh Conference on Uncertainty in Artificial Intelligence, UAI’95.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> add_edge!(g, 3, 2)
true
julia> collect(edges(dtgraph2digraph(pdag2mpdag(g))))
2-element Vector{LightGraphs.SimpleGraphs.SimpleEdge{Int64}}:
 Edge 1 => 2
 Edge 2 => 3
```
"""
function pdag2mpdag(g::SimpleDiGraph)::DtGraph
	graph = setup_hs(g)

	for u in graph.vertices
		for v in copy(graph.undirected[u]) # undirected edges u-v
			for other in copy(graph.ingoing[u])
				if !isadjacent_hs(graph, v, other) # Rule 1
					delete!(graph.undirected[u], v)
					delete!(graph.undirected[v], u)
					push!(graph.ingoing[v], u)
					push!(graph.outgoing[u], v)
				elseif other in graph.outgoing[v] && other in graph.ingoing[u] # Rule 2
					delete!(graph.undirected[u], v)
					delete!(graph.undirected[v], u)
					push!(graph.ingoing[u], v)
					push!(graph.outgoing[v], u)
				end
			end
		end
	end

	for u in graph.vertices
		for v in copy(graph.outgoing[u]) # directed edges u->v
			for a in intersect(graph.undirected[u], graph.undirected[v])
				# Rule 3
				for b in copy(graph.ingoing[v])
					# There must be an undirected edge between an a and b
					# because R1 or R2 would have been applied otherwise.
					if u != b && !isadjacent_hs(graph, u, b)
						delete!(graph.undirected[a], v)
						delete!(graph.undirected[v], a)
						push!(graph.ingoing[v], a)
						push!(graph.outgoing[a], v)
					end
				end

				# Rule 4
				for d in graph.ingoing[u]
					# There must be an undirected edge between an a and d
					# because R1 or R2 would have been applied otherwise.
					if !isadjacent_hs(graph, v, d)
						delete!(graph.undirected[a], v)
						delete!(graph.undirected[v], a)
						push!(graph.ingoing[v], a)
						push!(graph.outgoing[a], v)
					end
				end
			end
		end
	end

	graph
end

"""
# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> add_edge!(g, 3, 2)
true
julia> g == dtgraph2digraph(setup_hs(g))
true
```
"""
function dtgraph2digraph(g::DtGraph)::SimpleDiGraph
	result = SimpleDiGraph(g.numvertices)
	
	for vertex = 1:g.numvertices
		for neighbor in g.outgoing[vertex]
			add_edge!(result, vertex, neighbor)
		end
		for neighbor in g.undirected[vertex]
			add_edge!(result, vertex, neighbor)
			add_edge!(result, neighbor, vertex)
		end
	end

	result
end