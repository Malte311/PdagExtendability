@testset "random_pdag" begin
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