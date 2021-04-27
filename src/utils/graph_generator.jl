using LightGraphs

function barbellgraph(n::Int64; filepath::String = "")::SimpleDiGraph
	n >= 6 && n % 2 == 0 || error("Invalid value: n has to be equal and >= 6.")

	g = SimpleDiGraph(n)

	mid = convert(Int, n/2)

	for i = 1:mid
		for j = 1:mid
			i != j || continue
			add_edge!(g, i, j)
			add_edge!(g, j, i)
		end
	end

	for i = mid+1:n
		for j = mid+1:n
			i != j || continue
			add_edge!(g, i, j)
			add_edge!(g, j, i)
		end
	end

	add_edge!(g, 1, n)
	add_edge!(g, n, 1)

	filepath != "" && save2file(g, filepath)

	g
end

function bintreegraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n)

	for i = 1:convert(Int, floor(log2(n)))
		2*i <= n && add_edge!(g, i, 2*i)
		2*i <= n && add_edge!(g, 2*i, i)

		2*i+1 <= n && add_edge!(g, i, 2*i+1)
		2*i+1 <= n && add_edge!(g, 2*i+1, i)
	end

	filepath != "" && save2file(g, filepath)

	g
end

function centipedegraph(n::Int64; filepath::String = "")::SimpleDiGraph
	n % 2 == 0 || error("Invalid value: n has to be equal.")

	g = SimpleDiGraph(n)

	for i = 1:2:convert(Int, n/2)
		add_edge!(g, i, 2*i)
		add_edge!(g, 2*i, i)

		add_edge!(g, i, i+1)
		add_edge!(g, i+1, i)
	end

	filepath != "" && save2file(g, filepath)

	g
end

function completegraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n)

	for u = 1:n
		for v = 1:n
			u != v || continue
			add_edge!(g, u, v)
			add_edge!(g, v, u)
		end
	end

	filepath != "" && save2file(g, filepath)

	g
end


function completebipartitegraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n)

	for i = 1:2:n
		for j = 2:2:n
			add_edge!(g, i, j)
			add_edge!(g, j, i)
		end
	end

	filepath != "" && save2file(g, filepath)

	g
end


function cyclegraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n)

	for i = 1:n-1
		add_edge!(g, i, i+1)
		add_edge!(g, i+1, i)
	end

	n != 1 && add_edge!(g, n, 1)
	n != 1 && add_edge!(g, 1, n)

	filepath != "" && save2file(g, filepath)

	g
end


function friendshipgraph(n::Int64; filepath::String = "")::SimpleDiGraph
	n % 2 == 0 || error("Invalid value: n has to be equal.")

	g = SimpleDiGraph(n+1)

	for i = 2:n+1
		add_edge!(g, 1, i)
		add_edge!(g, i, 1)
	end

	for i = 2:2:n
		add_edge!(g, i, i+1)
		add_edge!(g, i+1, i)
	end

	filepath != "" && save2file(g, filepath)

	g
end


function pathgraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n)

	for i = 1:n-1
		add_edge!(g, i, i+1)
		add_edge!(g, i+1, i)
	end

	filepath != "" && save2file(g, filepath)

	g
end

"""

TODO

stargraph(100000, filepath = "../benchmarks/star/star-n=100000.txt")
"""
function stargraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(n+1)

	for i = 2:n+1
		add_edge!(g, 1, i)
		add_edge!(g, i, 1)
	end

	filepath != "" && save2file(g, filepath)

	g
end

"""
TODO

n is inner n, total 2n

sunletgraph(100000, filepath = "../benchmarks/dummy/sunlet-n=100000.txt")
"""
function sunletgraph(n::Int64; filepath::String = "")::SimpleDiGraph
	g = SimpleDiGraph(2*n)

	add_edge!(g, n, 1)
	add_edge!(g, 1, n)

	for i = 1:n-1
		add_edge!(g, i, i+1)
		add_edge!(g, i+1, i)
	end

	for i = 1:n
		add_edge!(g, i, i+n)
		add_edge!(g, i+n, i)
	end

	filepath != "" && save2file(g, filepath)

	g
end

function save2file(g::SimpleDiGraph, file::String; is_only_undir::Bool = true)
	open(file, "w+") do io
		write(io, graph2str(g, is_only_undir = is_only_undir))
	end
end

"""
TODO
"""
function graph2str(g::SimpleDiGraph; is_only_undir::Bool = false)::String
	nedges = is_only_undir ? convert(Int, ne(g) / 2) : ne(g)
	g_str = "$(nv(g)) $nedges\n\n"

	done = Set{String}()

	for e in edges(g)
		if !is_only_undir || !("$(e.src)-$(e.dst)" in done)
			g_str = string(g_str, "$(e.src) $(e.dst)\n")
			is_only_undir && push!(done, "$(e.dst)-$(e.src)")
		end
	end

	g_str[1:end-1] # Remove last \n
end

function generateall(n::Int64, dir::String)
	barbellgraph(n, filepath = joinpath(dir, "barbell-n=$n.txt"))
	bintreegraph(n, filepath = joinpath(dir, "bintree-n=$n.txt"))
	centipedegraph(n, filepath = joinpath(dir, "centipede-n=$n.txt"))
	completegraph(n, filepath = joinpath(dir, "complete-n=$n.txt"))
	completebipartitegraph(n, filepath = joinpath(dir, "completebipartite-n=$n.txt"))
	cyclegraph(n, filepath = joinpath(dir, "cycle-n=$n.txt"))
	friendshipgraph(n, filepath = joinpath(dir, "friendship-n=$n.txt"))
	pathgraph(n, filepath = joinpath(dir, "path-n=$n.txt"))
	sunletgraph(n, filepath = joinpath(dir, "sunlet-n=$n.txt"))
end