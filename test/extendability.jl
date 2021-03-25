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

	# TODO: R3 and R4 make no sense because the extension is not unique, but there is a bug
	# @testset "Meek Rule R3" begin
	# 	in = SimpleDiGraph(4)
	# 	add_edge!(in, 1, 2)
	# 	add_edge!(in, 2, 1)
	# 	add_edge!(in, 1, 3)
	# 	add_edge!(in, 3, 1)
	# 	add_edge!(in, 1, 4)
	# 	add_edge!(in, 4, 1)
	# 	add_edge!(in, 2, 3)
	# 	add_edge!(in, 4, 3)
	# 	out = pdag2dag(in)
	# 	plotpng(out, "a.png")
	# 	@test nv(out) == 4 && ne(out) == 7 && has_edge(out, 1, 2) &&
	# 		has_edge(out, 2, 1) && has_edge(out, 1, 3) && has_edge(out, 1, 4) &&
	# 		has_edge(out, 4, 1) && has_edge(out, 2, 3) && has_edge(out, 4, 3)
	# end

	# @testset "Meek Rule R4" begin
	# 	in = SimpleDiGraph(4)
	# 	add_edge!(in, 1, 2)
	# 	add_edge!(in, 2, 1)
	# 	add_edge!(in, 1, 3)
	# 	add_edge!(in, 3, 1)
	# 	add_edge!(in, 1, 4)
	# 	add_edge!(in, 4, 1)
	# 	add_edge!(in, 3, 2)
	# 	add_edge!(in, 4, 3)
	# 	out = pdag2dag(in)
	# 	@test nv(out) == 4 && ne(out) == 7 && has_edge(out, 1, 2) &&
	# 		has_edge(out, 1, 3) && has_edge(out, 3, 1) && has_edge(out, 1, 4) &&
	# 		has_edge(out, 4, 1) && has_edge(out, 3, 2) && has_edge(out, 4, 3)
	# end

	# @testset "Empty graph if no consistent extension possible" begin
	# 	in = SimpleDiGraph(4)
		
	# end
end

@testset "sink" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	add_edge!(g, 2, 3)
	add_edge!(g, 3, 2)
	@test sink(g) == 3
end