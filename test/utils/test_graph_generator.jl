@testset "barbellgraph" begin
	for n in [2, 4, 10, 20, 25, 33, 50, 55, 67, 89, 100, 512]
		g = barbellgraph(n)
		ne1 = convert(Int, floor(n/2)*(floor(n/2)-1)/2)
		ne2 = convert(Int, ceil(n/2)*(ceil(n/2)-1)/2)
		@test nv(g) == n && ne(g) == ne1 + ne2 + 1
	end
end

@testset "bintreegraph" begin
	for n in [1, 2, 3, 4, 5, 7, 8, 16, 32, 33, 64, 89, 128, 256, 512, 1024, 2048]
		g = bintreegraph(n)
		@test nv(g) == n && ne(g) == n-1
	end
end

@testset "centipedegraph" begin
	for n in [2, 4, 8, 12, 14, 16, 32, 50, 64, 80, 128, 256, 512]
		g = centipedegraph(n)
		@test nv(g) == n && ne(g) == n-1
	end
end

@testset "cliquegraph" begin
	for n in [2, 4, 8, 12, 14, 16, 32, 50, 64, 80, 128, 256, 512]
		g = cliquegraph(n)
		@test nv(g) == n && ne(g) == n/2*(n/2-1)/2+n/2
	end
end

@testset "completegraph" begin
	for n in [2, 4, 10, 20, 25, 33, 50, 55, 67, 89, 100, 512]
		g = completegraph(n)
		@test nv(g) == n && ne(g) == n*(n-1)/2
	end
end

@testset "cyclegraph" begin
	for n in [4, 10, 20, 25, 33, 50, 55, 67, 89, 100, 512]
		g = cyclegraph(n)
		@test is_cyclic(g)
		@test nv(g) == n && ne(g) == n
	end
end

@testset "doublestargraph" begin
	for n in [4, 10, 20, 25, 33, 50, 55, 67, 89, 100, 512]
		g = doublestargraph(n)
		@test nv(g) == n && ne(g) == n-1
	end
end

@testset "extbarbellgraph" begin
	for n in [6, 11, 21, 25, 33, 51, 55, 67, 89, 101, 511]
		n1 = convert(Int, floor(n/3))
		n2 = convert(Int, floor(n/3))
		n3 = n-n1-n2
		g = extbarbellgraph(n)
		@test nv(g) == n && ne(g) == binomial(n1, 2)+binomial(n2, 2)+n3+1
	end
end

@testset "friendshipgraph" begin
	for n in [5, 11, 21, 25, 33, 51, 55, 67, 89, 101, 511]
		g = friendshipgraph(n)
		@test nv(g) == n && ne(g) == 3*(n-1)/2
	end
end

@testset "pathgraph" begin
	for n in [5, 11, 21, 25, 33, 51, 55, 67, 89, 101, 511]
		g = pathgraph(n)
		@test nv(g) == n && ne(g) == n-1
	end
end

@testset "stargraph" begin
	for n in [5, 11, 21, 25, 33, 51, 55, 67, 89, 101, 511]
		g = stargraph(n)
		@test nv(g) == n && ne(g) == n-1
		check = true
		for i = 2:n
			has_edge(g, 1, i) || (check = false)
		end
		@test check
	end
end