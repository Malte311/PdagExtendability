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

# Examples
TODO
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

# Examples
TODO
"""
function dict_to_csv(dict::Dict; use_median::Bool = true, file::String = "")::String
	csv_str = "Algorithm;Instance;Time\n"
	val = use_median ? "median" : "mean"
	algo = collect(keys(dict))[1]

	for (key, value) in dict[collect(keys(dict))[1]]
		csv_str = string(csv_str, algo, ";", key, ";", value[val], "\n")
	end

	if file != ""
		open(file, "w+") do io
			write(io, csv_str)
		end
	end

	csv_str
end

function gen_plot_code(out_file::String, csv_files::String...)
	rcode = "library(ggplot2)\n\n"

	firstline = true
	for csv in csv_files
		if firstline
			rcode = string(
				rcode,
				"data <- read.csv(file = \"$csv\", sep=\";\", dec=\".\")",
				"\n"
			)
			firstline = false
		else
			rcode = string(
				rcode,
				"data <- data + read.csv(file = \"$csv\", sep=\";\", dec=\".\")",
				"\n"
			)
		end
	end

	rcode = string(
		rcode,
		"\n",
		"ggplot(data, aes(x = Instance, y = Time, fill = Algorithm))",
		" + ",
		"geom_bar(stat=\"identity\", position = \"dodge\")"
	)

	open(out_file, "w+") do io
		write(io, rcode)
	end
end

"""
	print_dict(dict::Dict, io::Core.IO = stdout)

Print the contents of a dictionary as a formatted JSON string
with readable indentation.

# Examples
TODO
"""
function print_dict(dict::Dict, io::Core.IO = stdout)
	println(io, json(dict, 4))
end



#print_dict(get_times_dict("/home/user/logs/test.txt"))

dict_to_csv(get_times_dict("/home/user/logs/pdag2dag.txt"), file = "pdag2dag.csv")
dict_to_csv(get_times_dict("/home/user/logs/fastpdag2dag-true.txt"), file = "fastpdag2dag-true.csv")
dict_to_csv(get_times_dict("/home/user/logs/fastpdag2dag-false.txt"), file = "fastpdag2dag-false.csv")

gen_plot_code("rcode.R", "pdag2dag.csv", "fastpdag2dag-true.csv", "fastpdag2dag-false.csv")