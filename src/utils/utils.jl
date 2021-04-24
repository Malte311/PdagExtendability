using LightGraphs


function isacyclic(g::SimpleDiGraph)::Bool
	!is_cyclic(g)
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