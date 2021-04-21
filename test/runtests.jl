using LightGraphs, PdagExtendability, Test

tests = [
	"extendability/implementation_hs/test_new_algo_datastructure.jl",
	"extendability/implementation_hs/test_new_algo_optimization.jl",
	"extendability/implementation_hs/test_new_algo.jl",
	"extendability/implementation_lg/test_dor_tarsi_algo.jl",
	"extendability/implementation_lg/test_new_algo_lg.jl"
]

for test in tests
	@testset "$test" begin
		include(test)
	end
end