# Getting Started

The first step to use this benchmarking framework is to download
the source repository. The repository contains all benchmarks in
addition to the source code itself. It can be downloaded using
Git:

```bash
git clone git@github.com:Malte311/PdagExtendability.git
```

The Docker container can then be started via `./run.sh`. Using
Docker, you don't have to install the dependencies on your machine
(in fact, you don't even need Julia to be installed). After running
`./run.sh`, you can directly interact with Julia in the terminal
provided by Docker.

In order to run the benchmarks, simply run the following command.

```bash
julia run.jl "../configs/config-1.json"
```

You can adapt the configuration file `config.json` in order to customize
the setup. These are the configuration options which are provided:

- `algorithm`: An array containing the function calls of the algorithms which should be run (i.e., parenthesis and additional parameters must be provided). Available algorithms for the extension problem are [`pdag2dag_hs`](@ref), [`altpdag2dag_hs`](@ref), [`pdag2dag_lg`](@ref), [`fastpdag2dag_hs`](@ref), [`fastpdag2dag_lg`](@ref), and [`pdag2mpdag2dag`](@ref). For fully undirected graphs [`undir2dag`](@ref) is an option as well, for fully directed graphs the algorithm [`dir2dag`](@ref) can be used as well, and for maximally oriented partially directed acyclic graphs (i.e., graphs from the subdirectory `benchmarks/mpdirected`) the algorithm [`mpdag2dag`](@ref) might be utilized as well.
- `algorithm_log_id` (optional): An id to identify a specific run. For example, if you run the same algorithm twice, both results are named the same. In order to prevent this, you can add an id for each run. The id can be an arbitrary string.
- `benchmarkdir`: The path to the directory which contains the benchmarks which should be run. Note that all subdirectories are evaluated as well.
- `create_csv`: Boolean value to specify whether a `.csv` file of the run should be created. The file contains one row per benchmark. Each row contains the name of the algorithm, the name of the input file, and the measured time for that instance.
- `enumerate`: Boolean value to specify whether the algorithms solve the enumeration problem (`true`) or the extension problem (`false`).
- `logdir`: The path to the directory in which logs should be written.
- `logfile`: The name of the logfile.
- `logtofile`: Boolean value to specify whether logs should be written to the logfile (`true`) or to `stdout` (`false`).
- `num_evals`: The number of evaluations per sample.
- `num_samples`: The number of samples to take.
- `only_undirected`: Boolean value to specify whether the input graphs contain only undirected edges (`true`) or not (`false`), i.e., if undirected edges are **not** encoded via two directed edges in the input file. For the `benchmarks/undirected` directory, this should be set to `true`. For all of the other directories (e.g., `benchmarks/directed` and `benchmarks/pdirected`), it should be set to `false`.
- `use_median`: Boolean value to specify whether to use the median of the measurements. If set to `false`, the mean will be used instead.
- `visualize`: Boolean value to specify whether the input graph and the output graph should be plotted and saved to a `.svg` file.

It is also possible to run multiple trials simultaneously using different configuration files for each trial.
An exemplary configuration file could look like this:

```json
{
	"algorithm": [
		"pdag2dag_hs(false)",
		"pdag2dag_hs(true)",
		"fastpdag2dag_hs(false)",
		"fastpdag2dag_hs(true)"
	],
	"algorithm_log_id": "",
	"benchmarkdir": "../benchmarks/pdirected/sparse/n=1024/",
	"create_csv": false,
	"enumerate": false,
	"logdir": "../logs/",
	"logfile": "log-1.txt",
	"logtofile": false,
	"num_evals": 1,
	"num_samples": 5,
	"only_undirected": false,
	"use_median": true,
	"visualize": false
}
```

## Generating Your Own Benchmarks
In order to run the algorithms on other graphs than the provided
benchmarks, you can generate your own graphs. There are plenty of
functions for generating graphs which can be found under the
[Utilities](@ref utilities_header) section.