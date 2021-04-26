# [Extendability](@id extendability_header)

```@eval
using LightGraphs, PdagExtendability
g = SimpleDiGraph(3)
add_edge!(g, 1, 2)
add_edge!(g, 2, 3)
add_edge!(g, 3, 2)
plotsvg(g, "plot.svg")

nothing
```

![](plot.svg)

## Implementation using HashSets

```@autodocs
Modules = [PdagExtendability]
Pages = [
	"extendability/implementation_hs/dor_tarsi_algo_datastructure_hs.jl",
	"extendability/implementation_hs/dor_tarsi_algo_hs.jl",
	"extendability/implementation_hs/new_algo_datastructure_hs.jl",
	"extendability/implementation_hs/new_algo_hs.jl",
	"extendability/implementation_hs/new_algo_optimization_hs.jl",
]
```

## Implementation using the LightGraphs Library

```@autodocs
Modules = [PdagExtendability]
Pages = [
	"extendability/implementation_lg/dor_tarsi_algo_lg.jl",
	"extendability/implementation_lg/new_algo_datastructure_lg.jl",
	"extendability/implementation_lg/new_algo_lg.jl",
	"extendability/implementation_lg/new_algo_optimization_lg.jl",
]
```

## Debugging

```@autodocs
Modules = [PdagExtendability]
Pages = [
	"extendability/implementation_hs/dor_tarsi_debug_hs.jl",
	"extendability/implementation_lg/dor_tarsi_debug_lg.jl"
]
```