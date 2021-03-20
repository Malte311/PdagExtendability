using LightGraphs
using GraphPlot

# g = Graph(5)

# add_edge!(g, 1, 2)
# add_edge!(g, 2, 3)
# add_edge!(g, 3, 4)
# add_edge!(g, 4, 5)
# add_edge!(g, 5, 1)

# gplot(g, nodelabel=1:5)

# for arg in ARGS
# 	config = open("arg", "r")
	


# 	println(arg)
# end

# TODO: Init global logger here and remove logging.jl?

for i = 1:5
	@time print("Hallo!")
end