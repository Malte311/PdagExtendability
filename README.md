![Build Status](https://travis-ci.com/Malte311/PDAG-Extendability.svg?token=peoMTzKpBjcCaX8BZgzt&branch=master)
[![Documentation](https://img.shields.io/badge/docs-latest-blue)](https://malte311.github.io/PDAG-Extendability/)

# PDAG-Extendability
> TODO

## Usage
> TODO

## Development
> TODO

```bash
docker-compose -f docker-compose-dev.yml up --build
docker-compose -f docker-compose-dev.yml exec --user www-data pdag_extensions bash
```

## Documentation
> TODO

```bash
julia -e 'using Pkg; Pkg.add("Documenter")'
julia --project=docs/ docs/make.jl
```