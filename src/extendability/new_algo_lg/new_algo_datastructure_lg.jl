using LightGraphs

"""
The datastructure to store a partially directed graph.
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


function init(g::SimpleDiGraph)::Graph
	n = nv(g)

	Graph(
		g,
		fill(0, n),
		fill(0, n),
		fill(0, n),
		fill(0, n)
	)
end


function is_adjacent(graph::Graph, u::Int64, v::Int64)::Bool
	has_edge(graph.g, u, v) || has_edge(graph.g, v, u)
end


function is_directed(graph::Graph, u::Int64, v::Int64)::Bool
	has_edge(graph.g, u, v) && !has_edge(graph.g, v, u)
end


function is_undirected(graph::Graph, u::Int64, v::Int64)::Bool
	has_edge(graph.g, u, v) && has_edge(graph.g, v, u)
end


function insert_arc!(graph::Graph, u::Int64, v::Int64)
	add_edge!(graph.g, u, v)

	graph.deltaplus_dir[u] += 1
	graph.deltaminus_dir[v] += 1

	update_alphabeta!(graph, u, v, +1)
end


function insert_edge!(graph::Graph, u::Int64, v::Int64)
	add_edge!(graph.g, u, v)
	add_edge!(graph.g, v, u)

	graph.deltaplus_undir[u] += 1
	graph.deltaminus_undir[v] += 1
	graph.deltaplus_undir[v] += 1
	graph.deltaminus_undir[u] += 1

	update_alphabeta!(graph, u, v, +1)
end


function remove_arc!(graph::Graph, u::Int64, v::Int64)
	rem_edge!(graph.g, u, v)

	graph.deltaplus_dir[u] -= 1
	graph.deltaminus_dir[v] -= 1

	update_alphabeta!(graph, u, v, -1)
end


function remove_edge!(graph::Graph, u::Int64, v::Int64)
	rem_edge!(graph.g, u, v)
	rem_edge!(graph.g, v, u)

	graph.deltaplus_dir[u] -= 1
	graph.deltaminus_dir[v] -= 1
	graph.deltaplus_dir[v] -= 1
	graph.deltaminus_dir[u] -= 1

	update_alphabeta!(graph, u, v, -1)
end


function update_alphabeta!(g::Graph, u::Int64, v::Int64, val::Int64)
	for x in all_neighbors(g, u)
		is_adjacent(g, x, v) || continue

		is_undirected(g, u, v) && is_undirected(g, u, x) && (g.alpha[u] += val)
		is_undirected(g, u, v) && is_directed(g, x, u)   && (g.beta[u]  += val)
		is_directed(g, v, u)   && is_undirected(g, u, x) && (g.beta[u]  += val)

		is_undirected(g, v, x) && is_undirected(g, v, u) && (g.alpha[v] += val)
		is_undirected(g, v, x) && is_directed(g, u, v)   && (g.beta[v]  += val)
		is_directed(g, x, v)   && is_undirected(g, v, u) && (g.beta[v]  += val)

		is_undirected(g, x, u) && is_undirected(g, x, v) && (g.alpha[x] += val)
		is_directed(g, u, x)   && is_undirected(g, x, v) && (g.beta[x]  += val)
		is_directed(g, v, x)   && is_undirected(g, x, u) && (g.beta[x]  += val)
	end
end


function is_ps(g::Graph, s::Int64)::Bool
	g.alpha[s] == binomial(g.deltaplus_undir[s], 2) &&
	g.beta[s] == g.deltaplus_undir[s] * g.deltaminus_dir[s] &&
	g.deltaplus_dir[s] == 0
end


function list_ps(graph::Graph)::Vector{Int64}
	result = Vector{Int64}()
	
	for i = 1:nv(graph.g)
		is_ps(graph, i) && push!(result, i)
	end

	result
end


function pop_ps!(graph::Graph, s::Int64)::Vector{Int64}
	old_neighbors = all_neighbors(graph.g, s)

	# Since s is a sink, all outneighbors have undirected edges.
	undir_neighbors = outneighbors(graph.g, s)

	# Delete directed edges first (since s is a sink, there are
	# only ingoing edges which are directed).
	for ingoing in inneighbors(graph.g, s)
		isdirected(graph.g, ingoing, s) || continue

		for undirected in undir_neighbors
			is_undirected(graph, ingoing, undirected) && (g.alpha[undirected] += -1)
			is_directed(graph, ingoing, undirected) && (g.beta[undirected] += -1)
		end

		rem_edge!(graph.g, ingoing, s), s
		graph.deltaplus_dir[ingoing] -= 1
		graph.deltaminus_dir[s] -= 1
	end

	# Delete undirected edges incident to s.
	for undirected in undir_neighbors
		remove_edge!(graph, s, undirected)
	end

	result = Vector{Int64}()
	
	for old_neighbor in old_neighbors
		is_ps(graph, old_neighbor) && push!(result, old_neighbor)
	end

	result
end


function print_graph(graph::Graph, io::Core.IO = stdout)
	for i = 1:nv(graph.g)
		println(io, "Vertex $i:")
		print(io,   "\tAlpha   = $(graph.alpha[i])")
		println(io, "\tBeta    = $(graph.beta[i])")

		print(io,   "\tδ+(G1)  = $(g.deltaplus_undir[i])")
		print(io,   "\tδ-(G1)  = $(g.deltaminus_undir[i])")
		print(io,   "\tδ+(G2)  = $(g.deltaplus_dir[i])")
		println(io, "\tδ-(G2)  = $(g.deltaminus_dir[i])")

		println(io, "\tAdj     = $(join(all_neighbors(graph, i), ", "))")
		println(io, "\tIn      = $(join(inneighbors(graph, i), ", "))")
		println(io, "\tOut     = $(join(outneighbors(graph, i), ", "))")
	end
end