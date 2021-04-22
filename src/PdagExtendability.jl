module PdagExtendability

include("extendability/implementation_hs/dor_tarsi_algo_hs.jl")
export setup_hs, isadjacent_hs, insert_edge_hs!, remove_vertex_hs!,
print_graph_hs
export pdag2dag_hs, sink_hs

include("extendability/implementation_hs/new_algo_hs.jl")
export init_hs, is_adjacent_hs, insert_arc_hs!, insert_edge_hs!,
remove_arc_hs!, remove_edge_hs!, update_alphabeta_hs!,
is_ps_hs, list_ps_hs, pop_ps_hs!, print_graph_hs
export degeneracy_ordering_hs, deg_struct_hs, pop_min_deg_vertex_hs!,
update_deg_hs!
export fastpdag2dag_hs, standardsetup_hs, optimizedsetup_hs, extendgraph_hs

include("extendability/implementation_lg/dor_tarsi_algo_lg.jl")
export pdag2dag_lg, sink_lg

include("extendability/implementation_lg/new_algo_lg.jl")
export init_lg, is_adjacent_lg, is_directed_lg, is_undirected_lg,
insert_arc_lg!, insert_edge_lg!, remove_arc_lg!, remove_edge_lg!,
update_alphabeta_lg!, init_auxvectors_lg!, is_ps_lg, list_ps_lg,
pop_ps_lg!, print_graph_lg
export fastpdag2dag_lg, standardsetup_lg, extendgraph_lg

include("utils/utils.jl")
export nanosec2millisec

include("utils/logparser.jl")
export get_times_dict, dict_to_csv, print_dict

include("utils/plotting.jl")
export plotsvg

include("utils/readinput.jl")
export readinputgraph

end