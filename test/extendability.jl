

@testset "sink" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	add_edge!(g, 2, 3)
	add_edge!(g, 3, 2)
	@test PdagExtendability.sink(g) == 3
end