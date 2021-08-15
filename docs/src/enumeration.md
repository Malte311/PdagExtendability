# [Enumeration Problem](@id enumeration_header)

Below, there are algorithms listed that solve the enumeration problem.
That is, given a partially directed graph $G$, compute **all** consistent
DAG extensions of $G$.

Currently, the following algorithms are available:
- [`enumerate_v1`](@ref) - An algorithm with worst-case time complexity $O(2^{|E|} \Delta |E|^3)$.
- [`enumerate_v2`](@ref) - An algorithm with worst-case time complexity $O(2^{|E|} \Delta |E|^3)$.

Both algorithms [`enumerate_v1`](@ref) and [`enumerate_v2`](@ref) do not differ
very much and use a rather naive approach to compute a result.

```@autodocs
Modules = [PdagExtendability]
Pages = [
	"enumeration/enumerate_v1.jl",
	"enumeration/enumerate_v2.jl"
]
```