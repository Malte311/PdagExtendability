@testset "graph2str" begin
	@testset "Graph with no edges" begin
		for n in [3, 50, 500, 1000]
			g = SimpleDiGraph(n)
			@test "$n 0\n\n" == graph2str(g, is_only_undir = false)
			@test "$n 0\n\n" == graph2str(g, is_only_undir = true)
		end
	end

	@testset "Graph with only directed edges" begin
		for n in [3, 50, 500, 1000]
			g = SimpleDiGraph(n)
			add_edge!(g, 1, 2)
			add_edge!(g, 2, 3)
			@test "$n 2\n\n1 2\n2 3\n" == graph2str(g, is_only_undir = false)
		end
	end

	@testset "Graph with only undirected edges 1" begin
		for n in [3, 50, 500, 1000]
			g = SimpleDiGraph(n)
			add_edge!(g, 1, 2)
			add_edge!(g, 2, 1)
			add_edge!(g, 2, 3)
			add_edge!(g, 3, 2)
			@test "$n 2\n\n1 2\n2 3\n" == graph2str(g, is_only_undir = true)
		end
	end

	@testset "Graph with only undirected edges 2" begin
		for n in [3, 50, 500, 1000]
			g = SimpleDiGraph(n)
			add_edge!(g, 1, 2)
			add_edge!(g, 2, 1)
			add_edge!(g, 2, 3)
			add_edge!(g, 3, 2)
			@test "$n 4\n\n1 2\n2 1\n2 3\n3 2\n" == graph2str(g, is_only_undir = false)
		end
	end

	@testset "Graph with both directed and undirected edges 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		@test "3 3\n\n1 2\n2 3\n3 2\n" == graph2str(g, is_only_undir = false)
	end

	@testset "Graph with both directed and undirected edges 2" begin
		g = SimpleDiGraph(10)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 6, 7)
		add_edge!(g, 7, 8)
		add_edge!(g, 9, 10)
		add_edge!(g, 10, 9)
		result_str = "10 7\n\n1 2\n2 3\n3 2\n6 7\n7 8\n9 10\n10 9\n"
		@test result_str == graph2str(g, is_only_undir = false)
	end
end