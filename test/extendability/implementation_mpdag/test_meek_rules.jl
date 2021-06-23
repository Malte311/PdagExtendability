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

	@testset "Small PDAG 1" begin
		input = SimpleDiGraph(5)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		add_edge!(input, 1, 5)
		add_edge!(input, 5, 1)
		out = dtgraph2digraph(pdag2mpdag(input))
		@test nv(out) == 5 && ne(out) == 9 && has_edge(out, 1, 2) &&
			has_edge(out, 2, 1) && has_edge(out, 1, 3) && has_edge(out, 1, 4) &&
			has_edge(out, 4, 1) && has_edge(out, 2, 3) && has_edge(out, 4, 3) &&
			has_edge(out, 1, 5) && has_edge(out, 5, 1)
	end

	@testset "Small PDAG 2" begin
		input = SimpleDiGraph(5)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		add_edge!(input, 1, 5)
		add_edge!(input, 5, 1)
		add_edge!(input, 5, 3)
		out = dtgraph2digraph(pdag2mpdag(input))
		@test nv(out) == 5 && ne(out) == 10 && has_edge(out, 1, 2) &&
			has_edge(out, 2, 1) && has_edge(out, 1, 3) && has_edge(out, 1, 4) &&
			has_edge(out, 4, 1) && has_edge(out, 2, 3) && has_edge(out, 4, 3) &&
			has_edge(out, 1, 5) && has_edge(out, 5, 1) && has_edge(out, 5, 3)
	end

	@testset "No changes for MPDAG inputs 1" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		add_edge!(input, 4, 2)
		out = dtgraph2digraph(pdag2mpdag(input))
		@test input == out
	end

	@testset "No changes for MPDAG inputs 2" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		add_edge!(input, 2, 4)
		out = dtgraph2digraph(pdag2mpdag(input))
		@test input == out
	end

	@testset "No changes for MPDAG inputs 3" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 1, 4)
		add_edge!(input, 4, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 4, 3)
		add_edge!(input, 2, 4)
		add_edge!(input, 4, 2)
		out = dtgraph2digraph(pdag2mpdag(input))
		@test input == out
	end

	@testset "No changes for DAG inputs 1" begin
		input = SimpleDiGraph(2)
		add_edge!(input, 1, 2)
		out = dtgraph2digraph(pdag2mpdag(input))
		@test input == out
	end

	@testset "No changes for DAG inputs 2" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 3)
		out = dtgraph2digraph(pdag2mpdag(input))
		@test input == out
	end

	@testset "No changes for DAG inputs 3" begin
		for n in [50, 100, 500]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
			end
			out = dtgraph2digraph(pdag2mpdag(input))
			@test input == out
		end
	end

	@testset "No changes for fully undirected inputs 1" begin
		input = SimpleDiGraph(2)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		out = dtgraph2digraph(pdag2mpdag(input))
		@test input == out
	end

	@testset "No changes for fully undirected inputs 2" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 1)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		out = dtgraph2digraph(pdag2mpdag(input))
		@test input == out
	end

	@testset "No changes for fully undirected inputs 3" begin
		for n in [50, 100, 500]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
				add_edge!(input, i+1, i)
			end
			out = dtgraph2digraph(pdag2mpdag(input))
			@test input == out
		end
	end
end

@testset "ismpdag" begin
	@testset "Detects an actual MPDAG 1" begin
		# Meek rule 1 output
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			@test ismpdag(input)
		end
	end

	@testset "Detects an actual MPDAG 2" begin
		# Meek rule 2 output
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 1, 3)
			add_edge!(input, 2, 3)
			@test ismpdag(input)
		end
	end

	@testset "Detects an actual MPDAG 3" begin
		# Meek rule 3 output
		for n in [4, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 2, 3)
			add_edge!(input, 4, 3)
			@test ismpdag(input)
		end
	end

	@testset "Detects an actual MPDAG 4" begin
		# Meek rule 4 output
		for n in [4, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 3, 2)
			add_edge!(input, 4, 3)
			@test ismpdag(input)
		end
	end

	@testset "Detects when the input is no MPDAG 1" begin
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 1)
			@test !ismpdag(input)
		end
	end

	@testset "Detects when the input is no MPDAG 2" begin
		# Meek rule 1
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			@test !ismpdag(input)
		end
	end

	@testset "Detects when the input is no MPDAG 3" begin
		# Meek rule 2
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 2, 3)
			@test !ismpdag(input)
		end
	end

	@testset "Detects when the input is no MPDAG 4" begin
		# Meek rule 3
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 2, 3)
			add_edge!(input, 4, 3)
			@test !ismpdag(input)
		end
	end

	@testset "Detects when the input is no MPDAG 5" begin
		# Meek rule 4
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 3, 2)
			add_edge!(input, 4, 3)
			@test !ismpdag(input)
		end
	end
end

@testset "hasdircycle" begin
	@testset "Detects a directed cycle 1" begin
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 1)
			@test hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects a directed cycle 2" begin
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 2)
			@test hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects a directed cycle 3" begin
		for n in [5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 2)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 4)
			@test hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects a directed cycle 4" begin
		for n in [5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 4)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 1)
			@test hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects a directed cycle 5" begin
		for n in [5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 4)
			add_edge!(input, 4, 2)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 4)
			@test hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects a directed cycle 6" begin
		for n in [5, 10, 100, 500, 1000]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
			end
			add_edge!(input, n, 1)
			@test hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects when there is no directed cycle 1" begin
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			add_edge!(input, 3, 1)
			@test !hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects when there is no directed cycle 2" begin
		for n in [3, 5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 2)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 2)
			@test !hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects when there is no directed cycle 3" begin
		for n in [5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 3, 2)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 4)
			@test !hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects when there is no directed cycle 4" begin
		for n in [5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 4)
			add_edge!(input, 4, 3)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 1)
			@test !hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects when there is no directed cycle 5" begin
		for n in [5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 4)
			add_edge!(input, 2, 4)
			add_edge!(input, 4, 2)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 4)
			@test !hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects when there is no directed cycle 6" begin
		for n in [5, 10, 100, 500, 1000]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
			end
			add_edge!(input, n, 1)
			add_edge!(input, 1, n)
			@test !hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects when there is no directed cycle 7" begin
		for n in [5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 3, 1)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 4)
			add_edge!(input, 2, 4)
			add_edge!(input, 4, 2)
			add_edge!(input, 5, 4)
			@test !hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects when there is no directed cycle 8" begin
		for n in [5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			add_edge!(input, 3, 1)
			add_edge!(input, 1, 3)
			@test !hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects when there is no directed cycle 9" begin
		for n in [5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 3, 2)
			add_edge!(input, 4, 2)
			add_edge!(input, 5, 2)
			@test !hasdircycle(setup_hs(input))
		end
	end

	@testset "Detects when there is no directed cycle 10" begin
		for n in [5, 10]
			input = SimpleDiGraph(n)
			add_edge!(input, 1, 2)
			add_edge!(input, 1, 3)
			add_edge!(input, 2, 3)
			@test !hasdircycle(setup_hs(input))
		end
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