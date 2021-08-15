# [Utilities](@id utilities_header)

This section contains the documentation for the utilities.
The functions listed below are mostly used dealing with
graphs and for generating input graph instances (randomly
or specific types of graphs).

## Graph Utilities

These utilities are for dealing with graphs in general
(reading graphs from a file, plotting graphs, converting
graphs, etc.).

```@autodocs
Modules = [PdagExtendability]
Pages = [
	"utils/logparser.jl",
	"utils/plotting.jl",
	"utils/readinput.jl",
	"utils/utils.jl"
]
```

## [Graph Generators](@id utilities_graphgeneration_header)

In order to generate even more input graph instances, there are
different graph generation approaches available.
These graph generation approaches allow for an easy enlargement
of the dataset of input graph instances.

```@autodocs
Modules = [PdagExtendability]
Pages = [
	"utils/dag_generator.jl",
	"utils/graph_generator.jl",
	"utils/pdag_generator.jl",
]
```