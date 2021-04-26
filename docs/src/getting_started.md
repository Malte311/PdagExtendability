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
julia run.jl "../configs/config.json"
```

You can adapt the configuration file `config.json` in order to customize
the setup. These are the configuration options which are provided:

- `algorithm`: The name of the algorithm which should be run. Can be either `pdag2dag_hs`, `pdag2dag_lg`, `fastpdag2dag_hs`, or `fastpdag2dag_lg`.
- `algorithm_log_id` (optional): An id to identify a specific run. For example, if you run the same algorithm twice, both results are named the same. In order to prevent this, you can add an id for each run. The id can be an arbitrary string.
- `algorithm_params` (optional): A list of parameters to pass to the algorithm. If the algorithm to be run does not support any parameters, the list must be empty. For example, you can pass `true` to `fastpdag2dag_hs` in order to run the optimized setup (or `false` in order to run the standard setup).
- `benchmarkdir`: The path to the directory which contains the benchmarks which should be run. Note that all subdirectories are evaluated as well.
- `create_csv`: Boolean value to specify whether a `.csv` file of the run should be created. The file contains one row per benchmark. Each row contains the name of the algorithm, the name of the input file, and the measured time for that instance.
- `logdir`: The path to the directory in which logs should be written.
- `logfile`: The name of the logfile.
- `logtofile`: Boolean value to specify whether logs should be written to the logfile (`true`) or to `stdout` (`false`).
- `num_evals`: The number of evaluations per sample.
- `num_samples`: The number of samples to take.
- `only_undirected`: Boolean value to specify whether the input graphs contain only undirected edges (`true`) or not (`false`).
- `visualize`: Boolean value to specify whether the input graph and the output graph should be plotted and saved to a `.svg` file.

It is also possible to run multiple trials simultaneously using different configuration files for each trial.