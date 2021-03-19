using Dates
using Logging

"""
	writelog(msg::String, lvl::Logging.LogLevel)

Write a log message to stdout and additionally to a file if the
provided parameter lvl is of type Logging.Error.

# Examples
```julia
julia> writelog("Hello, world!", Logging.Info)
```
"""
function writelog(msg::String, lvl::Logging.LogLevel)
	io = open("log.txt", "a+")
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