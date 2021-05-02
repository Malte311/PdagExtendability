@testset "setup_hs" begin
	@testset "Single directed edge" begin
		for useheuristic in [false, true]
			g = SimpleDiGraph(3)
			add_edge!(g, 1, 2)
			ds = setup_hs(g, useheuristic)
			if useheuristic
				@test ds.numvertices == 3 && length(ds.degrees[1]) == 1 &&
					(3 in ds.degrees[1]) && length(ds.degrees[2]) == 2 &&
					(1 in ds.degrees[2]) && (2 in ds.degrees[2]) &&
					length(ds.degrees[3]) == 0
			else
				@test length(ds.vertices) == 3 && (1 in ds.vertices) &&
					(2 in ds.vertices) && (3 in ds.vertices)
			end
			@test isempty(ds.ingoing[1]) && isempty(ds.ingoing[3]) &&
				length(ds.ingoing[2]) == 1 && (1 in ds.ingoing[2])
			@test isempty(ds.outgoing[2]) && isempty(ds.outgoing[3]) &&
				length(ds.outgoing[1]) == 1 && (2 in ds.outgoing[1])
			@test isempty(ds.undirected[1]) && isempty(ds.undirected[2]) &&
				isempty(ds.undirected[3])
		end
	end

	@testset "Single undirected edge" begin
		for useheuristic in [false, true]
			g = SimpleDiGraph(3)
			add_edge!(g, 1, 2)
			add_edge!(g, 2, 1)
			ds = setup_hs(g, useheuristic)
			if useheuristic
				@test ds.numvertices == 3 && length(ds.degrees[1]) == 1 &&
					(3 in ds.degrees[1]) && length(ds.degrees[2]) == 2 &&
					(1 in ds.degrees[2]) && (2 in ds.degrees[2]) &&
					length(ds.degrees[3]) == 0
			else
				@test length(ds.vertices) == 3 && (1 in ds.vertices) &&
					(2 in ds.vertices) && (3 in ds.vertices)
			end
			@test isempty(ds.ingoing[1]) && isempty(ds.ingoing[2]) &&
				isempty(ds.ingoing[3])
			@test isempty(ds.outgoing[1]) && isempty(ds.outgoing[2]) &&
				isempty(ds.outgoing[3])
			@test isempty(ds.undirected[3]) && length(ds.undirected[1]) == 1 &&
				length(ds.undirected[2]) == 1 && (1 in ds.undirected[2]) &&
				(2 in ds.undirected[1])
		end
	end

	@testset "Directed and undirected edge" begin
		for useheuristic in [false, true]
			g = SimpleDiGraph(3)
			add_edge!(g, 1, 2)
			add_edge!(g, 2, 3)
			add_edge!(g, 3, 2)
			ds = setup_hs(g, useheuristic)
			if useheuristic
				@test ds.numvertices == 3 && length(ds.degrees[1]) == 0 &&
					length(ds.degrees[2]) == 2 && (1 in ds.degrees[2]) &&
					(3 in ds.degrees[2]) && length(ds.degrees[3]) == 1 &&
					(2 in ds.degrees[3])
			else
				@test length(ds.vertices) == 3 && (1 in ds.vertices) &&
					(2 in ds.vertices) && (3 in ds.vertices)
			end
			@test isempty(ds.ingoing[1]) && isempty(ds.ingoing[3]) &&
				length(ds.ingoing[2]) == 1 && (1 in ds.ingoing[2])
			@test isempty(ds.outgoing[2]) && isempty(ds.outgoing[3]) &&
				length(ds.outgoing[1]) == 1 && (2 in ds.outgoing[1])
			@test isempty(ds.undirected[1]) && length(ds.undirected[2]) == 1 &&
				length(ds.undirected[3]) == 1 && (2 in ds.undirected[3]) &&
				(3 in ds.undirected[2])
		end
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

@testset "degree_hs" begin
	@testset "Small graph" begin
		g = SimpleDiGraph(3)
		add_edge!(g, 1, 2)
		add_edge!(g, 2, 3)
		add_edge!(g, 3, 2)
		ds = setup_hs(g)
		@test degree_hs(ds, 1) == 1 && degree_hs(ds, 2) == 2 &&
			degree_hs(ds, 3) == 1
	end

	@testset "Cycle graph" begin
		for n in [10, 20, 50, 100]
			ds = setup_hs(graph2digraph(cyclegraph(n)))
			check = true
			for i = 1:n
				degree_hs(ds, i) == 2 || (check = false)
			end
			@test check
		end
	end

	@testset "Path graph" begin
		for n in [10, 20, 50, 100]
			ds = setup_hs(graph2digraph(pathgraph(n)))
			check = true
			for i = 2:n-1
				degree_hs(ds, i) == 2 || (check = false)
			end
			@test check && degree_hs(ds, 1) == 1 && degree_hs(ds, n) == 1
		end
	end
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
		@test ds.numvertices == 2 && !(2 in ds.vertices)
	end

	@testset "Remove vertex with no edges" begin
		g = SimpleDiGraph(3)
		ds = setup_hs(g)
		insert_edge_hs!(ds, 1, 2, true)
		insert_edge_hs!(ds, 2, 3, true)
		remove_vertex_hs!(ds, 2)
		@test ds.numvertices == 2 && !(2 in ds.vertices)
		@test isempty(ds.ingoing[1]) && isempty(ds.ingoing[3])
		@test isempty(ds.outgoing[1]) && isempty(ds.outgoing[3])
		@test isempty(ds.undirected[1]) && isempty(ds.undirected[3])
	end	
end