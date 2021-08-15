# Overview

A benchmarking framework for the extendability of (causal) graphs.
The benchmarking framework contains efficient algorithms for extending
(causal) graphs and more than 1000 exemplary input graph instances.

More precisely, algorithms solving the following two problems are provided:
1. Given any partially directed graph $G$, compute a consistent DAG extension for $G$ if $G$ admits such an extension, otherwise return a negative answer (Extension Problem).
2. Given any partially directed graph $G$, compute the set of **all** consistent DAG extensions for $G$ (Enumeration Problem).

We denote that the number of vertices in the input graph as $|V|$ and the
number of edges in the input graph as $|E|$. The maximum degree in the
input graph is denoted as $\Delta$.

!!! note

	Please note that this framework is part of a master's thesis and
	thus is not professionally maintained.

## Features

- Fast algorithms for the [extension problem](@ref extendability_header) and for the [enumeration problem](@ref enumeration_header).
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