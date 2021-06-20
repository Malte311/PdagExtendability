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
		for v in graph.undirected[u] # undirected edges u-v
			for other in graph.ingoing[u]
				(other != u && other != v) || continue
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
		for v in graph.outgoing[u] # directed edges u->v
			# Rule 3
			for o1 in intersect(graph.undirected[u], graph.undirected[v])
				(o1 != u && o1 != v) || continue
				# There must be an undirected edge between o1 and o2
				# because R1 or R2 would have been applied otherwise.
				for o2 in graph.ingoing[v]
					if o1 != u && o1 != o2 && !isadjacent_hs(graph, u, o2)
						delete!(graph.undirected[o1], v)
						delete!(graph.undirected[v], o1)
						push!(graph.ingoing[v], o1)
						push!(graph.outgoing[o1], v)
						break
					end
				end
			end

			# Rule 4
			for o1 in intersect(graph.undirected[u], graph.undirected[v])
				(o1 != u && o1 != v) || continue
				# There must be an undirected edge between o1 and o2
				# because R1 or R2 would have been applied otherwise.
				for o2 in graph.ingoing[u]
					if o1 != v && o1 != o2 && !isadjacent_hs(graph, v, o2)
						delete!(graph.undirected[o1], v)
						delete!(graph.undirected[v], o1)
						push!(graph.ingoing[v], o1)
						push!(graph.outgoing[o1], v)
						break
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

# include("../../utils/readinput.jl")
# include("../../utils/utils.jl")
# dir = "../benchmarks/pdirected/fromchordal/subtree-n=10000-k=3-1/"
# for f in readdir(dir)
#     file = joinpath(dir, f)
#     g = readinputgraph(file, false)
#     mpdag = dtgraph2digraph(pdag2mpdag(g))
#     save2file(mpdag, "../benchmarks/mpdirected/fromchordal/subtree-n=10000-k=3-1/$f", is_only_undir = false)
# end

