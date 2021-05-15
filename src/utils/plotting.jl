using LightGraphs, GraphPlot, Compose

"""
	plotsvg(g, file::String)

Draw a graph and save it in a `.svg` file.

# Examples
```julia-repl
julia> g = SimpleDiGraph(2)
{2, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> plotsvg(g, "plot.svg")
false
```
"""
function plotsvg(g, file::String)
	if nv(g) >= 1
		draw(SVG(file), gplot(g, nodelabel=1:nv(g), layout=shell_layout))
	else
		@warn "Cannot plot '$file' because the graph is empty." 
	end
end