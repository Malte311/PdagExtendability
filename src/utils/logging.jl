using Dates
using Logging

"""
	writelog(msg::String, lvl::Logging.LogLevel)

Write a log message to stdout and additionally to a file if the
provided parameter lvl is of type Logging.Error.

# Examples
```julia-repl
julia> using Logging
julia> writelog("Hello, world!", Logging.Info)
```
"""
function writelog(msg::String, lvl::Logging.LogLevel)
	# TODO: Read logfile name from config
	io = open("./logs/log.txt", "a+")
	logger = SimpleLogger(io, Logging.Error)

	msg = "[$(Dates.format(Dates.now(), "dd.mm.Y HH:MM:SS"))] $msg"

	# Log to file
	with_logger(logger) do
		@logmsg lvl msg
	end

	# Log to stdout
	@logmsg lvl msg

	flush(io)
	close(io)
end