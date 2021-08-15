# [Extendability](@id extendability_header)

The main component of this framework is composed of algorithms for
the extension problem. That is, given a partially directed graph,
compute a consistent DAG extension if possible, otherwise return
"not possible".

The same algorithms have been implemented in two variants. The first
variant uses HashSets internally while the second one uses the
LightGraphs library internally. It is noteworthy that the implementation
using HashSets has a better performance in most cases.

## Implementation using HashSets

Basically, there are three different algorithms implemented using HashSets
internally:

- [`pdag2dag_hs`](@ref) - An algorithm with worst-case time complexity $O(|V|^4)$.
- [`altpdag2dag_hs`](@ref) - An alternative implementation for [`pdag2dag_hs`](@ref).
- [`fastpdag2dag_hs`](@ref) - An algorithm with worst-case time complexity $O(|V|^3)$.

All the other functions are called internally in these algorithms.

```@autodocs
Modules = [PdagExtendability]
Pages = [
	"extendability/implementation_hs/depth_first_search_hs.jl",
	"extendability/implementation_hs/dor_tarsi_algo_datastructure_hs.jl",
	"extendability/implementation_hs/dor_tarsi_algo_hs.jl",
	"extendability/implementation_hs/dor_tarsi_alt_algo_hs.jl",
	"extendability/implementation_hs/maximum_cardinality_search_hs.jl",
	"extendability/implementation_hs/new_algo_datastructure_hs.jl",
	"extendability/implementation_hs/new_algo_hs.jl",
	"extendability/implementation_hs/new_algo_optimization_hs.jl",
]
```

## Implementation using the LightGraphs Library

Since the performance of the implementation with LightGraphs is inferior
to the performance of the HashSets implementation, not all algorithms have
been implemented using LightGraphs as well. Available algorithms are:

- [`pdag2dag_lg`](@ref) - An algorithm with worst-case time complexity $O(|V|^4)$.
- [`fastpdag2dag_lg`](@ref) - An algorithm with worst-case time complexity $O(|V|^3)$.

Again, all other functions are called internally in these algorithms.

```@autodocs
Modules = [PdagExtendability]
Pages = [
	"extendability/implementation_lg/dor_tarsi_algo_lg.jl",
	"extendability/implementation_lg/new_algo_datastructure_lg.jl",
	"extendability/implementation_lg/new_algo_lg.jl",
	"extendability/implementation_lg/new_algo_optimization_lg.jl",
]
```

## MPDAGs

```@autodocs
Modules = [PdagExtendability]
Pages = [
	"extendability/implementation_mpdag/connected_components.jl",
	"extendability/implementation_mpdag/meek_rules.jl",
	"extendability/implementation_mpdag/new_algo_mpdag.jl"
]
```

## Debugging

In practice, the algorithm [`pdag2dag_hs`](@ref) may sometimes be faster
than [`fastpdag2dag_hs`](@ref), although it has a worse time complexity.
Thus, one might be interested to find out how many iterations were really
needed to compute the result.

The debug version [`pdag2dag_debug_hs`](@ref)
logs the average number of iterations needed to find a sink in the input
graph. Note that a sink is searched $|V|$-times, i.e., the total number
of iterations can be approximated by multiplying the outputted average
with $|V|$.

[`pdag2dag_debug_lg`](@ref) does the same for the LightGraphs implementation.

```@autodocs
Modules = [PdagExtendability]
Pages = [
	"extendability/implementation_hs/dor_tarsi_debug_hs.jl",
	"extendability/implementation_lg/dor_tarsi_debug_lg.jl"
]
```