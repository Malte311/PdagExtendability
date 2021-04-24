@testset "is_consistent_extension" begin
	
end

@testset "isdag" begin
	@testset "Isolated nodes form a DAG" begin
		for n in [3, 30, 3000]
			g = SimpleDiGraph(n)
			@test isdag(g)
		end
	end

	@testset "Valid DAG is recognized 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 1, 3)
		@test isdag(g)
	end

	@testset "Valid DAG is recognized 2" begin
		for n in [10, 100, 500]
			g = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(g, i, i+1)
			end
			@test isdag(g)
		end
	end

	@testset "Valid DAG is recognized 3" begin
		g = SimpleDiGraph(10)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 4)
		add_edge!(g, 3, 5)
		add_edge!(g, 3, 6)
		add_edge!(g, 3, 9)
		add_edge!(g, 10, 1)
		add_edge!(g, 7, 8)
		add_edge!(g, 8, 10)
		@test isdag(g)
	end

	@testset "No DAG if cycles are present 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 1)
		@test !isdag(g)
	end

	@testset "No DAG if cycles are present 2" begin
		for n in [10, 100, 500]
			g = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(g, i, i+1)
			end
			add_edge!(g, n, 1)
			@test !isdag(g)
		end
	end
	
	@testset "No DAG if undirected edges are present 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		@test !isdag(g)
	end

	@testset "No DAG if undirected edges are present 2" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 3)
		@test !isdag(g)
	end
end

@testset "skeleton" begin
	@testset "Correct skeleton of a DAG 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 1)
		@test skeleton(g) == [(1, 2), (1, 3), (2, 3)]
	end

	@testset "Correct skeleton of a DAG 2" begin
		for n in [10, 50, 100]
			g = SimpleDiGraph(n)
			for i = 1:n
				add_edge!(g, 1, i)
			end
			@test skeleton(g) == [(1, i) for i in 1:n]
		end
	end

	@testset "Correct skeleton of a PDAG 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 1)
		@test skeleton(g) == [(1, 2), (1, 3), (2, 3)]
	end

	@testset "Correct skeleton of a PDAG 2" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 1)
		add_edge!(g, 1, 3)
		@test skeleton(g) == [(1, 2), (1, 3), (2, 3)]
	end

	@testset "Correct skeleton of a PDAG 3" begin
		for n in [10, 50, 100]
			g = SimpleDiGraph(n)
			for i = 1:n
				add_edge!(g, 1, i)
				add_edge!(g, i, 1)
			end
			add_edge!(g, 2, 3)
			@test skeleton(g) == vcat([(1, i) for i in 1:n], [(2, 3)])
		end
	end

	@testset "Correct skeleton of an undirected graph 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 3)
		add_edge!(g, 3, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		@test skeleton(g) == [(1, 2), (1, 3), (2, 3)]
	end

	@testset "Correct skeleton of an undirected graph 2" begin
		for n in [10, 50, 100]
			g = SimpleDiGraph(n)
			for i = 1:n
				add_edge!(g, 1, i)
				add_edge!(g, i, 1)
			end
			@test skeleton(g) == [(1, i) for i in 1:n]
		end
	end
end

@testset "vstructures" begin
	
end

@testset "nanosec2millisec" begin
	x = 4358734598.0
	@test (x / 1000 / 1000) == nanosec2millisec(x)
end