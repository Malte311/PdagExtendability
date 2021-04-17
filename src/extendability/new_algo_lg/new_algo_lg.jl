using LightGraphs

include("new_algo_datastructure_lg.jl")

function fastpdag2dag_lg(g::SimpleDiGraph, optimize::Bool = false)::SimpleDiGraph
	graph = standardsetup_lg(g)

	extend_graph_lg(g, graph)
end


function standardsetup_lg(g::SimpleDiGraph)::Graph
	graph = init_lg(nv(g))
	done = Set{String}()

	for e in edges(g)
		isundirected = fast_has_edge(g, e.dst, e.src)

		if isundirected
			!("$(e.src)-$(e.dst)" in done) && insert_edge_lg!(graph, e.src, e.dst)
			push!(done, "$(e.dst)-$(e.src)") # Mark edge as done
		else
			insert_arc_lg!(graph, e.src, e.dst)
		end
	end

	graph
end

function extend_graph_lg(g::SimpleDiGraph, graph::Graph)::SimpleDiGraph
	result = copy(g)

	ps = list_ps_lg(graph)

	while !isempty(ps)
		s = pop!(ps)

		for undirected in outneighbors(graph.g, s)
			rem_edge!(result, s, undirected)
		end

		newps = pop_ps_lg!(graph, s)
		isempty(newps) || push!(ps, newps...)
	end

	isempty(edges(graph.g)) || return SimpleDiGraph(0)

	result
end