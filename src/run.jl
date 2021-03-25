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

for benchmark in readdir(config["benchmarkdir"])
	pdag = readinputgraph(joinpath(config["benchmarkdir"], benchmark))
	dag = pdag2dag(pdag)
	
	config["visualize"] || continue
	
	plotsvg(pdag, string(config["logdir"], "input-", benchmark, ".svg"))
	plotsvg(dag, string(config["logdir"], "output-", benchmark, ".svg"))
end

close(io)