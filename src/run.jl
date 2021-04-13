using BenchmarkTools, Dates, JSON, Logging, PdagExtendability

samples = 1000
evals = 1

if length(ARGS) != 1 || !isfile(ARGS[1])
	@error "Run the script via 'julia run.jl <path/to/config.json>'."
	exit()
end

config = JSON.parsefile(ARGS[1])

if config["logtofile"]
	io = open(joinpath(config["logdir"], config["logfile"]), "a+")
	global_logger(SimpleLogger(io))
end

for f in readdir(config["benchmarkdir"])
	isfile(joinpath(config["benchmarkdir"], f)) || continue

	@info "[$(Dates.format(now(), "HH:MM"))] Running benchmark for '$f'..."
	pdag = readinputgraph(
		joinpath(config["benchmarkdir"], f),
		config["only_undirected"]
	)

	bench1 = @benchmark pdag2dag($pdag) samples=samples evals=evals
	bench2 = @benchmark fastpdag2dag($pdag, false) samples=samples evals=evals
	bench3 = @benchmark fastpdag2dag($pdag, true) samples=samples evals=evals

	for b in [bench1, bench2, bench3]
		@info "Minimum time: $(round(minimum(b.times), digits=2))"
		@info "Median time:  $(round(median(b.times), digits=2))"
		@info "Mean time:    $(round(mean(b.times), digits=2))"
		@info "Maximum time: $(round(maximum(b.times), digits=2))"
		@info "--------------------------------------------------"
	end

	config["logtofile"] && flush(io)

	config["visualize"] || continue

	dag1 = pdag2dag(pdag)
	dag2 = fastpdag2dag(pdag, false)
	dag3 = fastpdag2dag(pdag, true)

	plotsvg(pdag, string(config["logdir"], "in-", replace(f, ".txt" => ""), ".svg"))
	plotsvg(dag1, string(config["logdir"], "out1-", replace(f, ".txt" => ""), ".svg"))
	plotsvg(dag2, string(config["logdir"], "out2-", replace(f, ".txt" => ""), ".svg"))
	plotsvg(dag3, string(config["logdir"], "out3-", replace(f, ".txt" => ""), ".svg"))
end

config["logtofile"] && close(io)