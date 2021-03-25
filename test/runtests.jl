using LightGraphs
using PdagExtendability, Test

for test in readdir("../test/")
	test != "runtests.jl" || continue
	@testset "$test" begin
		include(test)
	end
end