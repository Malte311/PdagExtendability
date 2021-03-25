using JSON
using Logging

include("PdagExtendability.jl")

if length(ARGS) != 1 || !isfile(ARGS[1])
	@error "Run the script via 'julia run.jl <path/to/config.json>'."
	exit()
end

config = JSON.parsefile(ARGS[1])

io = open(string(config["logdir"], config["logfile"]), "a+")
global_logger(SimpleLogger(io))

for benchmark in readdir(config["benchmarkdir"])
	pdag = PdagExtendability.readinputgraph(string(config["benchmarkdir"], benchmark))
	dag = PdagExtendability.pdag2dag(pdag)
	config["visualize"] || continue
	PdagExtendability.plotsvg(pdag, string(config["logdir"], "input-", benchmark, ".svg"))
	PdagExtendability.plotsvg(dag, string(config["logdir"], "output-", benchmark, ".svg"))
end

close(io)