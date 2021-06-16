@testset "mpdag2dag" begin
	@testset "No changes for DAG inputs 1" begin
		input = SimpleDiGraph(2)
		add_edge!(input, 1, 2)
		mpdag = dtgraph2digraph(pdag2mpdag(input))
		out = mpdag2dag(mpdag)
		@test input == out
	end

	@testset "No changes for DAG inputs 2" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 3)
		mpdag = dtgraph2digraph(pdag2mpdag(input))
		out = mpdag2dag(mpdag)
		@test input == out
	end

	@testset "No changes for DAG inputs 3" begin
		for n in [50, 100, 500]
			input = SimpleDiGraph(n)
			for i = 1:n-1
				add_edge!(input, i, i+1)
			end
			mpdag = dtgraph2digraph(pdag2mpdag(input))
			out = mpdag2dag(mpdag)
			@test input == out
		end
	end

	@testset "Meek Rule R1" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 2, 3)
		add_edge!(input, 3, 2)
		mpdag = dtgraph2digraph(pdag2mpdag(input))
		out = mpdag2dag(mpdag)
		@test nv(out) == 3 && ne(out) == 2 && has_edge(out, 1, 2) &&
			has_edge(out, 2, 3)
	end

	@testset "Meek Rule R2" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		add_edge!(input, 2, 3)
		mpdag = dtgraph2digraph(pdag2mpdag(input))
		out = mpdag2dag(mpdag)
		@test nv(out) == 3 && ne(out) == 3 && has_edge(out, 1, 2) &&
			has_edge(out, 1, 3) && has_edge(out, 2, 3)
	end

	@testset "Meek Rule R3" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 3)
		add_edge!(g, 3, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 4, 3)
		mpdag = dtgraph2digraph(pdag2mpdag(g))
		out = mpdag2dag(mpdag)
		@test is_consistent_extension(out, g)
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
		mpdag = dtgraph2digraph(pdag2mpdag(input))
		out = mpdag2dag(mpdag)
		@test is_consistent_extension(out, input)
	end
end

@testset "subgraph" begin
	@testset "Undirected component with a single directed edge 1" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 1, 3)
		mapping = Dict(i => i for i in [1, 2, 3, 4])
		sg = subgraph(setup_hs(g), Set{Int64}([1, 2, 3, 4]), mapping)
		@test g == dtgraph2digraph(sg)
	end

	@testset "Undirected component with a single directed edge 2" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 2, 4)
		mapping = Dict(i => i for i in [1, 2, 3, 4])
		sg = subgraph(setup_hs(g), Set{Int64}([1, 2, 3, 4]), mapping)
		@test g == dtgraph2digraph(sg)
	end

	@testset "Undirected component with a directed edge outside 1" begin
		g = SimpleDiGraph(5)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 1, 3)
		add_edge!(g, 1, 5)
		m = Dict(i => i for i in [1, 2, 3, 4])
		sg = dtgraph2digraph(subgraph(setup_hs(g), Set{Int64}([1, 2, 3, 4]), m))
		@test nv(sg) == 4 && ne(sg) == 9
	end

	@testset "Undirected component with a directed edge outside 2" begin
		g = SimpleDiGraph(5)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 1, 3)
		add_edge!(g, 5, 1)
		m = Dict(i => i for i in [1, 2, 3, 4])
		sg = dtgraph2digraph(subgraph(setup_hs(g), Set{Int64}([1, 2, 3, 4]), m))
		@test nv(sg) == 4 && ne(sg) == 9
	end
end

@testset "amo" begin
	@testset "Undirected component with a single directed edge 1" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 3, 1)
		(index, order) = amo(setup_hs(g))
		@test index[3] < index[1]
	end

	@testset "Undirected component with a single directed edge 2" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 1, 3)
		(index, order) = amo(setup_hs(g))
		@test index[1] < index[3]
	end

	@testset "Undirected component with a single directed edge 3" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 2, 4)
		(index, order) = amo(setup_hs(g))
		@test index[2] < index[4]
	end

	@testset "Undirected component with a single directed edge 4" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 4, 2)
		(index, order) = amo(setup_hs(g))
		@test index[4] < index[2]
	end

	@testset "Meek Rule R3 (Input)" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 3)
		add_edge!(g, 3, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 4, 3)
		(index, order) = amo(setup_hs(g))
		@test index[2] < index[3] && index[4] < index[3]
	end
end

@testset "isamo" begin
	@testset "Undirected component with a single directed edge 1" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 3, 1)
		dtgraph = setup_hs(g)
		@test isamo(dtgraph, amo(dtgraph))
	end

	@testset "Undirected component with a single directed edge 2" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 1, 3)
		dtgraph = setup_hs(g)
		@test isamo(dtgraph, amo(dtgraph))
	end

	@testset "Undirected component with a single directed edge 3" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 2, 4)
		dtgraph = setup_hs(g)
		@test isamo(dtgraph, amo(dtgraph))
	end

	@testset "Undirected component with a single directed edge 4" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 4, 2)
		dtgraph = setup_hs(g)
		@test isamo(dtgraph, amo(dtgraph))
	end

	@testset "Undirected component (not chordal)" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		dtgraph = setup_hs(g)
		@test !isamo(dtgraph, amo(dtgraph))
	end
end