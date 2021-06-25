@testset "pdag2mpdag2dag" begin
	
end

@testset "countvstructs" begin
	@testset "Example graph 1" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 3, 2)
		@test countvstructs(setup_hs(input)) == 1
	end

	@testset "Example graph 2" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 3, 2)
		add_edge!(input, 1, 3)
		@test countvstructs(setup_hs(input)) == 0
	end

	@testset "Example graph 3" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 3, 2)
		add_edge!(input, 3, 1)
		@test countvstructs(setup_hs(input)) == 0
	end

	@testset "Example graph 4" begin
		input = SimpleDiGraph(3)
		add_edge!(input, 1, 2)
		add_edge!(input, 3, 2)
		add_edge!(input, 1, 3)
		add_edge!(input, 3, 1)
		@test countvstructs(setup_hs(input)) == 0
	end

	@testset "Example graph 5" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 3, 2)
		add_edge!(input, 4, 2)
		@test countvstructs(setup_hs(input)) == 3
	end

	@testset "Example graph 6" begin
		input = SimpleDiGraph(4)
		add_edge!(input, 1, 2)
		add_edge!(input, 3, 2)
		add_edge!(input, 4, 2)
		add_edge!(input, 3, 4)
		@test countvstructs(setup_hs(input)) == 2
	end

	@testset "Example graph 7" begin
		input = SimpleDiGraph(5)
		add_edge!(input, 1, 2)
		add_edge!(input, 3, 2)
		add_edge!(input, 4, 2)
		add_edge!(input, 3, 4)
		add_edge!(input, 5, 1)
		@test countvstructs(setup_hs(input)) == 2
	end

	@testset "Example graph 8" begin
		input = SimpleDiGraph(6)
		add_edge!(input, 1, 2)
		add_edge!(input, 3, 2)
		add_edge!(input, 4, 2)
		add_edge!(input, 3, 4)
		add_edge!(input, 5, 1)
		add_edge!(input, 6, 1)
		@test countvstructs(setup_hs(input)) == 3
	end
end