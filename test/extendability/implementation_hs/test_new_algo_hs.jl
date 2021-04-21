@testset "fastpdag2dag_hs" begin
	@testset "No changes for DAG inputs" begin
		for optimize in [true, false]
			input = SimpleDiGraph(2)
			add_edge!(input, 1, 2)
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 2 && ne(out) == 1 && has_edge(out, 1, 2)

			input = SimpleDiGraph(3)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 3 && ne(out) == 2 && has_edge(out, 1, 2) &&
				has_edge(out, 2, 3)

			for n in [50, 100, 500]
				input = SimpleDiGraph(n)
				for i = 1:n-1
					add_edge!(input, i, i+1)
				end
				output = fastpdag2dag_hs(input, optimize)
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
			out = fastpdag2dag_hs(input, optimize)
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
			out = fastpdag2dag_hs(input, optimize)
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
			
			out = fastpdag2dag_hs(g, optimize)
			@test nv(out) == 4 && ne(out) == 5 && has_edge(out, 1, 2) &&
				has_edge(out, 1, 3) && has_edge(out, 2, 3) && has_edge(out, 4, 1) &&
				has_edge(out, 4, 3)
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
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 4 && ne(out) == 5 && has_edge(out, 1, 2) &&
				has_edge(out, 3, 1) && has_edge(out, 3, 2) && has_edge(out, 4, 1) &&
				has_edge(out, 4, 3)
		end
	end

	@testset "More PDAGs with possible extensions" begin
		for optimize in [true, false]
			input = SimpleDiGraph(4)
			add_edge!(input, 1, 2)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			add_edge!(input, 3, 4)
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 4 && ne(out) == 3 && has_edge(out, 1, 2) &&
				has_edge(out, 2, 3) && has_edge(out, 3, 4)

			for n in [20, 50, 100]
				input = SimpleDiGraph(n)
				for i = 1:n-1
					add_edge!(input, i, i+1)
					i % 2 == 0 && add_edge!(input, i+1, i)
				end
				out = fastpdag2dag_hs(input, optimize)
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
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 5 && ne(out) == 5 && has_edge(out, 1, 4) &&
				has_edge(out, 4, 5) && has_edge(out, 5, 2) &&
				has_edge(out, 5, 3) && has_edge(out, 2, 3)

			input = SimpleDiGraph(5)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 1)
			add_edge!(input, 5, 4)
			add_edge!(input, 5, 2)
			add_edge!(input, 5, 3)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 5 && ne(out) == 5 && has_edge(out, 4, 1) &&
				has_edge(out, 5, 4) && has_edge(out, 5, 2) &&
				has_edge(out, 5, 3) && has_edge(out, 2, 3)

			input = SimpleDiGraph(5)
			add_edge!(input, 1, 4)
			add_edge!(input, 4, 5)
			add_edge!(input, 5, 4)
			add_edge!(input, 5, 2)
			add_edge!(input, 5, 3)
			add_edge!(input, 2, 3)
			add_edge!(input, 3, 2)
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 5 && ne(out) == 5 && has_edge(out, 1, 4) &&
				has_edge(out, 4, 5) && has_edge(out, 5, 2) &&
				has_edge(out, 5, 3) && has_edge(out, 2, 3)

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
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 5 && ne(out) == 5 && has_edge(out, 1, 4) &&
				has_edge(out, 4, 5) && has_edge(out, 5, 2) &&
				has_edge(out, 5, 3) && has_edge(out, 2, 3)
		end
	end

	@testset "Empty graph if no consistent extension is possible" begin
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
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 0 && ne(out) == 0

			input = SimpleDiGraph(4)
			add_edge!(input, 1, 4)
			add_edge!(input, 2, 1)
			add_edge!(input, 2, 4)
			add_edge!(input, 4, 2)
			add_edge!(input, 3, 1)
			add_edge!(input, 3, 4)
			add_edge!(input, 4, 3)
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 0 && ne(out) == 0

			for n in [50, 100, 500]
				input = SimpleDiGraph(n)
				for i = 1:n-1
					add_edge!(input, i, i+1)
					add_edge!(input, i+1, i)
				end
				add_edge!(input, 1, n)
				add_edge!(input, n, 1)
				output = fastpdag2dag_hs(input, optimize)
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
			out = fastpdag2dag_hs(input, optimize)
			@test nv(out) == 0 && ne(out) == 0
		end
	end
end

