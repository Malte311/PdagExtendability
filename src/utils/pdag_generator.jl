using LightGraphs

@isdefined(fastpdag2dag_hs) || include("../extendability/implementation_hs/new_algo_hs.jl")
@isdefined(graph2digraph) || include("utils.jl")

"""
	random_pdag(g::SimpleDiGraph, p::Float64)::g::SimpleDiGraph

Generates a partially directed graph by directing a given percentage
of edges in a given undirected graph.
Takes as input a fully undirected graph, encoded as a `SimpleDiGraph`.
The generated PDAG will be extendable if the input is extendable.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 1)
true
julia> add_edge!(g, 1, 3)
true
julia> add_edge!(g, 3, 1)
julia> collect(edges(random_pdag(g, 0.5)))
3-element Vector{LightGraphs.SimpleGraphs.SimpleEdge{Int64}}:
 Edge 1 => 2
 Edge 1 => 3
 Edge 3 => 1
```
"""
function random_pdag(g::SimpleDiGraph, p::Float64)::SimpleDiGraph
	result = copy(g)
	ext = fastpdag2dag_hs(g)

	done = Set{String}()
	for e in edges(result)
		isdone = "$(e.src)-$(e.dst)" in done
		!isdone && push!(done, "$(e.dst)-$(e.src)")
		(!isdone && rand() < p) || continue
		is_s2d = ext != SimpleDiGraph(0) && has_edge(ext, e.src, e.dst)
		rem_edge!(result, is_s2d ? e.dst : e.src, is_s2d ? e.src : e.dst)
	end

	result
end

"""
	erdos_renyi_pdag(n::Int64, p1::Float64, p2::Float64; seed = 123)::SimpleDiGraph

Create a partially directed graph using the
[Erdős–Rényi model](https://en.wikipedia.org/wiki/Erd%C5%91s%E2%80%93R%C3%A9nyi_model).
The graph has `n` vertices with a probability `p1` for having an edge
between two vertices. `p2` is the probablity for an edge to be directed.

# Examples
```julia-repl
julia> erdos_renyi_pdag(10, 0.2, 0.5)
{10, 12} directed simple Int64 graph
```
"""
function erdos_renyi_pdag(n::Int64, p1::Float64, p2::Float64; seed = 123)::SimpleDiGraph
	result = graph2digraph(erdos_renyi(n, p1, seed = seed))
	done = Set{String}()

	for e in edges(result)
		isdone = "$(e.src)-$(e.dst)" in done
		!isdone && push!(done, "$(e.dst)-$(e.src)")
		(!isdone && rand() < p2) || continue
		rem_edge!(result, e.src, e.dst)
	end

	result
end