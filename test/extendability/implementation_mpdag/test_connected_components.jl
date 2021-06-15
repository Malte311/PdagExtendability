@testset "buckets" begin
	@testset "Circle with four nodes" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 1, 4)
		add_edge!(g, 4, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		bs = buckets(setup_hs(g))
		@test length(bs) == 1 && length(bs[1]) == 4 &&
			1 in bs[1] && 2 in bs[1] && 3 in bs[1] && 4 in bs[1]
	end

	@testset "Circle with four nodes and additional directed edge" begin
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
		bs = buckets(setup_hs(g))
		@test length(bs) == 1 && length(bs[1]) == 4 &&
			1 in bs[1] && 2 in bs[1] && 3 in bs[1] && 4 in bs[1]
	end

	@testset "Separated vertices" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		bs = buckets(setup_hs(g))
		@test length(bs) == 2 && length(bs[1]) == 2 && length(bs[2]) == 2 &&
			1 in bs[1] && 2 in bs[1] && 3 in bs[2] && 4 in bs[2]
	end

	@testset "Separated vertices with a directed edge between" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		add_edge!(g, 1, 3)
		bs = buckets(setup_hs(g))
		@test length(bs) == 2 && length(bs[1]) == 2 && length(bs[2]) == 2 &&
			1 in bs[1] && 2 in bs[1] && 3 in bs[2] && 4 in bs[2]
	end

	@testset "Random PDAG" begin
		g = SimpleDiGraph(4)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		add_edge!(g, 2, 4)
		add_edge!(g, 3, 4)
		add_edge!(g, 4, 3)
		bs = buckets(setup_hs(g))
		@test length(bs) == 1 && length(bs[1]) == 4 &&
			1 in bs[1] && 2 in bs[1] && 3 in bs[1] && 4 in bs[1]
	end
end