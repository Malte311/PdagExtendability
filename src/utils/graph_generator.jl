using LightGraphs

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

	g_str[1:end-1]
end