using LightGraphs

"""
The datastructure to store a partially directed graph, using the
LightGraphs library internally.
"""
mutable struct Graph
	g::SimpleDiGraph     # The actual graph
	alpha::Vector{Int64} # Number of undirected neighbors that are adjacent
	                     # to another undirected neighbor for each vertex
	beta::Vector{Int64}  # Number of undirected neighbors that are adjacent
	                     # to an ingoing neighbor for each vertex
	deltaplus_dir::Vector{Int64}    # Out-degree for each vertex (directed)
	deltaplus_undir::Vector{Int64}  # Out-degree for each vertex (undirected)
	deltaminus_dir::Vector{Int64}   # In-degree for each vertex (directed)
	deltaminus_undir::Vector{Int64} # In-degree for each vertex (undirected)
end


function init_lg(n::Int64)::Graph
	Graph(
		SimpleDiGraph(n),
		fill(0, n),
		fill(0, n),
		fill(0, n),
		fill(0, n),
		fill(0, n),
		fill(0, n)
	)
end


function is_adjacent_lg(graph::Graph, u::Int64, v::Int64)::Bool
	has_edge(graph.g, u, v) || has_edge(graph.g, v, u)
end


function is_directed_lg(graph::Graph, u::Int64, v::Int64)::Bool
	!has_edge(graph.g, v, u) && has_edge(graph.g, u, v)
end


function is_undirected_lg(graph::Graph, u::Int64, v::Int64)::Bool
	has_edge(graph.g, u, v) && has_edge(graph.g, v, u)
end


function insert_arc_lg!(graph::Graph, u::Int64, v::Int64)
	add_edge!(graph.g, u, v)

	graph.deltaplus_dir[u] += 1
	graph.deltaminus_dir[v] += 1

	update_alphabeta_lg!(graph, u, v, +1)
end


function insert_edge_lg!(graph::Graph, u::Int64, v::Int64)
	add_edge!(graph.g, u, v)
	add_edge!(graph.g, v, u)

	graph.deltaplus_undir[u] += 1
	graph.deltaminus_undir[v] += 1
	graph.deltaplus_undir[v] += 1
	graph.deltaminus_undir[u] += 1

	update_alphabeta_lg!(graph, u, v, +1)
end


function remove_arc_lg!(graph::Graph, u::Int64, v::Int64)
	rem_edge!(graph.g, u, v)

	graph.deltaplus_dir[u] -= 1
	graph.deltaminus_dir[v] -= 1

	update_alphabeta_lg!(graph, u, v, -1)
end


function remove_edge_lg!(graph::Graph, u::Int64, v::Int64)
	rem_edge!(graph.g, u, v)
	rem_edge!(graph.g, v, u)

	graph.deltaplus_undir[u] -= 1
	graph.deltaminus_undir[v] -= 1
	graph.deltaplus_undir[v] -= 1
	graph.deltaminus_undir[u] -= 1

	update_alphabeta_lg!(graph, u, v, -1)
end


function update_alphabeta_lg!(g::Graph, u::Int64, v::Int64, val::Int64)
	is_uv_undir = is_undirected_lg(g, u, v)
	is_uv_dir = is_directed_lg(g, u, v)
	is_vu_dir = is_directed_lg(g, v, u)

	for x in all_neighbors(g.g, u)
		is_adjacent_lg(g, x, v) || continue

		is_ux_undir = is_undirected_lg(g, u, x)
		is_vx_undir = is_undirected_lg(g, v, x)

		is_uv_undir && is_ux_undir && (g.alpha[u] += val)
		is_uv_undir && is_directed_lg(g, x, u) && (g.beta[u] += val)
		is_vu_dir   && is_ux_undir && (g.beta[u] += val)

		is_uv_undir && is_vx_undir && (g.alpha[v] += val)
		is_uv_dir   && is_vx_undir && (g.beta[v] += val)
		is_uv_undir && is_directed_lg(g, x, v) && (g.beta[v] += val)

		is_ux_undir && is_vx_undir && (g.alpha[x] += val)
		is_vx_undir && is_directed_lg(g, u, x) && (g.beta[x] += val)
		is_ux_undir && is_directed_lg(g, v, x) && (g.beta[x] += val)
	end
end


function is_ps_lg(g::Graph, s::Int64)::Bool
	g.deltaplus_dir[s] == 0 &&
	g.beta[s] == g.deltaplus_undir[s] * g.deltaminus_dir[s] &&
	g.alpha[s] == binomial(g.deltaplus_undir[s], 2)
end


function list_ps_lg(graph::Graph)::Vector{Int64}
	result = Vector{Int64}()
	
	for i = 1:nv(graph.g)
		is_ps_lg(graph, i) && push!(result, i)
	end

	result
end


function pop_ps_lg!(graph::Graph, s::Int64)::Vector{Int64}
	old_neighbors = copy(all_neighbors(graph.g, s))

	# Delete directed edges first (since s is a sink, there are
	# only ingoing edges which are directed).
	for ingoing in copy(inneighbors(graph.g, s))
		is_directed_lg(graph, ingoing, s) || continue

		# Since s is a sink, all outneighbors have undirected edges.
		for undir in outneighbors(graph.g, s)
			is_undirected_lg(graph, ingoing, undir) && (graph.alpha[undir] += -1)
			is_directed_lg(graph, ingoing, undir) && (graph.beta[undir] += -1)
		end

		rem_edge!(graph.g, ingoing, s)
		graph.deltaplus_dir[ingoing] -= 1
		graph.deltaminus_dir[s] -= 1
	end

	# Delete undirected edges incident to s.
	for undir in copy(outneighbors(graph.g, s))
		remove_edge_lg!(graph, s, undir)
	end

	result = Vector{Int64}()

	for old_neighbor in old_neighbors
		is_ps_lg(graph, old_neighbor) && push!(result, old_neighbor)
	end

	result
end


function print_graph_lg(graph::Graph, io::Core.IO = stdout)
	for i = 1:nv(graph.g)
		println(io, "Vertex $i:")
		print(io,   "\tAlpha   = $(graph.alpha[i])")
		println(io, "\tBeta    = $(graph.beta[i])")

		print(io,   "\tδ+(G1)  = $(graph.deltaplus_undir[i])")
		print(io,   "\tδ-(G1)  = $(graph.deltaminus_undir[i])")
		print(io,   "\tδ+(G2)  = $(graph.deltaplus_dir[i])")
		println(io, "\tδ-(G2)  = $(graph.deltaminus_dir[i])")

		println(io, "\tAdj     = $(join(all_neighbors(graph.g, i), ", "))")
		println(io, "\tIn      = $(join(inneighbors(graph.g, i), ", "))")
		println(io, "\tOut     = $(join(outneighbors(graph.g, i), ", "))")
	end
end