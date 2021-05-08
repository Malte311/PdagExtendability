using LightGraphs

"""
	is_consistent_extension(g1::SimpleDiGraph, g2::SimpleDiGraph)::Bool

Check whether g1 is a consistent extension of g2.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> add_edge!(g, 3, 2)
true
julia> e = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(e, 1, 2)
true
julia> add_edge!(e, 2, 3)
true
julia> is_consistent_extension(e, g)
true
```
"""
function is_consistent_extension(g1::SimpleDiGraph, g2::SimpleDiGraph)::Bool
	isdag(g1) && nv(g1) == nv(g2) &&
	vstructures(g1) == vstructures(g2) && skeleton(g1) == skeleton(g2)
end

"""
	isdag(g::SimpleDiGraph)::Bool

Check whether g is a directed acyclic graph.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 2, 3)
true
julia> isdag(g)
true
julia> add_edge!(g, 3, 1)
true
julia> isdag(g)
false
```
"""
function isdag(g::SimpleDiGraph)::Bool
	for e in edges(g)
		!has_edge(g, e.dst, e.src) || return false
	end

	!is_cyclic(g)
end

"""
	skeleton(g::SimpleDiGraph)::Vector{Tuple{Int64, Int64}}

Compute the skeleton of g. Edges are represented as tuples (u, v)
where the smaller number is always first.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 3, 2)
true
julia> skeleton(g)
2-element Vector{Tuple{Int64, Int64}}:
 (1, 2)
 (2, 3)
```
"""
function skeleton(g::SimpleDiGraph)::Vector{Tuple{Int64, Int64}}
	result = Vector{Tuple{Int64, Int64}}()

	for e in edges(g)
		u = e.src
		v = e.dst
		push!(result, (u <= v ? u : v, u <= v ? v : u))
	end

	unique!(result)
	sort!(result)

	result
end

"""
	vstructures(g::SimpleDiGraph)::Vector{Tuple{Int64, Int64, Int64}}

Compute all v-structures of graph g. The v-structures of form u -> v <- w
are represented as tuples (x, v, y) where x is always the minimum
of u and w and y is the maximum of u and w.
The list of v-structures which is returned is sorted first by x, then by v
and last by y.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> add_edge!(g, 3, 2)
true
julia> vstructures(g)
1-element Vector{Tuple{Int64, Int64, Int64}}:
 (1, 2, 3)
```
"""
function vstructures(g::SimpleDiGraph)::Vector{Tuple{Int64, Int64, Int64}}
	result = Vector{Tuple{Int64, Int64, Int64}}()

	for u in vertices(g)
		for v in vertices(g)
			(u != v && has_edge(g, u, v) && !has_edge(g, v, u)) || continue
			for w in vertices(g)
				(u != w && v != w && has_edge(g, w, v) && !has_edge(g, v, w)) || continue
				if !has_edge(g, u, w) && !has_edge(g, w, u)
					push!(result, (u <= w ? u : w, v, u <= w ? w : u))
				end
			end
		end
	end

	unique!(result)
	sort!(result)

	result
end

"""
	graph2digraph(g::SimpleGraph)::SimpleDiGraph

Convert an undirected graph (SimpleGraph) into a directed
graph (SimpleDiGraph).

# Examples
```julia-repl
julia> g = SimpleGraph(3)
{3, 0} undirected simple Int64 graph
julia> add_edge!(g, 1, 2)
true
julia> collect(edges(graph2digraph(g)))
2-element Vector{LightGraphs.SimpleGraphs.SimpleEdge{Int64}}:
 Edge 1 => 2
 Edge 2 => 1
```
"""
function graph2digraph(g::SimpleGraph)::SimpleDiGraph
	result = SimpleDiGraph(nv(g))
	for e in edges(g)
		add_edge!(result, e.src, e.dst)
		add_edge!(result, e.dst, e.src)
	end
	result
end

"""
	save2file(g, file::String; is_only_undir::Bool = true)

Save a graph g to a given file. Set `is_only_undir` to `false` if the graph
contains directed edges.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> save2file(g, "../benchmarks/dummy/graph.txt")
```
"""
function save2file(g, file::String; is_only_undir::Bool = true)
	open(file, "w+") do io
		write(io, graph2str(g, is_only_undir = is_only_undir))
	end
end

"""
	graph2str(g; is_only_undir::Bool = false)::String

Convert a graph `g` to the corresponding string representation. Set
`is_only_undir` to `false` if the graph contains directed edges.

# Examples
```julia-repl
julia> g = SimpleDiGraph(3)
{3, 0} directed simple Int64 graph
julia> graph2str(g)
"3 0\n"
```
"""
function graph2str(g; is_only_undir::Bool = false)::String
	typeof(g) == SimpleGraph{Int64} && (is_only_undir = false)

	nedges = is_only_undir ? convert(Int, floor(ne(g)/2)) : ne(g)
	g_str = "$(nv(g)) $nedges\n\n"

	done = Set{String}()

	for e in edges(g)
		if !is_only_undir || !("$(e.src)-$(e.dst)" in done)
			g_str = string(g_str, "$(e.src) $(e.dst)\n")
			is_only_undir && push!(done, "$(e.dst)-$(e.src)")
		end
	end

	g_str
end

"""
	nanosec2sec(time::Float64)::Float64

Convert a number in nanoseconds to milliseconds.

# Examples
```julia-repl
julia> nanosec2millisec(1000000.0)
1.0
```
"""
function nanosec2millisec(time::Float64)::Float64
	# Nano /1000-> Micro /1000-> Milli /1000-> Second
	time / 1000 / 1000
end