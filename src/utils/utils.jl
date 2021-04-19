"""
	nanosec2sec(time::Float64)::Float64

Convert a number in nanoseconds to milliseconds.
"""
function nanosec2millisec(time::Float64)::Float64
	# Nano /1000-> Micro /1000-> Milli /1000-> Second
	time / 1000 / 1000
end