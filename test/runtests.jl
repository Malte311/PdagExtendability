using LightGraphs, PdagExtendability, Test

tests = [
	"extendability/new_algo_lg/test_new_algo_lg.jl",
	"extendability/test_dor_tarsi_algo.jl",
	"extendability/test_new_algo_datastructure.jl",
	"extendability/test_new_algo_optimization.jl",
	"extendability/test_new_algo.jl"
]

for test in tests
	@testset "$test" begin
		include(test)
	end
end