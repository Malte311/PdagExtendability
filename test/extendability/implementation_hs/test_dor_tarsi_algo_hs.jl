@testset "pdag2dag_hs" begin
	@testset "No changes for DAG inputs 1" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(2)
			add_edge!(input, 1, 2)
			out = pdag2dag_hs(input, useheuristic)
			@test out == input
		end
	end

	@testset "No changes for DAG inputs 2" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(3)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			out = pdag2dag_hs(input, useheuristic)
			@test out == input
		end
	end

	@testset "No changes for DAG inputs 3" begin
		for useheuristic in [false, true]
			for n in [50, 100, 500]
				input = SimpleDiGraph(n)
				for i = 1:n-1
					add_edge!(input, i, i+1)
				end
				output = pdag2dag_hs(input, useheuristic)
				@test input == output
			end
		end
	end

	@testset "Meek Rule R1" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(3)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			out = pdag2dag_hs(input, useheuristic)
			@test nv(out) == 3 && ne(out) == 2 && has_edge(out, 1, 2) &&
				has_edge(out, 2, 3)
		end
	end

	@testset "Meek Rule R2" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(3)
			add_edge!(input, 1, 2)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 2, 3)
			out = pdag2dag_hs(input, useheuristic)
			@test nv(out) == 3 && ne(out) == 3 && has_edge(out, 1, 2) &&
				has_edge(out, 1, 3) && has_edge(out, 2, 3)
		end
	end

	@testset "Meek Rule R3" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 2, 3)
			add_edge!(input, 4, 3)
			out = pdag2dag_hs(input, useheuristic)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "Meek Rule R4" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 3, 2)
			add_edge!(input, 4, 3)
			out = pdag2dag_hs(input, useheuristic)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 1" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			add_edge!(input, 3, 4)
			out = pdag2dag_hs(input, useheuristic)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 2" begin
		for useheuristic in [false, true]
			for n in [20, 50, 100]
				input = SimpleDiGraph(n)
				for i = 1:n-1
					add_edge!(input, i, i+1)
					i % 2 == 0 && add_edge!(input, i+1, i)
				end
				out = pdag2dag_hs(input, useheuristic)
				@test is_consistent_extension(out, input)
			end
		end
	end

	@testset "More PDAGs with possible extensions 3" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(5)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 4)
			add_edge!(input, 5, 2)
			add_edge!(input, 5, 3)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			out = pdag2dag_hs(input, useheuristic)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 4" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(5)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 5, 4)
			add_edge!(input, 5, 2)
			add_edge!(input, 5, 3)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			out = pdag2dag_hs(input, useheuristic)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 5" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(5)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 4)
			add_edge!(input, 5, 2)
			add_edge!(input, 5, 3)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			out = pdag2dag_hs(input, useheuristic)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 6" begin
		for useheuristic in [false, true]
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
			out = pdag2dag_hs(input, useheuristic)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 7" begin
		for useheuristic in [false, true]
			for n in [5, 50, 100]
				input = graph2digraph(bintreegraph(n))
				output = pdag2dag_hs(input, useheuristic)
				@test is_consistent_extension(output, input)
			end
		end
	end

	@testset "More PDAGs with possible extensions 8" begin
		for useheuristic in [false, true]
			for n in [5, 50, 100]
				input = graph2digraph(pathgraph(n))
				output = pdag2dag_hs(input, useheuristic)
				@test is_consistent_extension(output, input)
			end
		end
	end

	@testset "More PDAGs with possible extensions 9" begin
		for useheuristic in [false, true]
			for n in [5, 50, 100]
				input = graph2digraph(stargraph(n))
				output = pdag2dag_hs(input, useheuristic)
				@test is_consistent_extension(output, input)
			end
		end
	end

	@testset "Empty graph if no consistent extension is possible 1" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 2, 4)
			add_edge!(input, 4, 2)
			add_edge!(input, 3, 4)
			add_edge!(input, 4, 3)
			out = pdag2dag_hs(input, useheuristic)
			@test out == SimpleDiGraph(0)
		end
	end

	@testset "Empty graph if no consistent extension is possible 2" begin
		for useheuristic in [false, true]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 4)
			add_edge!(input, 2, 1)
			add_edge!(input, 2, 4)
			add_edge!(input, 4, 2)
			add_edge!(input, 3, 1)
			add_edge!(input, 3, 4)
			add_edge!(input, 4, 3)
			out = pdag2dag_hs(input, useheuristic)
			@test out == SimpleDiGraph(0)
		end
	end

	@testset "Empty graph if no consistent extension is possible 3" begin
		for useheuristic in [false, true]
			for n in [50, 100, 500]
				input = SimpleDiGraph(n)
				for i = 1:n-1
					add_edge!(input, i, i+1)
					add_edge!(input, i+1, i)
				end
				add_edge!(input, 1, n)
				add_edge!(input, n, 1)
				output = pdag2dag_hs(input, useheuristic)
				@test output == SimpleDiGraph(0)
			end
		end
	end

	@testset "Empty graph if no consistent extension is possible 4" begin
		for useheuristic in [false, true]
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
			out = pdag2dag_hs(input, useheuristic)
			@test out == SimpleDiGraph(0)
		end
	end

	@testset "Empty graph if no consistent extension is possible 5" begin
		for useheuristic in [false, true]
			for n in [5, 50, 100]
				input = graph2digraph(cyclegraph(n))
				output = pdag2dag_hs(input, useheuristic)
				@test output == SimpleDiGraph(0)
			end
		end
	end
end

@testset "sink_hs" begin
	@testset "No sink found if no sink exists" begin
		for useheuristic in [false, true]
			for n in [50, 500, 1000]
				ds = setup_hs(graph2digraph(cyclegraph(n)), useheuristic)
				@test sink_hs(ds, useheuristic) == -1
			end
		end
	end

	@testset "Find the correct sink" begin
		for useheuristic in [false, true]
			g = SimpleDiGraph(3)
			add_edge!(g, 1, 2)
			add_edge!(g, 2, 3)
			add_edge!(g, 3, 2)
			ds = setup_hs(g, useheuristic)
			@test sink_hs(ds, useheuristic) == 3
		end
	end
end