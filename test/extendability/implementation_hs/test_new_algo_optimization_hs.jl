@testset "degeneracy_ordering_hs" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	add_edge!(g, 2, 1)
	(deg_order, _) = degeneracy_ordering_hs(g)
	@test [1, 2, 3] == deg_order || [2, 1, 3] == deg_order
end

@testset "deg_struct_hs" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	add_edge!(g, 2, 3)
	add_edge!(g, 3, 2)
	(aux_array, deg_str) = deg_struct_hs(setup_hs(g))
	@test 1 == aux_array[1] && 2 == aux_array[2] && 1 == aux_array[3]
	@test 1 in deg_str[2] && 2 in deg_str[3] && 3 in deg_str[2]

	g = SimpleDiGraph(3)
	(aux_array, deg_str) = deg_struct_hs(setup_hs(g))
	@test 0 == aux_array[1] && 0 == aux_array[2] && 0 == aux_array[3]
	@test 3 == length(deg_str[1]) && isempty(deg_str[2]) &&
	isempty(deg_str[3])
	@test 1 in deg_str[1] && 2 in deg_str[1] && 3 in deg_str[1]

	g = SimpleDiGraph(5)
	add_edge!(g, 1, 2)
	add_edge!(g, 2, 3)
	add_edge!(g, 2, 4)
	add_edge!(g, 2, 5)
	add_edge!(g, 3, 4)
	(aux_array, deg_str) = deg_struct_hs(setup_hs(g))
	@test 1 == aux_array[1] && 4 == aux_array[2] && 2 == aux_array[3] &&
		2 == aux_array[4] && 1 == aux_array[5]
	@test 1 in deg_str[2] && 2 in deg_str[5] && 3 in deg_str[3] &&
		4 in deg_str[3] && 5 in deg_str[2]
end

@testset "pop_min_deg_vertex_hs!" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	(_, deg_str) = deg_struct_hs(setup_hs(g))
	@test 3 == pop_min_deg_vertex_hs!(deg_str)

	g = SimpleDiGraph(4)
	add_edge!(g, 1, 2)
	add_edge!(g, 1, 3)
	add_edge!(g, 1, 4)
	add_edge!(g, 2, 3)
	(_, deg_str) = deg_struct_hs(setup_hs(g))
	@test 4 == pop_min_deg_vertex_hs!(deg_str)
end

@testset "update_deg_hs!" begin
	g = SimpleDiGraph(3)
	add_edge!(g, 1, 2)
	add_edge!(g, 2, 3)
	add_edge!(g, 3, 2)
	(aux_array, deg_str) = deg_struct_hs(setup_hs(g))
	@test 1 == aux_array[1] && 2 == aux_array[2] && 1 == aux_array[3]
	@test 1 in deg_str[2] && 2 in deg_str[3] && 3 in deg_str[2]
	update_deg_hs!(3, aux_array, deg_str)
	@test 1 == aux_array[1] && 2 == aux_array[2] && 0 == aux_array[3]
	@test 1 in deg_str[2] && 2 in deg_str[3] && 3 in deg_str[1]
end