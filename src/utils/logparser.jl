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
```julia-repl
julia> get_times_dict("../logs/log.txt")
Dict{String,Dict{Any,Any}} with 1 entry:
  "pdag2dag_lg()-1" => Dict{Any,Any}("example.txt"=>Dict("median"=>2426.5,"mean"=>2594.65))
```
"""
function get_times_dict(file::String)::Dict
	io = open(file, "r")
	lines = readlines(io)
	close(io)

	logs = Vector{Vector{String}}()
	startindex = 1
	for i = 1:length(lines)
		occursin("---", lines[i]) || continue
		push!(logs, lines[startindex:i])
		startindex = i+1
	end

	result = Dict()

	for log in logs
		filter!(line -> !contains(line, "@ Main"), log)
		filter!(line -> !contains(line, "Average iterations"), log)
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

		result[algo] = times
	end

	result
end

"""
	dict_to_csv(dict::Dict, use_median::Bool = true)::String

Convert a dictionary of time measurements into a `csv`-formatted string.
The parameter use_median indicates whether the median or mean should be used:
If set to true (or ommitted), the median will be used, otherwise the mean.

It is possible to set the file parameter in order to save the `csv`-formatted
string in that given file.

# Examples
```julia-repl
julia> dict = get_times_dict("../logs/log.txt")
Dict{String,Dict{Any,Any}} with 1 entry:
  "pdag2dag_lg()-1" => Dict{Any,Any}("example.txt"=>Dict("median"=>2426.5,"mean"=>2594.65))
julia> dict_to_csv(dict)
  "Algorithm;Instance;Time\npdag2dag_lg()-1;example.txt;2426.5\n"
```
"""
function dict_to_csv(dict::Dict; use_median::Bool = true, file::String = "")::String
	csv_str = "Algorithm;Instance;Time\n"
	val = use_median ? "median" : "mean"

	for (algo, times) in dict
		algo = algo2label(algo)

		for (key, value) in times
			key = replace(key, r"(.txt|.gr)" => "")
			csv_str = string(csv_str, algo, ";", key, ";", value[val], "\n")
		end
	end

	if file != ""
		open(file, "w+") do io
			write(io, csv_str)
		end
	end

	csv_str
end

"""
	print_dict(dict::Dict, io::Core.IO = stdout)

Print the contents of a dictionary as a formatted JSON string
with readable indentation.

# Examples
```julia-repl
julia> dict = get_times_dict("../logs/log.txt")
Dict{String,Dict{Any,Any}} with 1 entry:
  "pdag2dag_lg()" => Dict{Any,Any}("example.txt"=>Dict("median"=>2426.5,"mean"=>2594.65))
julia> julia> print_dict(dict)
{
    "pdag2dag_lg()": {
        "example.txt": {
            "median": 2426.5,
            "mean": 2594.646
        }
    }
}
```
"""
function print_dict(dict::Dict, io::Core.IO = stdout)
	println(io, json(dict, 4))
end

"""
	algo2label(algo::String)::String

Map the function name of the used algorithm to a label for the plot.

# Examples
```julia-repl
julia> algo2label("pdag2dag_hs()-1")
Dor Tarsi HS - 1
```
"""
function algo2label(algo::String)::String
	mapping = Dict(
		"pdag2dag_hs"            => "Dor Tarsi HS",
		"altpdag2dag_hs"         => "Dor Tarsi HS - Alternative",
		"fastpdag2dag_hs(false)" => "New Algo HS - O(V*E)",
		"fastpdag2dag_hs(true)"  => "New Algo HS - O(dm)",
		"pdag2dag_lg"            => "Dor Tarsi LG",
		"fastpdag2dag_lg(false)" => "New Algo LG - O(V*E)",
		"fastpdag2dag_lg(true)"  => "New Algo LG - O(dm)"
	)

	id = split(algo, "-")[2]

	for (key, val) in mapping
		occursin(key, algo) && return isempty(id) ? val : string(val, " - ", id)
	end

	algo
end