@testset "undir2dag" begin
	@testset "Finds a consistent extension for chordal graphs 1" begin
		input = SimpleGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 1, 3)
		add_edge!(input, 2, 3)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 2" begin
		input = SimpleGraph(5)
		add_edge!(input, 1, 2)
		add_edge!(input, 1, 4)
		add_edge!(input, 1, 5)
		add_edge!(input, 2, 3)
		add_edge!(input, 2, 4)
		add_edge!(input, 2, 5)
		add_edge!(input, 3, 5)
		add_edge!(input, 4, 5)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 3" begin
		input = SimpleGraph(5)
		add_edge!(input, 1, 2)
		add_edge!(input, 1, 4)
		add_edge!(input, 1, 5)
		add_edge!(input, 2, 3)
		add_edge!(input, 2, 4)
		add_edge!(input, 2, 5)
		add_edge!(input, 3, 4)
		add_edge!(input, 3, 5)
		add_edge!(input, 4, 5)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 4" begin
		input = SimpleGraph(10)
		add_edge!(input, 1, 2)
		add_edge!(input, 3, 4)
		add_edge!(input, 3, 5)
		add_edge!(input, 3, 6)
		add_edge!(input, 3, 7)
		add_edge!(input, 3, 9)
		add_edge!(input, 3, 10)
		add_edge!(input, 4, 8)
		add_edge!(input, 4, 9)
		add_edge!(input, 4, 10)
		add_edge!(input, 5, 6)
		add_edge!(input, 5, 7)
		add_edge!(input, 5, 10)
		add_edge!(input, 6, 7)
		add_edge!(input, 6, 10)
		add_edge!(input, 7, 10)
		add_edge!(input, 9, 10)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 5" begin
		input = SimpleGraph(50)
		add_edge!(input, 1, 28)
		add_edge!(input, 3, 13)
		add_edge!(input, 4, 7)
		add_edge!(input, 4, 35)
		add_edge!(input, 7, 35)
		add_edge!(input, 8, 39)
		add_edge!(input, 8, 46)
		add_edge!(input, 11, 43)
		add_edge!(input, 11, 45)
		add_edge!(input, 15, 22)
		add_edge!(input, 19, 24)
		add_edge!(input, 20, 37)
		add_edge!(input, 21, 41)
		add_edge!(input, 23, 40)
		add_edge!(input, 29, 50)
		add_edge!(input, 31, 48)
		add_edge!(input, 39, 46)
		add_edge!(input, 43, 45)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 6" begin
		input = SimpleGraph(8)
		add_edge!(input, 1, 3)
		add_edge!(input, 1, 6)
		add_edge!(input, 1, 7)
		add_edge!(input, 3, 6)
		add_edge!(input, 3, 7)
		add_edge!(input, 4, 8)
		add_edge!(input, 6, 7)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 7" begin
		input = SimpleGraph(8)
		add_edge!(input, 1, 7)
		add_edge!(input, 3, 6)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 8" begin
		input = SimpleGraph(8)
		add_edge!(input, 1, 6)
		add_edge!(input, 1, 7)
		add_edge!(input, 3, 4)
		add_edge!(input, 3, 5)
		add_edge!(input, 3, 8)
		add_edge!(input, 4, 5)
		add_edge!(input, 4, 8)
		add_edge!(input, 5, 8)
		add_edge!(input, 6, 7)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 9" begin
		input = SimpleGraph(8)
		add_edge!(input, 1, 8)
		add_edge!(input, 1, 5)
		add_edge!(input, 1, 6)
		add_edge!(input, 1, 3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 4)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 5)
		add_edge!(input, 3, 4)
		add_edge!(input, 5, 8)
		add_edge!(input, 5, 6)
		add_edge!(input, 5, 7)
		add_edge!(input, 6, 8)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 10" begin
		input = SimpleGraph(8)
		add_edge!(input, 1, 2)
		add_edge!(input, 1, 3)
		add_edge!(input, 1, 4)
		add_edge!(input, 3, 4)
		add_edge!(input, 3, 5)
		add_edge!(input, 3, 6)
		add_edge!(input, 3, 7)
		add_edge!(input, 3, 8)
		add_edge!(input, 4, 5)
		add_edge!(input, 5, 6)
		add_edge!(input, 5, 7)
		add_edge!(input, 5, 8)
		add_edge!(input, 6, 7)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 11" begin
		input = SimpleGraph(5)
		add_edge!(input, 2, 3)
		add_edge!(input, 2, 4)
		add_edge!(input, 3, 4)
		add_edge!(input, 4, 5)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Finds a consistent extension for chordal graphs 12" begin
		input = SimpleGraph(10)
		for src in [1, 2, 3]
			for dst in [2, 3, 4, 5, 6, 7, 8, 9, 10]
				src < dst || continue
				add_edge!(input, src, dst)
			end
		end
		add_edge!(input, 4, 5)
		add_edge!(input, 4, 6)
		add_edge!(input, 5, 6)
		add_edge!(input, 5, 7)
		add_edge!(input, 5, 8)
		add_edge!(input, 5, 9)
		add_edge!(input, 5, 10)
		add_edge!(input, 6, 7)
		add_edge!(input, 6, 8)
		add_edge!(input, 6, 9)
		add_edge!(input, 6, 10)
		add_edge!(input, 8, 9)
		add_edge!(input, 8, 10)
		add_edge!(input, 9, 10)
		input = graph2digraph(input)
		output = undir2dag(input)
		@test is_consistent_extension(output, input)
	end

	@testset "Non-chordal graphs are not extendable 1" begin
		for n in [4, 5, 10, 50, 100]
			input = graph2digraph(cyclegraph(n))
			output = undir2dag(input)
			@test output == SimpleDiGraph(0)
		end
	end
end

@testset "ispeo" begin
	@testset "Perfect elimination order" begin
		input = SimpleGraph(5)
		add_edge!(input, 2, 3)
		add_edge!(input, 2, 4)
		add_edge!(input, 3, 4)
		add_edge!(input, 4, 5)
		g = setup_hs(graph2digraph(input))
		@test ispeo(g, mcs(g))
	end

	@testset "No perfect elimination order" begin
		for n in [4, 5, 10, 50, 100]
			g = setup_hs(graph2digraph(cyclegraph(n)))
			@test !ispeo(g, mcs(g))
		end
	end
end