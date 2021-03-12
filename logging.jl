using Dates
using Logging

function write_log(msg::String, lvl::Logging.LogLevel)
	io = open("log.txt", "a+")
	logger = SimpleLogger(io, Logging.Error)

	msg = "[$(Dates.format(Dates.now(), "dd.mm.Y HH:MM:SS"))] $msg"

	with_logger(logger) do
		@logmsg lvl msg
	end

	@logmsg lvl msg

	flush(io)
	close(io)
end

write_log("Hallo!", Logging.Info)
write_log("Hallo!", Logging.Error)
write_log("Hallo!", Logging.Warn)