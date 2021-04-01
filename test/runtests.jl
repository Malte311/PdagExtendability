using LightGraphs
using PdagExtendability, Test

tests = [
	"extendability/test_dor_tarsi_algo.jl",
	"extendability/test_new_algo_datastructure.jl",
	"extendability/test_new_algo.jl"
]

for test in tests
	@testset "$test" begin
		include(test)
	end
end