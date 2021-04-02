@testset "pdag2dag" begin
	@testset "No changes for DAG inputs" begin
		input = SimpleDiGraph(2)
		add_edge!(input, 1, 2)
		out = pdag2dag(input)
		@test nv(out) == 2 && ne(out) == 1 && has_edge(out, 1, 2)

		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 3)
		out = pdag2dag(input)
		@test nv(out) == 3 && ne(out) == 2 && has_edge(out, 1, 2) &&
			has_edge(out, 2, 3)

		for n in [50, 100, 500]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
			end
			output = pdag2dag(input)
			@test input == output
		end
	end

	@testset "Meek Rule R1" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		out = pdag2dag(input)
		@test nv(out) == 3 && ne(out) == 2 && has_edge(out, 1, 2) &&
			has_edge(out, 2, 3)
	end

	@testset "Meek Rule R2" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 2, 3)
		out = pdag2dag(input)
		@test nv(out) == 3 && ne(out) == 3 && has_edge(out, 1, 2) &&
			has_edge(out, 1, 3) && has_edge(out, 2, 3)
	end

	@testset "Meek Rule R3" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		out = pdag2dag(input)
		@test nv(out) == 4 && ne(out) == 5 && has_edge(out, 1, 2) &&
			has_edge(out, 1, 3) && has_edge(out, 2, 3) && has_edge(out, 4, 1) &&
			has_edge(out, 4, 3)
	end

	@testset "Meek Rule R4" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 3, 2)
		add_edge!(input, 4, 3)
		out = pdag2dag(input)
		@test nv(out) == 4 && ne(out) == 5 && has_edge(out, 1, 2) &&
			has_edge(out, 3, 1) && has_edge(out, 3, 2) && has_edge(out, 4, 1) &&
			has_edge(out, 4, 3)
	end

	@testset "More PDAGs with possible extensions" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		add_edge!(input, 3, 4)
		out = pdag2dag(input)
		@test nv(out) == 4 && ne(out) == 3 && has_edge(out, 1, 2) &&
			has_edge(out, 2, 3) && has_edge(out, 3, 4)

		for n in [20, 50, 100]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
				i % 2 == 0 && add_edge!(input, i+1, i)
			end
			out = pdag2dag(input)
			@test nv(out) == n && ne(out) == n-1
			isok = true
			for i = 1:n-1
				isok &= has_edge(out, i, i+1) && !has_edge(out, i+1, i)
			end
			@test isok
		end

		input = SimpleDiGraph(5)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 4, 5)
		add_edge!(input, 5, 4)
		add_edge!(input, 5, 2)
		add_edge!(input, 5, 3)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		out = pdag2dag(input)
		@test nv(out) == 5 && ne(out) == 5 && has_edge(out, 4, 1) &&
			has_edge(out, 5, 4) && has_edge(out, 5, 2) &&
			has_edge(out, 5, 3) && has_edge(out, 3, 2)

		input = SimpleDiGraph(5)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 5, 4)
		add_edge!(input, 5, 2)
		add_edge!(input, 5, 3)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		out = pdag2dag(input)
		@test nv(out) == 5 && ne(out) == 5 && has_edge(out, 4, 1) &&
			has_edge(out, 5, 4) && has_edge(out, 5, 2) &&
			has_edge(out, 5, 3) && has_edge(out, 3, 2)

		input = SimpleDiGraph(5)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 5)
		add_edge!(input, 5, 4)
		add_edge!(input, 5, 2)
		add_edge!(input, 5, 3)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		out = pdag2dag(input)
		@test nv(out) == 5 && ne(out) == 5 && has_edge(out, 1, 4) &&
			has_edge(out, 4, 5) && has_edge(out, 5, 2) &&
			has_edge(out, 5, 3) && has_edge(out, 3, 2)

		input = SimpleDiGraph(5)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 4, 5)
		add_edge!(input, 5, 4)
		add_edge!(input, 5, 2)
		add_edge!(input, 2, 5)
		add_edge!(input, 5, 3)
		add_edge!(input, 3, 5)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		out = pdag2dag(input)
		@test nv(out) == 5 && ne(out) == 5 && has_edge(out, 4, 1) &&
			has_edge(out, 5, 4) && has_edge(out, 5, 2) &&
			has_edge(out, 3, 5) && has_edge(out, 3, 2)
	end

	@testset "Empty graph if no consistent extension is possible" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 2, 4)
		add_edge!(input, 4, 2)
		add_edge!(input, 3, 4)
		add_edge!(input, 4, 3)
		out = pdag2dag(input)
		@test nv(out) == 0 && ne(out) == 0

		input = SimpleDiGraph(4)
		add_edge!(input, 1, 4)
		add_edge!(input, 2, 1)
		add_edge!(input, 2, 4)
		add_edge!(input, 4, 2)
		add_edge!(input, 3, 1)
		add_edge!(input, 3, 4)
		add_edge!(input, 4, 3)
		out = pdag2dag(input)
		@test nv(out) == 0 && ne(out) == 0

		for n in [50, 100, 500]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
				add_edge!(input, i+1, i)
			end
			add_edge!(input, 1, n)
			add_edge!(input, n, 1)
			output = pdag2dag(input)
			@test nv(output) == 0 && ne(output) == 0
		end

		input = SimpleDiGraph(5)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 5)
		add_edge!(input, 5, 4)
		add_edge!(input, 5, 2)
		add_edge!(input, 5, 3)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		out = pdag2dag(input)
		@test nv(out) == 0 && ne(out) == 0
	end
end

@testset "sink" begin
	input = SimpleDiGraph(3)
	add_edge!(input, 1, 2)
	add_edge!(input, 2, 3)
	add_edge!(input, 3, 2)
	@test 3 == sink(input)
	rem_vertex!(input, 3)
	@test 2 == sink(input)
	rem_vertex!(input, 2)
	@test 1 == sink(input)
end