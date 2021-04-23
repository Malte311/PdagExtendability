using LightGraphs

"""
	pdag2dag_debug_lg(g::SimpleDiGraph)::SimpleDiGraph

Debug version of [`pdag2dag_lg`](@ref).
```
"""
function pdag2dag_debug_lg(g::SimpleDiGraph)::SimpleDiGraph
	result = copy(g)
	temp = copy(g)

	# Hashtable for mappings of node labels because rem_vertex!
	# swaps the vertex to be deleted with vertex |V| and deletes
	# vertex |V| from the graph.
	ht = Dict()

	iterations = 0
	runs = 0

	# If one vertex is left there are no edges to other vertices anymore,
	# so we can stop (no need to do another iteration for nv(temp) == 1).
	while nv(temp) > 1
		runs += 1
		(x, iter) = sink_debug_lg(temp)
		iterations += iter

		x != -1 || @info "Average iterations: $(iterations / runs)"
		x != -1 || return SimpleDiGraph(0)
		
		# Direct all adjacent edges towards x
		for neighbor in outneighbors(temp, x)
			rem_edge!(result, get(ht, x, x), get(ht, neighbor, neighbor))
		end
		
		ht[x] = get(ht, get(ht, x, nv(temp)), nv(temp))
		rem_vertex!(temp, x)
	end

	@info "Average iterations: $(iterations / runs)"

	result
end

"""
	sink_debug_lg(g::SimpleDiGraph)::Tuple{Int64, Int64}

Debug version of [`sink_lg`](@ref).
"""
function sink_debug_lg(g::SimpleDiGraph)::Tuple{Int64, Int64}
	iterations = 0

	for vertex in vertices(g)
		iterations += 1

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

		return (vertex, iterations)

		@label outer
	end

	(-1, iterations)
end