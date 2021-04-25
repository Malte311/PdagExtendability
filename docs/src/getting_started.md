# Getting Started

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