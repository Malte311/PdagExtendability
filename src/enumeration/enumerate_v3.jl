using LightGraphs: include
using LightGraphs


@isdefined(DtGraph)         || include("../extendability/implementation_hs/dor_tarsi_algo_datastructure_hs.jl")
@isdefined(hasdircycle)     || include("../extendability/implementation_mpdag/meek_rules.jl")
@isdefined(countvstructs)   || include("../extendability/implementation_mpdag/pdag2mpdag2dag.jl")
@isdefined(buckets)         || include("../extendability/implementation_mpdag/connected_components.jl")
@isdefined(extensions_rec!) || include("enumerate_v1.jl")
@isdefined(extsmeek_rec!)   || include("enumerate_v2.jl")


"""
TODO
"""
function enumerate_v3(g::SimpleDiGraph, usev1::Bool = true)::Vector{DtGraph}
	graph = pdag2mpdag(g)

	# Apply Meek's rules to obtain an MPDAG
	# - if this fails, the input is not extendable.
	if hasdircycle(graph) || countvstructs(graph) != countvstructs(setup_hs(g))
		return []
	end

	# Compute undirected components (buckets) and enumerate
	# extensions for each bucket.
	exts = Vector{Dict}()
	for bucket in buckets(graph)
		mapping = Dict()
		invmapping = Dict()
		for v in bucket
			mapping[mindex += 1] = v
			invmapping[v] = mindex
		end
		sg = subgraph(graph, bucket, invmapping)
		vstr = countvstructs(sg)
		undir = Vector{Tuple{Int64, Int64}}()
		for u in sg.vertices
			for v in sg.undirected[u]
				edge = (u < v ? u : v, u < v ? v : u)
				!(edge in undir) && push!(undir, edge)
			end
		end
		exts_sg = usev1 ? extensions_rec!(sg, vstr, undir) : extsmeek_rec!(sg, vstr, undir)
		!isempty(exts_sg) || return [] # Early cancellation if some bucket is not extendable
		push!(exts, Dict("e" => exts_sg, "m" => mapping))
	end

	return combine_enumerations(graph, exts)
end

"""
TODO
"""
function combine_enumerations(g::DtGraph, exts::Vector{Dict})::Vector{DtGraph}
	result = Vector{DtGraph}()

	if length(exts) == 1
		# TODO
	end

	# TODO: Maybe just return tuples for edges to be directed instead of
	# whole graphs and use them as input for this function
	for i = 1:length(exts)
		gcopy = deepcopy(g)
		for j = i+1:length(exts)
			for ext1 in exts[i]["e"]
				for ext2 in exts[j]["e"]

				end
			end
		end
	end

	result
end

"""
TODO
"""
function direct_buckets()
	
end