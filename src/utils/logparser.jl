using JSON

"""
	get_times_dict(file::String)::Dict

Convert a logfile to a dictionary containing the times. The
dictionary has the following structure:
{
	"algorithm": {
		"input1": {
			"median": 1.124,
			"mean": 1.312
		},
		"input2": ...
	}
}
"""
function get_times_dict(file::String)::Dict
	io = open(file, "r")
	log = readlines(io)
	close(io)

	filter!(line -> !contains(line, "@ Main"), log)
	filter!(line -> !contains(line, "Minimum time"), log)
	filter!(line -> !contains(line, "Maximum time"), log)
	filter!(line -> !contains(line, "---"), log)

	algo = log[1][findfirst("'", log[1])[1]+1:findlast("'", log[1])[1]-1]
	times = Dict()

	# Start at index 2 because the name of the algorithm is stored at index 1.
	for i = 2:3:length(log)
		title = log[i][findfirst("'", log[i])[1]+1:findlast("'", log[i])[1]-1]

		times[title] = Dict(
			"median" => parse(Float64, log[i+1][findfirst(r"\d", log[i+1])[1]:end]),
			"mean" => parse(Float64, log[i+2][findfirst(r"\d", log[i+2])[1]:end])
		)
	end

	Dict(algo => times)
end

"""
	dict_to_csv(dict::Dict, use_median::Bool = true)::String

Convert a dictionary of time measurements into a `csv`-formatted string.
The parameter use_median indicates whether the median or mean should be used:
If set to true (or ommitted), the median will be used, otherwise the mean.

It is possible to set the file parameter in order to save the `csv`-formatted
string in that given file.
"""
function dict_to_csv(dict::Dict, use_median::Bool = true, file::String = "")::String
	csv_str = "Algorithm;Instance;Time\n"
	val = use_median ? "median" : "mean"

	for (key, value) in dict
		csv_str = string(csv_str, algo, ";", key, ";", value[val][1], "\n")
		csv_str = string(csv_str, algo, ";", key, ";", value[val][2], "\n")
		csv_str = string(csv_str, algo, ";", key, ";", value[val][3], "\n")
	end

	if file != ""
		open(file, "w+") do io
			write(io, contents)
		end
	end

	csv_str
end

"""
	print_dict(dict::Dict, io::Core.IO = stdout)

Print the contents of a dictionary as a formatted JSON string
with readable indentation.
"""
function print_dict(dict::Dict, io::Core.IO = stdout)
	println(io, json(dict, 4))
end