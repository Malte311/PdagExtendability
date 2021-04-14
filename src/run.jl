using BenchmarkTools, Dates, JSON, Logging, PdagExtendability

if length(ARGS) != 1 || !isfile(ARGS[1])
	@error "Run the script via 'julia run.jl <path/to/config.json>'."
	exit()
end

config = JSON.parsefile(ARGS[1])

if config["logtofile"]
	io = open(joinpath(config["logdir"], config["logfile"]), "a+")
	global_logger(SimpleLogger(io))
end

samples = config["num_samples"]
evals = config["num_evals"]

algo = Symbol(config["algorithm"])

alg_str = string(config["algorithm"], "(", config["algorithm_params"]..., ")")
@info "[$(Dates.format(now(), "HH:MM"))] Running algorithm '$alg_str'"

for f in readdir(config["benchmarkdir"])
	isfile(joinpath(config["benchmarkdir"], f)) && f != ".DS_Store" || continue

	@info "[$(Dates.format(now(), "HH:MM"))] Running benchmark for '$f'..."
	pdag = readinputgraph(
		joinpath(config["benchmarkdir"], f),
		config["only_undirected"]
	)

	bench = @benchmark getfield(Main, algo)(
		$pdag,
		config["algorithm_params"]...
	) samples=samples evals=evals

	@info "Minimum time: $(minimum(bench.times))"
	@info "Median time:  $(median(bench.times))"
	@info "Mean time:    $(mean(bench.times))"
	@info "Maximum time: $(maximum(bench.times))"
	@info "--------------------------------------------------"

	config["logtofile"] && flush(io)

	config["visualize"] || continue

	dag = getfield(Main, algo)(pdag)

	plotsvg(pdag, string(config["logdir"], "in-", replace(f, ".txt" => ".svg")))
	plotsvg(dag, string(config["logdir"], "out-", replace(f, ".txt" => ".svg")))
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