@testset "is_adjacent" begin
	g = init(3)
	insert_arc!(g, 1, 2)
	insert_edge!(g, 2, 3)
	@test is_adjacent(g, 1, 2)
	@test is_adjacent(g, 2, 1)
	@test is_adjacent(g, 2, 3)
	@test is_adjacent(g, 3, 2)
	@test !is_adjacent(g, 1, 3)
	@test !is_adjacent(g, 3, 1)
	
	for n in [50, 100, 500]
		g = init(n)
		insert_arc!(g, floor(Int, n/2), floor(Int, n/2+1))
		insert_edge!(g, 1, n)
		@test is_adjacent(g, floor(Int, n/2), floor(Int, n/2+1))
		@test is_adjacent(g, floor(Int, n/2+1), floor(Int, n/2))
		@test is_adjacent(g, 1, n)
		@test is_adjacent(g, n, 1)
		isok = true
		for i = 2:n-2
			(i == floor(Int, n/2) || i == floor(Int, n/2+1)) && continue
			isok &= !is_adjacent(g, i, i+1)
		end
		@test isok
	end
end

@testset "insert_arc!" begin
	g = init(3)
	insert_arc!(g, 1, 2)
	for i = 1:3 # Arcs are inserted into g.g2, thus g.g1 must be unchanged
		@test 0 == g.alpha[i]
		@test 0 == g.beta[i]
		@test !isassigned(g.g1.adjlist, i) || 0 == length(g.g1.adjlist[i])
		@test !isassigned(g.g1.ingoing, i) || 0 == length(g.g1.ingoing[i])
		@test !isassigned(g.g1.outgoing, i) || 0 == length(g.g1.outgoing[i])
		@test 0 == g.g1.deltaplus[i]
		@test 0 == g.g1.deltaminus[i]
	end
	@test 2 in g.g2.adjlist[1] && 1 == length(g.g2.adjlist[1])
	@test 1 in g.g2.adjlist[2] && 1 == length(g.g2.adjlist[2])
	@test !isassigned(g.g2.adjlist, 3) || 0 == length(g.g2.adjlist[3])
	@test !isassigned(g.g2.ingoing, 1) || 0 == length(g.g2.ingoing[1])
	@test 1 in g.g2.ingoing[2] && 1 == length(g.g2.ingoing[2])
	@test !isassigned(g.g2.ingoing, 3) || 0 == length(g.g2.ingoing[3])
	@test 2 in g.g2.outgoing[1] && 1 == length(g.g2.outgoing[1])
	@test !isassigned(g.g2.outgoing, 2) || 0 == length(g.g2.outgoing[2])
	@test !isassigned(g.g2.outgoing, 3) || 0 == length(g.g2.outgoing[3])
	@test 1 == g.g2.deltaplus[1]
	@test 0 == g.g2.deltaplus[2]
	@test 0 == g.g2.deltaplus[3]
	@test 0 == g.g2.deltaminus[1]
	@test 1 == g.g2.deltaminus[2]
	@test 0 == g.g2.deltaminus[3]
end

@testset "insert_edge!" begin
	
end

@testset "remove_arc!" begin
	
end

@testset "remove_edge!" begin
	
end

@testset "update_alphabeta!" begin
	
end

@testset "is_ps" begin
	
end

@testset "list_ps" begin
	
end

@testset "pop_ps!" begin
	
end

@testset "print_graph" begin
	
end