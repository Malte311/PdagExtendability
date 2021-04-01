module PdagExtendability

include("extendability/dor_tarsi_algo.jl")
export pdag2dag, sink

include("extendability/new_algo.jl")
export init, is_adjacent, insert_arc!, insert_edge!,
remove_arc!, remove_edge!, update_alphabeta!,
is_ps, list_ps, pop_ps!, print_graph
export degeneracy_ordering, deg_struct, pop_min_deg_vertex!,
update_deg!
export fastpdag2dag

include("utils/plotting.jl")
export plotsvg

include("utils/readinput.jl")
export readinputgraph

end