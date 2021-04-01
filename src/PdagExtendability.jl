module PdagExtendability

include("utils/plotting.jl")
export plotsvg

include("utils/readinput.jl")
export readinputgraph

include("extendability/dor_tarsi_algo.jl")
export pdag2dag

include("extendability/new_algo.jl")
export init, is_adjacent, insert_arc!, insert_edge!,
remove_arc!, remove_edge!, update_alphabeta!,
is_ps, list_ps, pop_ps!, print_graph, fastpdag2dag

end