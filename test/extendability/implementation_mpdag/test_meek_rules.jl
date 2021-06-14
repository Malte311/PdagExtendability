@testset "pdag2mpdag" begin
	@testset "Meek Rule R1" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		out = dtgraph2digraph(pdag2mpdag(input))
		@test nv(out) == 3 && ne(out) == 2 && has_edge(out, 1, 2) &&
			has_edge(out, 2, 3)
	end

	@testset "Meek Rule R2" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 2, 3)
		out = dtgraph2digraph(pdag2mpdag(input))
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
		out = dtgraph2digraph(pdag2mpdag(input))
		@test nv(out) == 4 && ne(out) == 7 && has_edge(out, 1, 2) &&
			has_edge(out, 2, 1) && has_edge(out, 1, 3) && has_edge(out, 1, 4) &&
			has_edge(out, 4, 1) && has_edge(out, 2, 3) && has_edge(out, 4, 3)
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
		out = dtgraph2digraph(pdag2mpdag(input))
		@test nv(out) == 4 && ne(out) == 7 && has_edge(out, 1, 2) &&
			has_edge(out, 1, 3) && has_edge(out, 3, 1) && has_edge(out, 1, 4) &&
			has_edge(out, 4, 1) && has_edge(out, 3, 2) && has_edge(out, 4, 3)
	end
end

@testset "dtgraph2digraph" begin
	@testset "Meek Rule R1" begin
		for useheuristic in [true, false]
			input = SimpleDiGraph(3)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			dtgraph = setup_hs(input, useheuristic)
			@test input == dtgraph2digraph(dtgraph)
		end
	end

	@testset "Meek Rule R2" begin
		for useheuristic in [true, false]
			input = SimpleDiGraph(3)
			add_edge!(input, 1, 2)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 2, 3)
			dtgraph = setup_hs(input, useheuristic)
			@test input == dtgraph2digraph(dtgraph)
		end
	end

	@testset "Meek Rule R3" begin
		for useheuristic in [true, false]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 2, 3)
			add_edge!(input, 4, 3)
			dtgraph = setup_hs(input, useheuristic)
			@test input == dtgraph2digraph(dtgraph)
		end
	end

	@testset "Meek Rule R4" begin
		for useheuristic in [true, false]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 3, 2)
			add_edge!(input, 4, 3)
			dtgraph = setup_hs(input, useheuristic)
			@test input == dtgraph2digraph(dtgraph)
		end
	end

	@testset "Works on barbell graphs" begin
		for useheuristic in [true, false]
			for n in [5, 10, 15, 50, 100, 150, 500, 750]
				input = graph2digraph(barbellgraph(n))
				dtgraph = setup_hs(input, useheuristic)
				@test input == dtgraph2digraph(dtgraph)
			end
		end
	end

	@testset "Works on binary trees" begin
		for useheuristic in [true, false]
			for n in [5, 10, 15, 50, 100, 150, 500, 750]
				input = graph2digraph(bintreegraph(n))
				dtgraph = setup_hs(input, useheuristic)
				@test input == dtgraph2digraph(dtgraph)
			end
		end
	end

	@testset "Works on complete graphs" begin
		for useheuristic in [true, false]
			for n in [5, 10, 15, 50, 100, 150, 500, 750]
				input = graph2digraph(completegraph(n))
				dtgraph = setup_hs(input, useheuristic)
				@test input == dtgraph2digraph(dtgraph)
			end
		end
	end

	@testset "Works on cycle graphs" begin
		for useheuristic in [true, false]
			for n in [5, 10, 15, 50, 100, 150, 500, 750]
				input = graph2digraph(cyclegraph(n))
				dtgraph = setup_hs(input, useheuristic)
				@test input == dtgraph2digraph(dtgraph)
			end
		end
	end

	@testset "Works on path graphs" begin
		for useheuristic in [true, false]
			for n in [5, 10, 15, 50, 100, 150, 500, 750]
				input = graph2digraph(pathgraph(n))
				dtgraph = setup_hs(input, useheuristic)
				@test input == dtgraph2digraph(dtgraph)
			end
		end
	end

	@testset "Works on star graphs" begin
		for useheuristic in [true, false]
			for n in [5, 10, 15, 50, 100, 150, 500, 750]
				input = graph2digraph(stargraph(n))
				dtgraph = setup_hs(input, useheuristic)
				@test input == dtgraph2digraph(dtgraph)
			end
		end
	end
end