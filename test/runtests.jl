using LightGraphs, PdagExtendability, Test

tests = [
	"enumeration/test_enumerate_v1.jl",
	"enumeration/test_enumerate_v2.jl",
	"extendability/implementation_hs/test_depth_first_search_hs.jl",
	"extendability/implementation_hs/test_dor_tarsi_algo_datastructure_hs.jl",
	"extendability/implementation_hs/test_dor_tarsi_algo_hs.jl",
	"extendability/implementation_hs/test_dor_tarsi_alt_algo_hs.jl",
	"extendability/implementation_hs/test_maximum_cardinality_search_hs.jl",
	"extendability/implementation_hs/test_new_algo_datastructure_hs.jl",
	"extendability/implementation_hs/test_new_algo_hs.jl",
	"extendability/implementation_hs/test_new_algo_optimization_hs.jl",
	"extendability/implementation_lg/test_dor_tarsi_algo_lg.jl",
	"extendability/implementation_lg/test_new_algo_datastructure_lg.jl",
	"extendability/implementation_lg/test_new_algo_lg.jl",
	"extendability/implementation_lg/test_new_algo_optimization_lg.jl",
	"extendability/implementation_mpdag/test_connected_components.jl",
	"extendability/implementation_mpdag/test_meek_rules.jl",
	"extendability/implementation_mpdag/test_new_algo_mpdag.jl",
	"extendability/implementation_mpdag/test_pdag2mpdag2dag.jl",
	"utils/test_dag_generator.jl",
	"utils/test_graph_generator.jl",
	"utils/test_pdag_generator.jl",
	"utils/test_utils.jl"
]

for test in tests
	@testset "$test" begin
		include(test)
	end
end