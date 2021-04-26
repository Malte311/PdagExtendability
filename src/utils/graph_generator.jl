using LightGraphs

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

	if filepath != ""
		open(filepath, "w+") do io
			write(io, graph2str(g, is_only_undir = true))
		end
	end

	g
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