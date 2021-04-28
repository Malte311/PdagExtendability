@testset "fastpdag2dag_lg" begin
	@testset "No changes for DAG inputs 1" begin
		for optimize in [true, false]
			input = SimpleDiGraph(2)
			add_edge!(input, 1, 2)
			out = fastpdag2dag_lg(input, optimize)
			@test out == input
		end
	end

	@testset "No changes for DAG inputs 2" begin
		for optimize in [true, false]
			input = SimpleDiGraph(3)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			out = fastpdag2dag_lg(input, optimize)
			@test out == input
		end
	end

	@testset "No changes for DAG inputs 3" begin
		for optimize in [true, false]
			for n in [50, 100, 500]
				input = SimpleDiGraph(n)
				for i = 1:n-1
					add_edge!(input, i, i+1)
				end
				output = fastpdag2dag_lg(input, optimize)
				@test input == output
			end
		end
	end

	@testset "Meek Rule R1" begin
		for optimize in [true, false]
			input = SimpleDiGraph(3)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			out = fastpdag2dag_lg(input, optimize)
			@test nv(out) == 3 && ne(out) == 2 && has_edge(out, 1, 2) &&
				has_edge(out, 2, 3)
		end
	end

	@testset "Meek Rule R2" begin
		for optimize in [true, false]
			input = SimpleDiGraph(3)
			add_edge!(input, 1, 2)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 2, 3)
			out = fastpdag2dag_lg(input, optimize)
			@test nv(out) == 3 && ne(out) == 3 && has_edge(out, 1, 2) &&
				has_edge(out, 1, 3) && has_edge(out, 2, 3)
		end
	end

	@testset "Meek Rule R3" begin
		for optimize in [true, false]
			g = SimpleDiGraph(4)
			add_edge!(g, 1, 2)
			add_edge!(g, 2, 1)
			add_edge!(g, 1, 3)
			add_edge!(g, 3, 1)
			add_edge!(g, 1, 4)
			add_edge!(g, 4, 1)
			add_edge!(g, 2, 3)
			add_edge!(g, 4, 3)
			
			out = fastpdag2dag_lg(g, optimize)
			@test is_consistent_extension(out, g)
		end
	end

	@testset "Meek Rule R4" begin
		for optimize in [true, false]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 3, 2)
			add_edge!(input, 4, 3)
			out = fastpdag2dag_lg(input, optimize)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 1" begin
		for optimize in [true, false]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			add_edge!(input, 3, 4)
			out = fastpdag2dag_lg(input, optimize)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 2" begin
		for optimize in [true, false]
			for n in [20, 50, 100]
				input = SimpleDiGraph(n)
				for i = 1:n-1
					add_edge!(input, i, i+1)
					i % 2 == 0 && add_edge!(input, i+1, i)
				end
				out = fastpdag2dag_lg(input, optimize)
				@test is_consistent_extension(out, input)
			end
		end
	end

	@testset "More PDAGs with possible extensions 3" begin
		for optimize in [true, false]
			input = SimpleDiGraph(5)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 4)
			add_edge!(input, 5, 2)
			add_edge!(input, 5, 3)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			out = fastpdag2dag_lg(input, optimize)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 4" begin
		for optimize in [true, false]
			input = SimpleDiGraph(5)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 5, 4)
			add_edge!(input, 5, 2)
			add_edge!(input, 5, 3)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			out = fastpdag2dag_lg(input, optimize)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 5" begin
		for optimize in [true, false]
			input = SimpleDiGraph(5)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 4)
			add_edge!(input, 5, 2)
			add_edge!(input, 5, 3)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			out = fastpdag2dag_lg(input, optimize)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "More PDAGs with possible extensions 6" begin
		for optimize in [true, false]
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
			out = fastpdag2dag_lg(input, optimize)
			@test is_consistent_extension(out, input)
		end
	end

	@testset "Empty graph if no consistent extension is possible 1" begin
		for optimize in [true, false]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 1)
			add_edge!(input, 1, 3)
			add_edge!(input, 3, 1)
			add_edge!(input, 2, 4)
			add_edge!(input, 4, 2)
			add_edge!(input, 3, 4)
			add_edge!(input, 4, 3)
			out = fastpdag2dag_lg(input, optimize)
			@test out == SimpleDiGraph(0)
		end
	end

	@testset "Empty graph if no consistent extension is possible 2" begin
		for optimize in [true, false]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 4)
			add_edge!(input, 2, 1)
			add_edge!(input, 2, 4)
			add_edge!(input, 4, 2)
			add_edge!(input, 3, 1)
			add_edge!(input, 3, 4)
			add_edge!(input, 4, 3)
			out = fastpdag2dag_lg(input, optimize)
			@test out == SimpleDiGraph(0)
		end
	end

	@testset "Empty graph if no consistent extension is possible 3" begin
		for optimize in [true, false]
			for n in [50, 100, 500]
				input = SimpleDiGraph(n)
				for i = 1:n-1
					add_edge!(input, i, i+1)
					add_edge!(input, i+1, i)
				end
				add_edge!(input, 1, n)
				add_edge!(input, n, 1)
				output = fastpdag2dag_lg(input, optimize)
				@test output == SimpleDiGraph(0)
			end
		end
	end

	@testset "Empty graph if no consistent extension is possible 4" begin
		for optimize in [true, false]
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
			out = fastpdag2dag_lg(input, optimize)
			@test out == SimpleDiGraph(0)
		end
	end
end

@testset "standardsetup_lg" begin
	input = SimpleDiGraph(3)
	add_edge!(input, 1, 2)
	add_edge!(input, 2, 3)
	add_edge!(input, 3, 2)
	graph = standardsetup_lg(input)
	@test nv(graph.g) == 3 && ne(graph.g) == 3
	@test graph.alpha == [0, 0, 0] && graph.beta == [0, 0, 0]
	@test graph.deltaplus_dir == [1, 0, 0] && graph.deltaplus_undir == [0, 1, 1]
	@test graph.deltaminus_dir == [0, 1, 0] && graph.deltaminus_undir == [0, 1, 1]
end

@testset "optimizedsetup_lg" begin
	input = SimpleDiGraph(3)
	add_edge!(input, 1, 2)
	add_edge!(input, 2, 3)
	add_edge!(input, 3, 2)
	graph = optimizedsetup_lg(input)
	@test nv(graph.g) == 3 && ne(graph.g) == 3
	@test graph.alpha == [0, 0, 0] && graph.beta == [0, 0, 0]
	@test graph.deltaplus_dir == [1, 0, 0] && graph.deltaplus_undir == [0, 1, 1]
	@test graph.deltaminus_dir == [0, 1, 0] && graph.deltaminus_undir == [0, 1, 1]
end

@testset "extendgraph_lg" begin
	input = SimpleDiGraph(3)
	add_edge!(input, 1, 2)
	add_edge!(input, 2, 3)
	add_edge!(input, 3, 2)
	setup = standardsetup_lg(input)
	@test is_consistent_extension(extendgraph_lg(setup), input)
end