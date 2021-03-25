using JSON
using Logging

include("PdagExtendability.jl")

if length(ARGS) != 1 || !isfile(ARGS[1])
	@error "Run the script via 'julia run.jl <path/to/config.json>'."
	exit()
end

config = JSON.parsefile(ARGS[1])

io = open(config["logfile"], "a+")
global_logger(SimpleLogger(io))

pdag = PdagExtendability.readinputgraph("../benchmarks/example.txt")
dag = PdagExtendability.pdag2dag(pdag)

close(io)