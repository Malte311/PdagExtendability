# Overview

A benchmarking framework for algorithms applied in causal analysis.
Mainly, the three following problems are considered.

1. The extendability problem: Given a partially directed graph, compute a consistent DAG extension if possible, otherwise return "not possible".
2. The recognition problem: Given a partially directed graph, decide whether it is an MPDAG (PDAG, CPDAG, CG).
3. The maximum orientation problem: Given a partially directed acyclic graph, compute the graph resulting from applying Meek's rules exhaustively.

!!! note

	Please note that this framework is part of a master's thesis.

## Features

- Fast algorithms for the problems [extendability](@ref extendability_header), [recognition](@ref recognition_header), and [maximum orientation](@ref maximum_orientation_header).
- Automatically run benchmarks and create time measurements in `.csv` format.
- Full Docker support. Julia does not even have to be installed on your system.
- Automatically build and deploy via TravisCI.

## Documentation Outline

```@contents
Depth = 2
```

## Index

```@index
```