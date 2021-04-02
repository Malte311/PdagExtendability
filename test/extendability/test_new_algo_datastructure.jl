@testset "init" begin
	for n in [2, 20, 200]
		g = init(n)
		testvec = fill(true, 12)
		for i = 1:n
			testvec[1] &= (0 == g.alpha[i])
			testvec[2] &= (0 == g.beta[i])
			testvec[3] &= !isassigned(g.g1.adjlist, i)
			testvec[4] &= !isassigned(g.g2.adjlist, i)
			testvec[5] &= !isassigned(g.g1.ingoing, i)
			testvec[6] &= !isassigned(g.g2.ingoing, i)
			testvec[7] &= !isassigned(g.g1.outgoing, i)
			testvec[8] &= !isassigned(g.g2.outgoing, i)
			testvec[9] &= (0 == g.g1.deltaplus[i])
			testvec[10] &= (0 == g.g2.deltaplus[i])
			testvec[11] &= (0 == g.g1.deltaminus[i])
			testvec[12] &= (0 == g.g2.deltaminus[i])
		end
		@test reduce(&, testvec, init = true)
	end
end

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
	g = init(3)
	insert_edge!(g, 1, 2)
	for i = 1:3 # Edges are inserted into g.g1, thus g.g2 must be unchanged
		@test 0 == g.alpha[i]
		@test 0 == g.beta[i]
		@test !isassigned(g.g2.adjlist, i) || 0 == length(g.g2.adjlist[i])
		@test !isassigned(g.g2.ingoing, i) || 0 == length(g.g2.ingoing[i])
		@test !isassigned(g.g2.outgoing, i) || 0 == length(g.g2.outgoing[i])
		@test 0 == g.g2.deltaplus[i]
		@test 0 == g.g2.deltaminus[i]
	end
	@test 2 in g.g1.adjlist[1] && 1 == length(g.g1.adjlist[1])
	@test 1 in g.g1.adjlist[2] && 1 == length(g.g1.adjlist[2])
	@test !isassigned(g.g1.adjlist, 3) || 0 == length(g.g1.adjlist[3])
	@test 2 in g.g1.ingoing[1] && 1 == length(g.g1.ingoing[1])
	@test 1 in g.g1.ingoing[2] && 1 == length(g.g1.ingoing[2])
	@test !isassigned(g.g1.ingoing, 3) || 0 == length(g.g1.ingoing[3])
	@test 2 in g.g1.outgoing[1] && 1 == length(g.g1.outgoing[1])
	@test 1 in g.g1.outgoing[2] && 1 == length(g.g1.outgoing[2])
	@test !isassigned(g.g1.outgoing, 3) || 0 == length(g.g1.outgoing[3])
	@test 1 == g.g1.deltaplus[1]
	@test 1 == g.g1.deltaplus[2]
	@test 0 == g.g1.deltaplus[3]
	@test 1 == g.g1.deltaminus[1]
	@test 1 == g.g1.deltaminus[2]
	@test 0 == g.g1.deltaminus[3]
end

@testset "remove_arc!" begin
	g = init(3)
	insert_arc!(g, 1, 2)
	remove_arc!(g, 1, 2)
	for i = 1:3
		@test 0 == g.alpha[i]
		@test 0 == g.beta[i]
		@test !isassigned(g.g1.adjlist, i) || 0 == length(g.g1.adjlist[i])
		@test !isassigned(g.g1.ingoing, i) || 0 == length(g.g1.ingoing[i])
		@test !isassigned(g.g1.outgoing, i) || 0 == length(g.g1.outgoing[i])
		@test 0 == g.g1.deltaplus[i]
		@test 0 == g.g1.deltaminus[i]
		@test !isassigned(g.g2.adjlist, i) || 0 == length(g.g2.adjlist[i])
		@test !isassigned(g.g2.ingoing, i) || 0 == length(g.g2.ingoing[i])
		@test !isassigned(g.g2.outgoing, i) || 0 == length(g.g2.outgoing[i])
		@test 0 == g.g1.deltaplus[i]
		@test 0 == g.g1.deltaminus[i]
	end
end

@testset "remove_edge!" begin
	g = init(3)
	insert_edge!(g, 1, 2)
	remove_edge!(g, 1, 2)
	for i = 1:3
		@test 0 == g.alpha[i]
		@test 0 == g.beta[i]
		@test !isassigned(g.g1.adjlist, i) || 0 == length(g.g1.adjlist[i])
		@test !isassigned(g.g1.ingoing, i) || 0 == length(g.g1.ingoing[i])
		@test !isassigned(g.g1.outgoing, i) || 0 == length(g.g1.outgoing[i])
		@test 0 == g.g1.deltaplus[i]
		@test 0 == g.g1.deltaminus[i]
		@test !isassigned(g.g2.adjlist, i) || 0 == length(g.g2.adjlist[i])
		@test !isassigned(g.g2.ingoing, i) || 0 == length(g.g2.ingoing[i])
		@test !isassigned(g.g2.outgoing, i) || 0 == length(g.g2.outgoing[i])
		@test 0 == g.g1.deltaplus[i]
		@test 0 == g.g1.deltaminus[i]
	end
end

@testset "is_ps" begin
	g = init(3)
	@test is_ps(g, 1)
	@test is_ps(g, 2)
	@test is_ps(g, 3)
	insert_arc!(g, 1, 2)
	@test !is_ps(g, 1)
	@test is_ps(g, 2)
	@test is_ps(g, 3)
	insert_edge!(g, 2, 3)
	@test !is_ps(g, 1)
	@test !is_ps(g, 2)
	@test is_ps(g, 3)
end

@testset "list_ps" begin
	g = init(3)
	@test 1 in list_ps(g) && 2 in list_ps(g) && 3 in list_ps(g)
	insert_arc!(g, 1, 2)
	@test !(1 in list_ps(g)) && 2 in list_ps(g) && 3 in list_ps(g)
	insert_edge!(g, 2, 3)
	@test !(1 in list_ps(g)) && !(2 in list_ps(g)) && 3 in list_ps(g)
end

@testset "pop_ps!" begin
	g = init(3)
	insert_arc!(g, 1, 2)
	insert_edge!(g, 2, 3)
	newps = pop_ps!(g, 3)
	@test 2 in newps && 1 == length(newps)
	@test !is_adjacent(g, 2, 3) && !is_adjacent(g, 3, 2)
	newps = pop_ps!(g, 2)
	@test 1 in newps && 1 == length(newps)
	@test !is_adjacent(g, 1, 2) && !is_adjacent(g, 2, 1)
end