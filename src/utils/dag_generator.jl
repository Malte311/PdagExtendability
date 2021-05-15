using LightGraphs

"""
	random_dag(min_r, max_r, min_v_per_r, max_v_per_r, prob)::SimpleDiGraph

Create a random DAG with the following properties: `min_r` is the minimum
rank for the DAG, `max_r` the maximum rank. `min_v_per_r` indicates the
minimum number of vertices per rank and `max_v_per_r` the maximum number
of vertices per rank. `prob` is the probability of having an edge between
two vertices.

# Examples
```julia-repl
julia> random_dag(3, 5, 3, 5, 0.2)
{15, 19} directed simple Int64 graph
julia> random_dag(3, 5, 3, 5, 0.2)
{12, 12} directed simple Int64 graph
```
"""
function random_dag(min_r, max_r, min_v_per_r, max_v_per_r, prob)::SimpleDiGraph
	nodes = 1
	edges = Vector{Tuple{Int64, Int64}}()

	for _ = min_r:max_r
		new_nodes = rand(min_v_per_r:max_v_per_r)
		for j = 1:nodes
			for k = 1:new_nodes
				rand() < prob && push!(edges, (j, k+nodes))
			end
		end
		nodes += new_nodes
	end

	g = SimpleDiGraph(nodes)
	for (u, v) in edges
		add_edge!(g, u, v)
	end
	g
end