using LightGraphs

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