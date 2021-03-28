using LightGraphs
using PdagExtendability, Test

tests = [
	"extendability/test_dor_tarsi_algo.jl"
]

for test in tests
	test != "runtests.jl" || continue
	@testset "$test" begin
		include(test)
	end
end