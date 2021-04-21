using LightGraphs, PdagExtendability, Test

tests = [
	"extendability/implementation_hs/test_new_algo_datastructure_hs.jl",
	"extendability/implementation_hs/test_new_algo_optimization_hs.jl",
	"extendability/implementation_hs/test_new_algo_hs.jl",
	"extendability/implementation_lg/test_dor_tarsi_algo_lg.jl",
	"extendability/implementation_lg/test_new_algo_lg.jl"
]

for test in tests
	@testset "$test" begin
		include(test)
	end
end