@testset "standardsetup_hs" begin
	@testset "All values are set correctly" begin
		ingraph = SimpleDiGraph(3)
		add_edge!(ingraph, 1, 2)
		add_edge!(ingraph, 2, 3)
		add_edge!(ingraph, 3, 2)
		g = standardsetup_hs(ingraph)
		for i = 1:3
			@test 0 == g.alpha[i]
			@test 0 == g.beta[i]
		end
		@test (1 in g.g2.adjlist[2]) && 1 == length(g.g2.adjlist[2])
		@test (2 in g.g2.adjlist[1]) && 1 == length(g.g2.adjlist[1])
		@test isempty(g.g2.adjlist[3])
		@test isempty(g.g1.adjlist[1])
		@test (3 in g.g1.adjlist[2]) && 1 == length(g.g1.adjlist[2])
		@test (2 in g.g1.adjlist[3]) && 1 == length(g.g1.adjlist[3])
		@test (1 in g.g2.ingoing[2]) && 1 == length(g.g2.ingoing[2])
		@test isempty(g.g2.ingoing[1])
		@test isempty(g.g2.ingoing[3])
		@test isempty(g.g1.ingoing[1])
		@test (3 in g.g1.ingoing[2]) && 1 == length(g.g1.ingoing[2])
		@test (2 in g.g1.ingoing[3]) && 1 == length(g.g1.ingoing[3])
		@test (2 in g.g2.outgoing[1]) && 1 == length(g.g2.outgoing[1])
		@test isempty(g.g2.outgoing[2])
		@test isempty(g.g2.outgoing[3])
		@test isempty(g.g1.outgoing[1])
		@test (3 in g.g1.outgoing[2]) && 1 == length(g.g1.outgoing[2])
		@test (2 in g.g1.outgoing[3]) && 1 == length(g.g1.outgoing[3])
		@test 0 == g.g1.deltaplus[1]
		@test 1 == g.g1.deltaplus[2]
		@test 1 == g.g1.deltaplus[3]
		@test 1 == g.g2.deltaplus[1]
		@test 0 == g.g2.deltaplus[2]
		@test 0 == g.g2.deltaplus[3]
		@test 0 == g.g1.deltaminus[1]
		@test 1 == g.g1.deltaminus[2]
		@test 1 == g.g1.deltaminus[3]
		@test 0 == g.g2.deltaminus[1]
		@test 1 == g.g2.deltaminus[2]
		@test 0 == g.g2.deltaminus[3]
	end

	@testset "Alpha and Beta initialized correctly" begin
		ingraph = SimpleDiGraph(4) # Graph from Meek Rule 3
		add_edge!(ingraph, 1, 2)
		add_edge!(ingraph, 2, 1)
		add_edge!(ingraph, 1, 3)
		add_edge!(ingraph, 3, 1)
		add_edge!(ingraph, 1, 4)
		add_edge!(ingraph, 4, 1)
		add_edge!(ingraph, 2, 3)
		add_edge!(ingraph, 4, 3)
		g = standardsetup_hs(ingraph)
		@test g.alpha == [2, 0, 0, 0]
		@test g.beta == [0, 0, 2, 0]
	end
end

@testset "optimizedsetup_hs" begin
	@testset "All values are set correctly" begin
		ingraph = SimpleDiGraph(3)
		add_edge!(ingraph, 1, 2)
		add_edge!(ingraph, 2, 3)
		add_edge!(ingraph, 3, 2)
		g = optimizedsetup_hs(ingraph)
		for i = 1:3
			@test 0 == g.alpha[i]
			@test 0 == g.beta[i]
		end
		@test (1 in g.g2.adjlist[2]) && 1 == length(g.g2.adjlist[2])
		@test (2 in g.g2.adjlist[1]) && 1 == length(g.g2.adjlist[1])
		@test isempty(g.g2.adjlist[3])
		@test isempty(g.g1.adjlist[1])
		@test (3 in g.g1.adjlist[2]) && 1 == length(g.g1.adjlist[2])
		@test (2 in g.g1.adjlist[3]) && 1 == length(g.g1.adjlist[3])
		@test (1 in g.g2.ingoing[2]) && 1 == length(g.g2.ingoing[2])
		@test isempty(g.g2.ingoing[1])
		@test isempty(g.g2.ingoing[3])
		@test isempty(g.g1.ingoing[1])
		@test (3 in g.g1.ingoing[2]) && 1 == length(g.g1.ingoing[2])
		@test (2 in g.g1.ingoing[3]) && 1 == length(g.g1.ingoing[3])
		@test (2 in g.g2.outgoing[1]) && 1 == length(g.g2.outgoing[1])
		@test isempty(g.g2.outgoing[2])
		@test isempty(g.g2.outgoing[3])
		@test isempty(g.g1.outgoing[1])
		@test (3 in g.g1.outgoing[2]) && 1 == length(g.g1.outgoing[2])
		@test (2 in g.g1.outgoing[3]) && 1 == length(g.g1.outgoing[3])
		@test 0 == g.g1.deltaplus[1]
		@test 1 == g.g1.deltaplus[2]
		@test 1 == g.g1.deltaplus[3]
		@test 1 == g.g2.deltaplus[1]
		@test 0 == g.g2.deltaplus[2]
		@test 0 == g.g2.deltaplus[3]
		@test 0 == g.g1.deltaminus[1]
		@test 1 == g.g1.deltaminus[2]
		@test 1 == g.g1.deltaminus[3]
		@test 0 == g.g2.deltaminus[1]
		@test 1 == g.g2.deltaminus[2]
		@test 0 == g.g2.deltaminus[3]
	end

	@testset "Alpha and Beta initialized correctly" begin
		ingraph = SimpleDiGraph(4) # Graph from Meek Rule 3
		add_edge!(ingraph, 1, 2)
		add_edge!(ingraph, 2, 1)
		add_edge!(ingraph, 1, 3)
		add_edge!(ingraph, 3, 1)
		add_edge!(ingraph, 1, 4)
		add_edge!(ingraph, 4, 1)
		add_edge!(ingraph, 2, 3)
		add_edge!(ingraph, 4, 3)
		g = optimizedsetup_hs(ingraph)
		@test g.alpha == [2, 0, 0, 0]
		@test g.beta == [0, 0, 2, 0]
	end
end