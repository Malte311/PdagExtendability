@testset "pdag2dag" begin
	@testset "No changes for DAG inputs" begin
		in = SimpleDiGraph(2)
		add_edge!(in, 1, 2)
		out = pdag2dag(in)
		@test nv(out) == 2 && ne(out) == 1 && has_edge(out, 1, 2)

		in = SimpleDiGraph(3)
		add_edge!(in, 1, 2)
		add_edge!(in, 2, 3)
		out = pdag2dag(in)
		@test nv(out) == 3 && ne(out) == 2 && has_edge(out, 1, 2) &&
			has_edge(out, 2, 3)
	end

	@testset "Meek Rule R1" begin
		in = SimpleDiGraph(3)
		add_edge!(in, 1, 2)
		add_edge!(in, 2, 3)
		add_edge!(in, 3, 2)
		out = pdag2dag(in)
		@test nv(out) == 3 && ne(out) == 2 && has_edge(out, 1, 2) &&
			has_edge(out, 2, 3)
	end

	@testset "Meek Rule R2" begin
		in = SimpleDiGraph(3)
		add_edge!(in, 1, 2)
		add_edge!(in, 1, 3)
		add_edge!(in, 3, 1)
		add_edge!(in, 2, 3)
		out = pdag2dag(in)
		@test nv(out) == 3 && ne(out) == 3 && has_edge(out, 1, 2) &&
			has_edge(out, 1, 3) && has_edge(out, 2, 3)
	end

	@testset "Meek Rule R3" begin
		in = SimpleDiGraph(4)
		add_edge!(in, 1, 2)
		add_edge!(in, 2, 1)
		add_edge!(in, 1, 3)
		add_edge!(in, 3, 1)
		add_edge!(in, 1, 4)
		add_edge!(in, 4, 1)
		add_edge!(in, 2, 3)
		add_edge!(in, 4, 3)
		out = pdag2dag(in)
		@test nv(out) == 4 && ne(out) == 5 && has_edge(out, 1, 2) &&
			has_edge(out, 1, 3) && has_edge(out, 2, 3) && has_edge(out, 4, 1) &&
			has_edge(out, 4, 3)
	end

	@testset "Meek Rule R4" begin
		in = SimpleDiGraph(4)
		add_edge!(in, 1, 2)
		add_edge!(in, 2, 1)
		add_edge!(in, 1, 3)
		add_edge!(in, 3, 1)
		add_edge!(in, 1, 4)
		add_edge!(in, 4, 1)
		add_edge!(in, 3, 2)
		add_edge!(in, 4, 3)
		out = pdag2dag(in)
		@test nv(out) == 4 && ne(out) == 5 && has_edge(out, 1, 2) &&
			has_edge(out, 3, 1) && has_edge(out, 3, 2) && has_edge(out, 4, 1) &&
			has_edge(out, 4, 3)
	end

	@testset "More PDAGs with possible extensions" begin
		in = SimpleDiGraph(4)
		add_edge!(in, 1, 2)
		add_edge!(in, 2, 3)
		add_edge!(in, 3, 2)
		add_edge!(in, 3, 4)
		out = pdag2dag(in)
		@test nv(out) == 4 && ne(out) == 3 && has_edge(out, 1, 2) &&
		has_edge(out, 2, 3) && has_edge(out, 3, 4)

		in = SimpleDiGraph(50)
		for i = 1:nv(in)-1
			add_edge!(in, i, i+1)
			i % 2 == 0 && add_edge!(in, i+1, i)
		end
		out = pdag2dag(in)
		@test nv(out) == 50 && ne(out) == nv(out)-1
		for i=1:nv(out)-1
			@test has_edge(out, i, i+1) && !has_edge(out, i+1, i)
		end
	end

	@testset "Empty graph if no consistent extension is possible" begin
		in = SimpleDiGraph(4)
		add_edge!(in, 1, 2)
		add_edge!(in, 2, 1)
		add_edge!(in, 1, 3)
		add_edge!(in, 3, 1)
		add_edge!(in, 2, 4)
		add_edge!(in, 4, 2)
		add_edge!(in, 3, 4)
		add_edge!(in, 4, 3)
		out = pdag2dag(in)
		@test nv(out) == 0 && ne(out) == 0

		in = SimpleDiGraph(4)
		add_edge!(in, 1, 4)
		add_edge!(in, 2, 1)
		add_edge!(in, 2, 4)
		add_edge!(in, 4, 2)
		add_edge!(in, 3, 1)
		add_edge!(in, 3, 4)
		add_edge!(in, 4, 3)
		out = pdag2dag(in)
		@test nv(out) == 0 && ne(out) == 0
	end
end