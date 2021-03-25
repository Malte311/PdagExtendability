using LightGraphs, GraphPlot, Cairo, Compose

"""
	plotsvg(g::SimpleDiGraph, file::String)

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
function plotsvg(g::SimpleDiGraph, file::String)
	draw(SVG(file), gplot(g, nodelabel=1:nv(g), layout=shell_layout))
end

"""
	plotpng(g::SimpleDiGraph, file::String)

Draw a graph and save it in a `.png` file.

# Examples
```julia-repl
julia> g = SimpleDiGraph(2)
{2, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> plotpng(g, "plot.png")
```
"""
function plotpng(g::SimpleDiGraph, file::String)
	draw(PNG(file), gplot(g, nodelabel=1:nv(g), layout=shell_layout))
end