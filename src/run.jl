using JSON
using Logging
using PdagExtendability

if length(ARGS) != 1 || !isfile(ARGS[1])
	@error "Run the script via 'julia run.jl <path/to/config.json>'."
	exit()
end

config = JSON.parsefile(ARGS[1])

io = open(joinpath(config["logdir"], config["logfile"]), "a+")
global_logger(SimpleLogger(io))

for f in readdir(config["benchmarkdir"])
	pdag = readinputgraph(joinpath(config["benchmarkdir"], f))
	dag = pdag2dag(pdag)

	config["visualize"] || continue

	plotsvg(pdag, string(config["logdir"], "input-", replace(f, ".txt" => ""), ".svg"))
	plotsvg(dag, string(config["logdir"], "output-", replace(f, ".txt" => ""), ".svg"))
end

close(io)