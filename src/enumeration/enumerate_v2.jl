using LightGraphs

@isdefined(DtGraph) || include("../extendability/implementation_hs/dor_tarsi_algo_datastructure_hs.jl")
@isdefined(pdag2mpdag) || include("../extendability/implementation_mpdag/meek_rules.jl")

"""
	enumerate_v2(g::SimpleDiGraph)::Vector{DtGraph}

Compute all consistent extensions of the input graph `g` by directing
a random edge in both directions, close the result under the four
Meek rules, and recursing.

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
julia> enumerate_v2(g)
1-element Vector{DtGraph}:
 DtGraph(
	3,
	Set([2, 3, 1]),
	Set{Int64}[],
	Set{Int64}[Set(), Set([1]), Set([2])],
	Set{Int64}[Set([2]), Set([3]), Set()],
	Set{Int64}[Set(), Set(), Set()]
 )
```
"""
function enumerate_v2(g::SimpleDiGraph)::Vector{DtGraph}
	graph = setup_hs(g)

	undiredges = Vector{Tuple{Int64, Int64}}()
	for u in graph.vertices
		for v in graph.undirected[u]
			edge = (u < v ? u : v, u < v ? v : u)
			!(edge in undiredges) && push!(undiredges, edge)
		end
	end

	extsmeek_rec!(graph, countvstructs(graph), undiredges)
end

"""
	extsmeek_rec!(g::DtGraph, numvstr::UInt, undiredges::Vector)::Vector

Compute all extensions of `g` recursively by generating all possible directions
and applying Meek's rules every time an edges was directed on the resulting graph.

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
julia> mpdag = pdag2mpdag(g)
DtGraph(
	3,
	Set([2, 3, 1]),
	Set{Int64}[],
	Set{Int64}[Set(), Set([1]), Set([2])],
	Set{Int64}[Set([2]), Set([3]), Set()],
	Set{Int64}[Set(), Set(), Set()]
)
julia> extsmeek_rec!(mpdag, countvstructs(mpdag), [(2, 3)])
1-element Vector{Any}:
	DtGraph(
	3,
	Set([2, 3, 1]),
	Set{Int64}[],
	Set{Int64}[Set(), Set([1]), Set([2])],
	Set{Int64}[Set([2]), Set([3]), Set()],
	Set{Int64}[Set(), Set(), Set()]
	)
```
"""
function extsmeek_rec!(g::DtGraph, numvstr::UInt, undiredges::Vector)::Vector
	mpdag = pdag2mpdag(g, nocopy = true)

	(hasdircycle(mpdag) || countvstructs(mpdag) != numvstr) && return []

	filter!(e -> e[1] in mpdag.undirected[e[2]], undiredges)

	isempty(undiredges) && return [g]

	# Take any undirected edge, direct it in both directions and recurse.
	nxtedge = pop!(undiredges)
	gcpyfirst = deepcopy(mpdag)
	delete!(gcpyfirst.undirected[nxtedge[1]], nxtedge[2])
	delete!(gcpyfirst.undirected[nxtedge[2]], nxtedge[1])
	gcpysecond = deepcopy(gcpyfirst)

	push!(gcpyfirst.ingoing[nxtedge[1]], nxtedge[2])
	push!(gcpyfirst.outgoing[nxtedge[2]], nxtedge[1])
	first = extensions_rec!(gcpyfirst, numvstr, copy(undiredges))

	push!(gcpysecond.ingoing[nxtedge[2]], nxtedge[1])
	push!(gcpysecond.outgoing[nxtedge[1]], nxtedge[2])
	second = extensions_rec!(gcpysecond, numvstr, copy(undiredges))

	return vcat(first, second)
end