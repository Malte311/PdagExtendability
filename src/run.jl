using BenchmarkTools, Dates, JSON, LightGraphs, Logging, PdagExtendability

if length(ARGS) != 1 || !isfile(ARGS[1])
	@error "Run the script via 'julia run.jl <path/to/config.json>'."
	exit()
end

config = JSON.parsefile(ARGS[1])

if config["logtofile"]
	logfile = joinpath(config["logdir"], config["logfile"])
	isfile(logfile) && @warn "Logfile exists and will be overridden."
	io = open(logfile, "w+")
	global_logger(SimpleLogger(io))
end

samples = config["num_samples"]
evals = config["num_evals"]

extendable = Vector()
not_extendable = Dict()

for algorithm in config["algorithm"]
	global algo = Symbol(algorithm[1:findfirst("(", algorithm)[1]-1])
	params = split(
		algorithm[findfirst("(", algorithm)[1]+1:findfirst(")", algorithm)[1]-1],
		", "
	)
	filter!(s -> s != "", params)
	params = isempty(params) ? Vector() : map(s -> parse(Bool, s), params)

	emptygraphs = Vector()

	@info "Running algorithm '$algorithm-$(config["algorithm_log_id"])'"

	for (root, dirs, files) in walkdir(config["benchmarkdir"])
		for f in files
			(!occursin(".DS_Store", f) && !occursin("README.md", f)) || continue

			@info "[$(Dates.format(now(), "HH:MM"))] Running benchmark for '$f'..."
			pdag = readinputgraph(joinpath(root, f), config["only_undirected"])
			result = getfield(Main, algo)(pdag, params...)
			config["enumerate"] && (result = map(g -> dtgraph2digraph(g), result))

			bench = @benchmark getfield(Main, algo)(
				$pdag,
				$params...
			) samples=samples evals=evals

			if (!config["enumerate"] && result == SimpleDiGraph(0)) ||
					(config["enumerate"] && isempty(result))
				push!(emptygraphs, f)
			elseif (!config["enumerate"] && !is_consistent_extension(result, pdag)) ||
					(config["enumerate"] && any(g -> !is_consistent_extension(g, pdag), result))
				file = string(config["logdir"], "err-", replace(f, ".txt" => ".svg"))
				plotsvg(result, file)
				@error "Output is no consistent extension! A plot can be found at $file."
				exit()
			else
				push!(extendable, f)
			end

			@info "Minimum time (ms): $(nanosec2millisec(minimum(bench.times)))"
			@info "Median time (ms):  $(nanosec2millisec(median(bench.times)))"
			@info "Mean time (ms):    $(nanosec2millisec(mean(bench.times)))"
			@info "Maximum time (ms): $(nanosec2millisec(maximum(bench.times)))"

			config["logtofile"] && flush(io)

			config["visualize"] || continue

			plotsvg(pdag, string(config["logdir"], "in-", replace(f, ".txt" => ".svg")))
			i = 0
			for dag in (config["enumerate"] ? result : [result])
				plotsvg(dag, string(config["logdir"], "out-$(i+=1)-", replace(f, ".txt" => ".svg")))
			end
		end
	end

	not_extendable[algorithm] = emptygraphs

	@info "---"
end

@info "Extendable inputs: $extendable"
@info "Not extendable inputs: $not_extendable"

for (key, val) in not_extendable
	if val != collect(values(not_extendable))[1]
		@error "Algorithms found different non-extendable graphs."
		exit()
	end
end

config["logtofile"] && close(io)

if config["create_csv"]
	times = get_times_dict(joinpath(config["logdir"], config["logfile"]))

	dict_to_csv(
		times,
		use_median = config["use_median"],
		file = replace(
			string(config["logdir"], config["logfile"]),
			".txt" => ".csv"
		)
	)
end