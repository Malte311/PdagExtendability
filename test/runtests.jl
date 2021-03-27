using LightGraphs
using PdagExtendability, Test

tests = [
	"test_extendability.jl"
]

for test in tests
	test != "runtests.jl" || continue
	@testset "$test" begin
		include(test)
	end
end