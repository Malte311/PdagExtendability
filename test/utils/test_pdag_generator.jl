@testset "random_pdag(g::SimpleDiGraph, p::Float64)" begin
	@testset "PDAG from chordal graph stays extendable 1" begin
		for n in [50, 100, 150]
			for p in [0.2, 0.3, 0.5, 0.7, 0.9]
				pdag = random_pdag(graph2digraph(stargraph(n)), p)
				@test is_consistent_extension(fastpdag2dag_hs(pdag), pdag)
			end
		end
	end

	@testset "PDAG from chordal graph stays extendable 2" begin
		for n in [50, 100, 150]
			for p in [0.2, 0.3, 0.5, 0.7, 0.9]
				pdag = random_pdag(graph2digraph(pathgraph(n)), p)
				@test is_consistent_extension(fastpdag2dag_hs(pdag), pdag)
			end
		end
	end

	@testset "PDAG from chordal graph stays extendable 3" begin
		for n in [50, 100, 150]
			for p in [0.2, 0.3, 0.5, 0.7, 0.9]
				pdag = random_pdag(graph2digraph(completegraph(n)), p)
				@test is_consistent_extension(fastpdag2dag_hs(pdag), pdag)
			end
		end
	end

	@testset "PDAG from chordal graph stays extendable 4" begin
		for n in [50, 100, 150]
			for p in [0.2, 0.3, 0.5, 0.7, 0.9]
				pdag = random_pdag(graph2digraph(doublestargraph(n)), p)
				@test is_consistent_extension(fastpdag2dag_hs(pdag), pdag)
			end
		end
	end

	@testset "PDAG from non-chordal graph is not extendable" begin
		for n in [50, 100, 150]
			for p in [0.2, 0.3, 0.5, 0.7, 0.9]
				pdag = random_pdag(graph2digraph(cyclegraph(n)), p)
				@test fastpdag2dag_hs(pdag) == SimpleDiGraph(0)
			end
		end
	end
end

@testset "random_pdag(g::SimpleDiGraph, m::Int64)" begin
	@testset "Do nothing for m >= ne(g)/2" begin
		for n in [10, 20, 50]
			g = SimpleDiGraph(n)
			add_edge!(g, 1, 2)
			add_edge!(g, 2, 1)
			add_edge!(g, 2, 3)
			add_edge!(g, 3, 2)
			add_edge!(g, 1, 4)
			add_edge!(g, 4, 1)
			add_edge!(g, 2, 4)
			add_edge!(g, 4, 2)
			for m in [4, 5, 6, 7, 8, 10]
				pdag = random_pdag(g, m)
				@test g == pdag
			end
		end
	end

	@testset "Keep a single undirected edge 1" begin
		g = SimpleDiGraph(2)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		pdag = random_pdag(g, 1)
		@test g == pdag
	end

	@testset "Keep a single undirected edge 2" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		pdag = random_pdag(g, 1)
		@test ne(pdag) == 3
	end

	@testset "Keep a single undirected edge 3" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		pdag = random_pdag(g, 1)
		@test ne(pdag) == 4
	end

	@testset "Keep a single undirected edge 4" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 4)
		add_edge!(g, 4, 2)
		pdag = random_pdag(g, 1)
		@test ne(pdag) == 5
	end

	@testset "Keep multiple undirected edges 1" begin
		for n in [50, 100, 150]
			for m in [10, 15, 20, 35]
				g = graph2digraph(stargraph(n))
				pdag = random_pdag(g, m)
				@test ne(pdag) == ne(g) - (convert(Int, floor(ne(g)/2)) - m)
			end
		end
	end
end