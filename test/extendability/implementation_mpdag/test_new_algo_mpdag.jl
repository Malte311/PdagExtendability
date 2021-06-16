@testset "mpdag2dag" begin
	# TODO
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
		sg = subgraph(setup_hs(g), Set{Int64}([1, 2, 3, 4]))
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
		sg = subgraph(setup_hs(g), Set{Int64}([1, 2, 3, 4]))
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
		sg = dtgraph2digraph(subgraph(setup_hs(g), Set{Int64}([1, 2, 3, 4])))
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
		sg = dtgraph2digraph(subgraph(setup_hs(g), Set{Int64}([1, 2, 3, 4])))
		@test nv(sg) == 4 && ne(sg) == 9
	end
end

@testset "amo" begin
	# TODO
end

@testset "isamo" begin
	# TODO
end