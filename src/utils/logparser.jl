using JSON

function extract_times(file::String)::Dict
	io = open(file, "r")
	log = readlines(io)
	close(io)

	# Keeps mean and median only. If minimum and/or maximum
	# are relevant as well, remove the filter.
	filter!(line -> !contains(line, "@ Main"), log)
	filter!(line -> !contains(line, "Minimum time"), log)
	filter!(line -> !contains(line, "Maximum time"), log)
	filter!(line -> !contains(line, "---"), log)

	times = Dict()

	for i = 1:7:length(log)
		title = log[i][findfirst("'", log[i])[1]+1:findlast("'", log[i])[1]-1]

		times[title] = Dict(
			"median" => map(
				n -> parse(Float64, n[findfirst(r"\d", n)[1]:end]),
				[log[i+1], log[i+3], log[i+5]]
			),
			"mean" => map(
				n -> parse(Float64, n[findfirst(r"\d", n)[1]:end]),
				[log[i+2], log[i+4], log[i+6]]
			)
		)
	end

	times
end

function dict_to_csv(times::Dict, val::String = "median")::String
	csv_str = "Algorithm;Instance;Time\n"

	for (key, value) in times
		csv_str = string(csv_str, "DorTarsi", ";", key, ";", value[val][1], "\n")
		csv_str = string(csv_str, "NewAlgo", ";", key, ";", value[val][2], "\n")
		csv_str = string(csv_str, "NewAlgoOpt", ";", key, ";", value[val][3], "\n")
	end

	csv_str
end

function save_as_csv(contents::String, file::String)
	open(file, "w+") do io
		write(io, contents)
	end
end

# save_as_csv(dict_to_csv(extract_times("/home/user/logs/abc.txt")), "times2.csv")
# print(dict_to_csv(extract_times("/home/user/logs/dummylog.txt")))