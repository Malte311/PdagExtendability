using LightGraphs

@isdefined(setup_hs) || include("../implementation_hs/dor_tarsi_algo_datastructure_hs.jl")
@isdefined(pdag2mpdag) || include("meek_rules.jl")
@isdefined(mpdag2dag) || include("new_algo_mpdag.jl")


"""
	pdag2mpdag2dag(g::SimpleDiGraph)::SimpleDiGraph

Convert a PDAG into a DAG. First, Meek's rules are applied exhaustively
to the input graph, then it is checked whether cycles or new v-structures
were formed (if so, the input is not extendable) and lastly, the resulting
MPDAG is converted into a DAG in linear time.

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
julia> collect(edges(pdag2mpdag2dag(g)))
2-element Vector{LightGraphs.SimpleGraphs.SimpleEdge{Int64}}:
 Edge 1 => 2
 Edge 2 => 3
```
"""
function pdag2mpdag2dag(g::SimpleDiGraph)::SimpleDiGraph
	graph = setup_hs(g)
	mpdag = pdag2mpdag(g)

	!hasdircycle(mpdag) || return SimpleDiGraph(0)
	countvstructs(graph) == countvstructs(mpdag) || return SimpleDiGraph(0)

	mpdag2dag(dtgraph2digraph(mpdag))
end

"""
	countvstructs(g::DtGraph)::UInt

Count the numer of v-structures in the given graph `g`.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 3, 2)
true
julia> countvstructs(setup_hs(g))
1
```
"""
function countvstructs(g::DtGraph)::UInt
	n = g.numvertices
	counter = 0

	# a -> b <- c
	for a = 1:n, c = (a+1):n
		!isadjacent_hs(g, a, c) || continue
		counter += length(intersect(g.outgoing[a], g.outgoing[c]))
	end

	counter
end