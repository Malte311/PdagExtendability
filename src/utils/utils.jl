using LightGraphs

"""

Check whether g1 is a consistent extension of g2.
"""
function is_consistent_extension(g1::SimpleDiGraph, g2::SimpleDiGraph)::Bool
	!is_cyclic(g1) && isdag(g1) && nv(g1) == nv(g2) &&
	vstructures(g1) == vstructures(g2) && skeleton(g1) == skeleton(g2)
end


function isdag(g::SimpleDiGraph)::Bool
	for e in edges(g)
		!has_edge(g, e.dst, e.src) || return false
	end

	true
end


function skeleton(g::SimpleDiGraph)::Vector{Tuple{Int64, Int64}}
	result = Vector{Tuple{Int64, Int64}}()
	for e in edges(g)
		u = e.src
		v = e.dst
		push!(result, u <= v ? u : v, u <= v ? v : u)
	end
	unique!(x -> "$(x[1])-$(x[2])", result)
	sort!(result, by = (a, b) -> a[1] < b[1])
	result
end


function vstructures(g::SimpleDiGraph)::Vector{Tuple{Int64, Int64, Int64}}
	result = Vector{Tuple{Int64, Int64, Int64}}()
	for u in vertices(g)
		for v in vertices(g)
			(u != v && has_edge(g, u, v)) || continue
			for w in vertices(g)
				(u != w && v != w && has_edge(g, w, v)) || continue
				if !has_edge(g, u, w) && !has_edge(g, w, u)
					push!(result, (u <= w ? u : w, v, u <= w ? w : u))
				end
			end
		end
	end
	sort!(result, by = (a, b) -> a[1] < b[1]) # TODO sort by w if u is equal
	result
end

"""
	nanosec2sec(time::Float64)::Float64

Convert a number in nanoseconds to milliseconds.
"""
function nanosec2millisec(time::Float64)::Float64
	# Nano /1000-> Micro /1000-> Milli /1000-> Second
	time / 1000 / 1000
end