@testset "dir2dag" begin
	@testset "No changes for DAG inputs 1" begin
		input = SimpleDiGraph(2)
		add_edge!(input, 1, 2)
		out = dir2dag(input)
		@test out == input
	end

	@testset "No changes for DAG inputs 2" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 3)
		out = dir2dag(input)
		@test out == input
	end

	@testset "No changes for DAG inputs 3" begin
		for n in [50, 100, 250, 500]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
			end
			output = dir2dag(input)
			@test input == output
		end
	end

	@testset "Empty graph if input is cyclic" begin
		for n in [5, 50, 100, 250, 500]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
			end
			add_edge!(input, n, 1)
			output = dir2dag(input)
			@test output == SimpleDiGraph(0)
		end
	end
end

@testset "iscyclic" begin
	@testset "Returns true if input is cyclic" begin
		for n in [5, 50, 100, 250, 500]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
			end
			add_edge!(input, n, 1)
			@test iscyclic!(setup_hs(input))
		end
	end

	@testset "Returns false if input is acyclic" begin
		for n in [5, 50, 100, 250, 500]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
			end
			@test !iscyclic!(setup_hs(input))
		end
	end
end