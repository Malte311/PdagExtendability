![Build Status](https://travis-ci.com/Malte311/PdagExtendability.svg?token=peoMTzKpBjcCaX8BZgzt&branch=master)
[![Documentation](https://img.shields.io/badge/docs-latest-blue)](https://malte311.github.io/PdagExtendability/)

# PdagExtendability
Causal relationships are of great interest in many research areas. In order to
model causal relationships, graphical causal models are widely used.

This repository contains algorithms for dealing with such graphical causal
models. Mainly, the three following problems are considered and algorithms to
solve them are implemented in this repository.

1. The extendability problem: Given a partially directed graph, compute a
consistent DAG extension if possible, otherwise return "Not possible".
2. The recognition problem: Given a partially directed graph, decide whether
it is an MPDAG (PDAG, CPDAG, CG).
3. The maximum orientation problem: Given a partially directed acyclic graph,
compute the graph resulting from applying Meek's rules repeatedly.

All of the implemented algorithms are based on the paper "Extendability of
Causal Graphical Models: Algorithms and Computational Complexity".

## Usage
In order to run the benchmarks, download the repository first.
The benchmarks can be started directly from the terminal via
```bash
julia run.jl "../configs/config.json"
```
Alternatively, you can start a Docker container via `./run.sh` and
run the same command inside of the Docker container (this allows to
execute the code without installing Julia or any of the dependencies on
your machine).

In case you want to use Docker and Linux is your operating system, you
have to set the parameters `H_UID` and `H_GID` in
[`docker-compose.yml`](https://github.com/Malte311/PdagExtendability/blob/master/docker-compose.yml).
`H_UID` should be set to the user id of the current user and `H_GID` to
the group id of the current user.

## Development with Docker
The whole software is wrapped inside a Docker container. Thus, it is not even
necessary to have Julia installed on your system. Using Docker, simply run
`./run.sh` to start the system. Edit the source files as you like and execute
them directly in the shell provided by Docker.

In case the Dockerfile changes, you can run `./run.sh b` to rebuild the
Docker container before starting it.