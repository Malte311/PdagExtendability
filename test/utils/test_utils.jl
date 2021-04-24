@testset "is_consistent_extension" begin
	@testset "A DAG is a consistent extension of itself 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 1, 3)
		@test is_consistent_extension(g, g)
	end

	@testset "A DAG is a consistent extension of itself 2" begin
		for n in [10, 100, 500]
			g = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(g, i, i+1)
			end
			@test is_consistent_extension(g, g)
		end
	end

	@testset "Recognize consistent extension of a PDAG 1" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		extension = SimpleDiGraph(3)
		add_edge!(extension, 1, 2)
		add_edge!(extension, 2, 3)
		@test is_consistent_extension(extension, input)
	end

	@testset "Recognize consistent extension of a PDAG 2" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 2, 3)
		extension = SimpleDiGraph(3)
		add_edge!(extension, 1, 2)
		add_edge!(extension, 2, 3)
		add_edge!(extension, 1, 3)
		@test is_consistent_extension(extension, input)
	end

	@testset "Recognize consistent extension of a PDAG 3" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		extension = SimpleDiGraph(4)
		add_edge!(extension, 1, 3)
		add_edge!(extension, 2, 3)
		add_edge!(extension, 4, 3)
		add_edge!(extension, 2, 1)
		add_edge!(extension, 1, 4)
		@test is_consistent_extension(extension, input)
	end

	@testset "Recognize consistent extension of a PDAG 4" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		extension = SimpleDiGraph(4)
		add_edge!(extension, 1, 3)
		add_edge!(extension, 2, 3)
		add_edge!(extension, 4, 3)
		add_edge!(extension, 1, 2)
		add_edge!(extension, 1, 4)
		@test is_consistent_extension(extension, input)
	end

	@testset "Recognize consistent extension of a PDAG 5" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		extension = SimpleDiGraph(4)
		add_edge!(extension, 1, 3)
		add_edge!(extension, 2, 3)
		add_edge!(extension, 4, 3)
		add_edge!(extension, 1, 2)
		add_edge!(extension, 4, 1)
		@test is_consistent_extension(extension, input)
	end

	@testset "Reject wrong extension of a PDAG 1" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 2, 3)
		extension = SimpleDiGraph(3)
		add_edge!(extension, 1, 2)
		add_edge!(extension, 2, 3)
		add_edge!(extension, 3, 1)
		@test !is_consistent_extension(extension, input)
	end

	@testset "Reject wrong extension of a PDAG 2" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		extension = SimpleDiGraph(4)
		add_edge!(extension, 1, 3)
		add_edge!(extension, 2, 3)
		add_edge!(extension, 4, 3)
		add_edge!(extension, 2, 1)
		add_edge!(extension, 4, 1)
		@test !is_consistent_extension(extension, input)
	end

	@testset "Reject wrong extension of a PDAG 3" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		extension = SimpleDiGraph(4)
		add_edge!(extension, 3, 1)
		add_edge!(extension, 2, 3)
		add_edge!(extension, 4, 3)
		add_edge!(extension, 2, 1)
		add_edge!(extension, 1, 4)
		@test !is_consistent_extension(extension, input)
	end

	@testset "Recognize consistent extension of an undirected graph 1" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		extension = SimpleDiGraph(3)
		add_edge!(extension, 1, 2)
		add_edge!(extension, 1, 3)
		@test is_consistent_extension(extension, input)
	end

	@testset "Recognize consistent extension of an undirected graph 2" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		extension = SimpleDiGraph(3)
		add_edge!(extension, 2, 1)
		add_edge!(extension, 1, 3)
		@test is_consistent_extension(extension, input)
	end

	@testset "Recognize consistent extension of an undirected graph 3" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		extension = SimpleDiGraph(3)
		add_edge!(extension, 1, 2)
		add_edge!(extension, 3, 1)
		@test is_consistent_extension(extension, input)
	end

	@testset "Reject wrong extension of an undirected graph 1" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		extension = SimpleDiGraph(3)
		add_edge!(extension, 2, 1)
		add_edge!(extension, 3, 1)
		@test !is_consistent_extension(extension, input)
	end
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
	@testset "No vstructures for isolated nodes" begin
		for n in [3, 300, 500]
			g = SimpleDiGraph(n)
			@test isempty(vstructures(g))
		end
	end

	@testset "Correct vstructures of a DAG 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 3, 2)
		@test vstructures(g) == [(1, 2, 3)]
	end

	@testset "Correct vstructures of a DAG 2" begin
		g = SimpleDiGraph(5)
		add_edge!(g, 1, 5)
		add_edge!(g, 3, 5)
		add_edge!(g, 1, 4)
		add_edge!(g, 3, 4)
		add_edge!(g, 1, 2)
		add_edge!(g, 3, 2)
		@test vstructures(g) == [(1, 2, 3), (1, 4, 3), (1, 5, 3)]
	end

	@testset "Correct vstructures of a DAG 3" begin
		g = SimpleDiGraph(5)
		add_edge!(g, 1, 5)
		add_edge!(g, 3, 5)
		add_edge!(g, 1, 4)
		add_edge!(g, 3, 4)
		add_edge!(g, 1, 3)
		@test isempty(vstructures(g))
	end

	@testset "Correct vstructures of a DAG 4" begin
		g = SimpleDiGraph(5)
		add_edge!(g, 2, 5)
		add_edge!(g, 4, 5)
		add_edge!(g, 1, 4)
		add_edge!(g, 3, 4)
		add_edge!(g, 1, 3)
		@test vstructures(g) == [(2, 5, 4)]
	end

	@testset "Correct vstructures of a PDAG 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 3)
		add_edge!(g, 2, 3)
		@test isempty(vstructures(g))
	end

	@testset "Correct vstructures of a PDAG 2" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 3)
		add_edge!(g, 2, 3)
		@test isempty(vstructures(g))
	end

	@testset "Correct vstructures of a PDAG 3" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 3, 1)
		@test isempty(vstructures(g))
	end

	@testset "Correct vstructures of a PDAG 4" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 3, 1)
		add_edge!(g, 2, 4)
		add_edge!(g, 3, 4)
		@test vstructures(g) == [(2, 4, 3)]
	end

	@testset "No vstructures for an undirected graph" begin
		for n in [10, 50, 100]
			g = SimpleDiGraph(n)
			for i = 1:n
				add_edge!(g, 1, i)
				add_edge!(g, i, 1)
			end
			@test isempty(vstructures(g))
		end
	end
end

@testset "nanosec2millisec" begin
	x = 4358734598.0
	@test (x / 1000 / 1000) == nanosec2millisec(x)
end