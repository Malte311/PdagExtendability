@testset "setup_hs" begin
	@testset "Single directed edge" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		ds = setup_hs(g)
		@test length(ds.vertices) == 3 && (1 in ds.vertices) &&
			(2 in ds.vertices) && (3 in ds.vertices)
		@test isempty(ds.ingoing[1]) && isempty(ds.ingoing[3]) &&
			length(ds.ingoing[2]) == 1 && (1 in ds.ingoing[2])
		@test isempty(ds.outgoing[2]) && isempty(ds.outgoing[3]) &&
			length(ds.outgoing[1]) == 1 && (2 in ds.outgoing[1])
		@test isempty(ds.undirected[1]) && isempty(ds.undirected[2]) &&
			isempty(ds.undirected[3])
	end

	@testset "Single undirected edge" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 1)
		ds = setup_hs(g)
		@test length(ds.vertices) == 3 && (1 in ds.vertices) &&
			(2 in ds.vertices) && (3 in ds.vertices)
		@test isempty(ds.ingoing[1]) && isempty(ds.ingoing[2]) &&
			isempty(ds.ingoing[3])
		@test isempty(ds.outgoing[1]) && isempty(ds.outgoing[2]) &&
			isempty(ds.outgoing[3])
		@test isempty(ds.undirected[3]) && length(ds.undirected[1]) == 1 &&
			length(ds.undirected[2]) == 1 && (1 in ds.undirected[2]) &&
			(2 in ds.undirected[1])
	end

	@testset "Directed and undirected edge" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		ds = setup_hs(g)
		@test length(ds.vertices) == 3 && (1 in ds.vertices) &&
			(2 in ds.vertices) && (3 in ds.vertices)
		@test isempty(ds.ingoing[1]) && isempty(ds.ingoing[3]) &&
			length(ds.ingoing[2]) == 1 && (1 in ds.ingoing[2])
		@test isempty(ds.outgoing[2]) && isempty(ds.outgoing[3]) &&
			length(ds.outgoing[1]) == 1 && (2 in ds.outgoing[1])
		@test isempty(ds.undirected[1]) && length(ds.undirected[2]) == 1 &&
			length(ds.undirected[3]) == 1 && (2 in ds.undirected[3]) &&
			(3 in ds.undirected[2])
	end
end

@testset "isadjacent_hs" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	ds = setup_hs(g)
	@test isadjacent_hs(ds, 1, 2)
	@test isadjacent_hs(ds, 2, 1)
	@test !isadjacent_hs(ds, 2, 3)
	@test !isadjacent_hs(ds, 3, 2)
end

@testset "insert_edge_hs!" begin
	@testset "Insert directed edge" begin
		g = SimpleDiGraph(3)
		ds = setup_hs(g)
		insert_edge_hs!(ds, 1, 2, true)
		@test isempty(ds.ingoing[1]) && isempty(ds.ingoing[3]) &&
			length(ds.ingoing[2]) == 1 && (1 in ds.ingoing[2])
		@test isempty(ds.outgoing[2]) && isempty(ds.outgoing[3]) &&
			length(ds.outgoing[1]) == 1 && (2 in ds.outgoing[1])
		@test isempty(ds.undirected[1]) && isempty(ds.undirected[2]) &&
			isempty(ds.undirected[3])
	end

	@testset "Insert undirected edge" begin
		g = SimpleDiGraph(3)
		ds = setup_hs(g)
		insert_edge_hs!(ds, 1, 2, false)
		@test isempty(ds.ingoing[1]) && isempty(ds.ingoing[2]) &&
			isempty(ds.ingoing[3])
		@test isempty(ds.outgoing[1]) && isempty(ds.outgoing[2]) &&
			isempty(ds.outgoing[3])
		@test isempty(ds.undirected[3]) && length(ds.undirected[1]) == 1 &&
			length(ds.undirected[2]) == 1 && (1 in ds.undirected[2]) &&
			(2 in ds.undirected[1])
	end
end

@testset "remove_vertex_hs!" begin
	@testset "Remove vertex with no edges" begin
		g = SimpleDiGraph(3)
		ds = setup_hs(g)
		remove_vertex_hs!(ds, 2)
		@test length(ds.vertices) == 2 && !(2 in ds.vertices)
	end

	@testset "Remove vertex with no edges" begin
		g = SimpleDiGraph(3)
		ds = setup_hs(g)
		insert_edge_hs!(ds, 1, 2, true)
		insert_edge_hs!(ds, 2, 3, true)
		remove_vertex_hs!(ds, 2)
		@test length(ds.vertices) == 2 && !(2 in ds.vertices)
		@test isempty(ds.ingoing[1]) && isempty(ds.ingoing[3])
		@test isempty(ds.outgoing[1]) && isempty(ds.outgoing[3])
		@test isempty(ds.undirected[1]) && isempty(ds.undirected[3])
	end	
end