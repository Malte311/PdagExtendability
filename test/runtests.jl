using LightGraphs
using PdagExtendability, Test

tests = [
	"extendability.jl"
]

for test in tests
	test != "runtests.jl" || continue
	@testset "$test" begin
		include(test)
	end
end