@testset "barbellgraph" begin
	for n in [2, 4, 10, 20, 25, 33, 50, 55, 67, 89, 100, 512]
		g = barbellgraph(n)
		ne1 = convert(Int, floor(n/2)*(floor(n/2)-1)/2)
		ne2 = convert(Int, ceil(n/2)*(ceil(n/2)-1)/2)
		@test nv(g) == n && ne(g) == ne1 + ne2 + 1
	end
end

@testset "bintreegraph" begin
	for n in [1, 2, 3, 4, 5, 7, 8, 16, 32, 33, 64, 89, 128, 256, 512, 1024, 2048]
		g = bintreegraph(n)
		@test nv(g) == n && ne(g) == n-1
	end
end

@testset "centipedegraph" begin
	for n in [2, 4, 8, 12, 14, 16, 32, 50, 64, 80, 128, 256, 512]
		g = centipedegraph(n)
		@test nv(g) == n && ne(g) == n-1
	end
end

@testset "cliquegraph" begin
	for n in [2, 4, 8, 12, 14, 16, 32, 50, 64, 80, 128, 256, 512]
		g = cliquegraph(n)
		@test nv(g) == n && ne(g) == n/2*(n/2-1)/2+n/2
	end
end

@testset "completegraph" begin
	for n in [2, 4, 10, 20, 25, 33, 50, 55, 67, 89, 100, 512]
		g = completegraph(n)
		@test nv(g) == n && ne(g) == n*(n-1)/2
	end
end

@testset "cyclegraph" begin
	for n in [4, 10, 20, 25, 33, 50, 55, 67, 89, 100, 512]
		g = cyclegraph(n)
		@test is_cyclic(g)
		@test nv(g) == n && ne(g) == n
	end
end

@testset "doublestargraph" begin
	for n in [4, 10, 20, 25, 33, 50, 55, 67, 89, 100, 512]
		g = doublestargraph(n)
		@test nv(g) == n && ne(g) == n-1
	end
end

@testset "friendshipgraph" begin
	for n in [5, 11, 21, 25, 33, 51, 55, 67, 89, 101, 511]
		g = friendshipgraph(n)
		@test nv(g) == n && ne(g) == 3*(n-1)/2
	end
end

@testset "pathgraph" begin
	for n in [5, 11, 21, 25, 33, 51, 55, 67, 89, 101, 511]
		g = pathgraph(n)
		@test nv(g) == n && ne(g) == n-1
	end
end

@testset "stargraph" begin
	for n in [5, 11, 21, 25, 33, 51, 55, 67, 89, 101, 511]
		g = stargraph(n)
		@test nv(g) == n && ne(g) == n-1
		check = true
		for i = 2:n
			has_edge(g, 1, i) || (check = false)
		end
		@test check
	end
end

@testset "graph2digraph" begin
	g = SimpleGraph(3)
	add_edge!(g, 1, 2)
	gdir = graph2digraph(g)
	@test ne(gdir) == 2 && has_edge(gdir, 1, 2) && has_edge(gdir, 2, 1)
	add_edge!(g, 2, 3)
	gdir = graph2digraph(g)
	@test ne(gdir) == 4 && has_edge(gdir, 1, 2) && has_edge(gdir, 2, 1) &&
		has_edge(gdir, 2, 3) && has_edge(gdir, 3, 2)
end

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