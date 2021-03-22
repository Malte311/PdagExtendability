![Build Status](https://travis-ci.com/Malte311/PdagExtendability.svg?token=peoMTzKpBjcCaX8BZgzt&branch=master)
[![Documentation](https://img.shields.io/badge/docs-latest-blue)](https://malte311.github.io/PdagExtendability/)

# PdagExtendability
> TODO: Describe what this software does.

## Usage
> TODO: Describe how to use the implemented algorithms and how to run benchmarks.

On Linux: Set `H_UID` and `H_GID` in `docker-compose.yml`.

## Development
The whole software is wrapped inside a Docker container. Thus, it is not even
necessary to have Julia installed on your system. Using Docker, simply run
`./run.sh` to start the system. Edit the source files as you like and execute
them directly in the shell provided by Docker.

In case the Dockerfile changes, you can run `./run.sh b` to rebuild the
Docker container before starting it.

## TODO
A list of some things which need to be done.

- Maybe use the [CausalInference](https://juliahub.com/docs/CausalInference/aEe3Z/0.5.6/)
package.
- Sub-modules for Extendability, Recognition, Orientation?