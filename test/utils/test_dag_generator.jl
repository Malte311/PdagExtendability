@testset "random_dag" begin
	for min_r in [1, 2, 3, 5, 7, 10]
		for max_r in [i+min_r for i in [2, 3, 5]]
			for min_v_per_r in [3, 5, 7, 10, 20]
				for max_v_per_r in [i+min_v_per_r for i in [2, 3, 5, 7, 10]]
					for prob in [0.1, 0.2, 0.3, 0.5, 0.7, 0.9]
						dag = random_dag(min_r, max_r, min_v_per_r, max_v_per_r, prob)
						@test isdag(dag)
					end
				end
			end
		end
	end
end