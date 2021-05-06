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
	draw(SVG(file), gplot(g, nodelabel=1:nv(g), layout=shell_layout))
end