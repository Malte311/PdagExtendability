@testset "enumerate_v2" begin
	@testset "Returns an empty list if there are no extensions 1" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 1)
		@test isempty(enumerate_v2(g))
	end

	@testset "Returns an empty list if there are no extensions 2" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 2, 4)
		add_edge!(g, 4, 2)
		@test isempty(enumerate_v2(g))
	end

	@testset "Returns an empty list if there are no extensions 3" begin
		g = SimpleDiGraph(5)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 5)
		add_edge!(g, 5, 4)
		add_edge!(g, 4, 1)
		@test isempty(enumerate_v2(g))
	end

	@testset "Returns an empty list if there are no extensions 4" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 3)
		add_edge!(g, 3, 1)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 2, 4)
		add_edge!(g, 4, 2)
		@test isempty(enumerate_v2(g))
	end

	@testset "Returns the graph itself if it is already a DAG 1" begin
		g = SimpleDiGraph(2)
		add_edge!(g, 1, 2)
		exts = enumerate_v2(g)
		@test length(exts) == 1 &&
			is_consistent_extension(dtgraph2digraph(exts[1]), g)
	end

	@testset "Returns the graph itself if it is already a DAG 2" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		exts = enumerate_v2(g)
		@test length(exts) == 1 &&
			is_consistent_extension(dtgraph2digraph(exts[1]), g)
	end

	@testset "Returns the graph itself if it is already a DAG 3" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 1, 3)
		add_edge!(g, 2, 3)
		exts = enumerate_v2(g)
		@test length(exts) == 1 &&
			is_consistent_extension(dtgraph2digraph(exts[1]), g)
	end

	@testset "Lists all extensions 1" begin
		# Meek Rule 1
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		exts = enumerate_v2(g)
		@test length(exts) == 1 &&
			is_consistent_extension(dtgraph2digraph(exts[1]), g)
	end

	@testset "Lists all extensions 2" begin
		# Meek Rule 2
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 1, 3)
		add_edge!(g, 3, 1)
		add_edge!(g, 2, 3)
		exts = enumerate_v2(g)
		@test length(exts) == 1 &&
			is_consistent_extension(dtgraph2digraph(exts[1]), g)
	end

	@testset "Lists all extensions 3" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 3)
		add_edge!(g, 3, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		exts = enumerate_v2(g)
		@test length(exts) == 6
		for ext in exts
			@test is_consistent_extension(dtgraph2digraph(ext), g)
		end
	end

	@testset "Lists all extensions 4" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 3)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		exts = enumerate_v2(g)
		@test length(exts) == 5
		for ext in exts
			@test is_consistent_extension(dtgraph2digraph(ext), g)
		end
	end
end

@testset "extsmeek_rec!" begin
	@testset "Lists all extensions for MPDAGs" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 3)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		dt = setup_hs(g)
		exts = extsmeek_rec!(dt, countvstructs(dt), [(1, 2), (1, 4), (2, 3), (3, 4)])
		@test length(exts) == 5
		for ext in exts
			@test is_consistent_extension(dtgraph2digraph(ext), g)
		end
	end
end