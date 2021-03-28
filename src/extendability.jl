using LightGraphs

"""
	pdag2dag(g::SimpleDiGraph)::SimpleDiGraph

Convert a partially directed acyclic graph (PDAG) into a fully
directed acyclic graph (DAG).

Undirected edges are represented as two directed edges.

# References
D. Dor, M. Tarsi (1992). A simple algorithm to construct a consistent
extension of a partially oriented graph.
Technicial Report R-185, Cognitive Systems Laboratory, UCLA

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
julia> dag = pdag2dag(g)
{3, 2} directed simple Int64 graph
julia> collect(edges(dag))
2-element Array{LightGraphs.SimpleGraphs.SimpleEdge{Int64},1}:
 Edge 1 => 2
 Edge 2 => 3
```
"""
function pdag2dag(g::SimpleDiGraph)::SimpleDiGraph
	result = copy(g)
	temp = copy(g)

	# Hashtable for mappings of node labels because rem_vertex!
	# swaps the vertex to be deleted with vertex |V| and deletes
	# vertex |V| from the graph.
	ht = Dict()

	# If one vertex is left there are no edges to other vertices anymore,
	# so we can stop (no need to do another iteration when nv(temp) == 1).
	while nv(temp) > 1
		x = sink(temp)
		x != -1 || return SimpleDiGraph(0)
		
		# Direct all adjacent edges towards x
		for neighbor in outneighbors(temp, x)
			rem_edge!(result, x, get(ht, neighbor, neighbor))
		end
		
		ht[x] = get(ht, get(ht, x, nv(temp)), nv(temp))
		rem_vertex!(temp, x)
	end

	result
end

"""
	sink(g::SimpleDiGraph)::Int64

Find a sink in a partially directed graph. The sink has no outgoing edges
and all vertices connected to it via an undirected edge are adjacent to all
adjacent vertices of the sink. If no sink is found, -1 is returned.

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
julia> x = sink(g)
3
```
"""
function sink(g::SimpleDiGraph)::Int64
	for vertex in vertices(g)
		in_neighbors = inneighbors(g, vertex)
		out_neighbors = outneighbors(g, vertex)

		# A sink has no outgoing edges, i.e., outneighbors is either
		# empty or contains only vertices connected via undirected edges.
		for neighbor in out_neighbors
			# Edge must be undirected, otherwise no sink is possible
			has_edge(g, neighbor, vertex) || @goto outer
		end

		# All vertices connected to x via an undirected edge (i.e., all
		# vertices from outneighbors because we already verified that
		# all outneighbors have undirected edges) must be adjacent to all
		# vertices adjacent to x.
		for neighbor in out_neighbors
			for other in union(in_neighbors, out_neighbors)
				neighbor != other || continue
				has_edge(g, neighbor, other) || has_edge(g, other, neighbor) || @goto outer
			end
		end

		return vertex

		@label outer
	end

	-1
end