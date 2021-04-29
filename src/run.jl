using BenchmarkTools, Dates, JSON, Logging, PdagExtendability

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

for algorithm in config["algorithm"]
	global algo = Symbol(algorithm[1:findfirst("(", algorithm)[1]-1])
	params = split(
		algorithm[findfirst("(", algorithm)[1]+1:findfirst(")", algorithm)[1]-1],
		", "
	)
	filter!(s -> s != "", params)
	params = isempty(params) ? Vector() : map(s -> parse(Bool, s), params)

	@info "Running algorithm '$algorithm-$(config["algorithm_log_id"])'"

	for (root, dirs, files) in walkdir(config["benchmarkdir"])
		for f in files
			!occursin(".DS_Store", f) || continue

			@info "[$(Dates.format(now(), "HH:MM"))] Running benchmark for '$f'..."
			pdag = readinputgraph(joinpath(root, f), config["only_undirected"])

			bench = @benchmark getfield(Main, algo)(
				$pdag,
				$params...
			) samples=samples evals=evals

			@info "Minimum time (ms): $(nanosec2millisec(minimum(bench.times)))"
			@info "Median time (ms):  $(nanosec2millisec(median(bench.times)))"
			@info "Mean time (ms):    $(nanosec2millisec(mean(bench.times)))"
			@info "Maximum time (ms): $(nanosec2millisec(maximum(bench.times)))"
			@info "--------------------------------------------------"

			config["logtofile"] && flush(io)

			config["visualize"] || continue

			dag = getfield(Main, algo)(pdag, params...)

			plotsvg(pdag, string(config["logdir"], "in-", replace(f, ".txt" => ".svg")))
			plotsvg(dag, string(config["logdir"], "out-", replace(f, ".txt" => ".svg")))
		end
	end

	@info "---"
end

config["logtofile"] && close(io)

if config["create_csv"]
	times = get_times_dict(joinpath(config["logdir"], config["logfile"]))

	dict_to_csv(
		times,
		file = replace(
			string(config["logdir"], config["logfile"]),
			".txt" => ".csv"
		)
	)
end