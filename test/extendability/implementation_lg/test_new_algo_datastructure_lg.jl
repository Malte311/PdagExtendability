@testset "init_lg" begin
	for n in [2, 20, 200]
		g = init_lg(SimpleDiGraph(n))
		@test nv(g.g) == n && ne(g.g) == 0
		@test sum(g.alpha) == 0 && sum(g.beta) == 0
		@test sum(g.deltaplus_dir) == 0 && sum(g.deltaplus_undir) == 0
		@test sum(g.deltaminus_dir) == 0 && sum(g.deltaminus_undir) == 0
	end
end

@testset "is_adjacent_lg" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	add_edge!(g, 2, 3)
	add_edge!(g, 3, 2)
	graph = init_lg(g)
	@test is_adjacent_lg(graph, 1, 2)
	@test is_adjacent_lg(graph, 2, 1)
	@test is_adjacent_lg(graph, 2, 3)
	@test is_adjacent_lg(graph, 3, 2)
	@test !is_adjacent_lg(graph, 1, 3)
	@test !is_adjacent_lg(graph, 3, 1)
end

@testset "is_directed_lg" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	add_edge!(g, 2, 3)
	add_edge!(g, 3, 2)
	graph = init_lg(g)
	@test is_directed_lg(graph, 1, 2)
	@test !is_directed_lg(graph, 2, 1)
	@test !is_directed_lg(graph, 2, 3)
	@test !is_directed_lg(graph, 3, 2)
	@test !is_directed_lg(graph, 1, 3)
	@test !is_directed_lg(graph, 3, 1)
end

@testset "is_undirected_lg" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	add_edge!(g, 2, 3)
	add_edge!(g, 3, 2)
	graph = init_lg(g)
	@test !is_undirected_lg(graph, 1, 2)
	@test !is_undirected_lg(graph, 2, 1)
	@test is_undirected_lg(graph, 2, 3)
	@test is_undirected_lg(graph, 3, 2)
	@test !is_undirected_lg(graph, 1, 3)
	@test !is_undirected_lg(graph, 3, 1)
end

@testset "insert_arc_lg!" begin
	g = SimpleDiGraph(3)
	graph = init_lg(g)
	insert_arc_lg!(graph, 2, 3, true)
	@test is_adjacent_lg(graph, 2, 3) && is_directed_lg(graph, 2, 3)
	@test graph.deltaplus_dir[2] == 1 && graph.deltaminus_dir[3] == 1
end

@testset "insert_edge_lg!" begin
	g = SimpleDiGraph(3)
	graph = init_lg(g)
	insert_edge_lg!(graph, 2, 3, true)
	@test is_adjacent_lg(graph, 2, 3) && !is_directed_lg(graph, 2, 3)
	@test graph.deltaplus_undir[1] == 0 && graph.deltaminus_undir[1] == 0
	@test graph.deltaplus_undir[2] == 1 && graph.deltaminus_undir[2] == 1
	@test graph.deltaplus_undir[3] == 1 && graph.deltaminus_undir[3] == 1
end

@testset "remove_arc_lg!" begin
	g = SimpleDiGraph(3)
	graph = init_lg(g)
	insert_arc_lg!(graph, 2, 3, true)
	@test is_adjacent_lg(graph, 2, 3) && is_directed_lg(graph, 2, 3)
	@test graph.deltaplus_dir[2] == 1 && graph.deltaminus_dir[3] == 1
	remove_arc_lg!(graph, 2, 3)
	@test !is_adjacent_lg(graph, 2, 3) && !is_directed_lg(graph, 2, 3)
	@test graph.deltaplus_dir[2] == 0 && graph.deltaminus_dir[3] == 0
end

@testset "remove_edge_lg!" begin
	g = SimpleDiGraph(3)
	graph = init_lg(g)
	insert_edge_lg!(graph, 2, 3, true)
	@test is_adjacent_lg(graph, 2, 3) && !is_directed_lg(graph, 2, 3)
	@test graph.deltaplus_undir[1] == 0 && graph.deltaminus_undir[1] == 0
	@test graph.deltaplus_undir[2] == 1 && graph.deltaminus_undir[2] == 1
	@test graph.deltaplus_undir[3] == 1 && graph.deltaminus_undir[3] == 1
	remove_edge_lg!(graph, 2, 3)
	@test !is_adjacent_lg(graph, 2, 3) && !is_directed_lg(graph, 2, 3)
	@test graph.deltaplus_undir[1] == 0 && graph.deltaminus_undir[1] == 0
	@test graph.deltaplus_undir[2] == 0 && graph.deltaminus_undir[2] == 0
	@test graph.deltaplus_undir[3] == 0 && graph.deltaminus_undir[3] == 0
end

@testset "init_auxvectors_lg!" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	add_edge!(g, 2, 3)
	add_edge!(g, 3, 2)
	add_edge!(g, 1, 3)
	add_edge!(g, 3, 1)
	graph = init_lg(g)
	init_auxvectors_lg!(graph)
	@test graph.alpha[1] == 0 && graph.beta[1] == 0
	@test graph.alpha[2] == 0 && graph.beta[2] == 1
	@test graph.alpha[3] == 1 && graph.beta[3] == 0
end

@testset "is_ps_lg" begin
	g = init_lg(SimpleDiGraph(3))
	@test is_ps_lg(g, 1)
	@test is_ps_lg(g, 2)
	@test is_ps_lg(g, 3)
	insert_arc_lg!(g, 1, 2, true)
	@test !is_ps_lg(g, 1)
	@test is_ps_lg(g, 2)
	@test is_ps_lg(g, 3)
	insert_edge_lg!(g, 2, 3, true)
	@test !is_ps_lg(g, 1)
	@test !is_ps_lg(g, 2)
	@test is_ps_lg(g, 3)
end

@testset "list_ps_lg" begin
	g = init_lg(SimpleDiGraph(3))
	@test 1 in list_ps_lg(g) && 2 in list_ps_lg(g) && 3 in list_ps_lg(g)
	insert_arc_lg!(g, 1, 2, true)
	@test !(1 in list_ps_lg(g)) && 2 in list_ps_lg(g) && 3 in list_ps_lg(g)
	insert_edge_lg!(g, 2, 3, true)
	@test !(1 in list_ps_lg(g)) && !(2 in list_ps_lg(g)) && 3 in list_ps_lg(g)
end

@testset "pop_ps_lg!" begin
	g = init_lg(SimpleDiGraph(3))
	insert_arc_lg!(g, 1, 2, true)
	insert_edge_lg!(g, 2, 3, true)
	newps = pop_ps_lg!(g, 3)
	@test 2 in newps && 1 == length(newps)
	@test !is_adjacent_lg(g, 2, 3) && !is_adjacent_lg(g, 3, 2)
	newps = pop_ps_lg!(g, 2)
	@test 1 in newps && 1 == length(newps)
	@test !is_adjacent_lg(g, 1, 2) && !is_adjacent_lg(g, 2, 1)
end