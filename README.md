
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ollama

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/ollama)](https://CRAN.R-project.org/package=ollama)
[![R-CMD-check](https://github.com/calderonsamuel/ollama/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/calderonsamuel/ollama/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of ollama is to wrap the
[`ollama`](https://github.com/jmorganca/ollama/blob/main/docs/api.md)
API and provide infrastructure to be used within
[`{gptstudio}`](https://github.com/MichelNivard/gptstudio)

## Installation

You can install the development version of ollama like so:

``` r
pak::pak("calderonsamuel/ollama")
```

## Prerequisites

The user is in charge of downloading ollama and providing networking
configuration. We recommend using [the official docker
image](https://ollama.ai/blog/ollama-is-now-available-as-an-official-docker-image),
which trivializes this process.

The following code downloads the default ollama image and runs an
“ollama” container exposing the 11434 port.

``` bash
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

By default, this package will use `http://localhost:11434` as API host
url. Although we provide methods to change this, only do it if you are
absolutely sure of what it means.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(ollama)
## basic example code
```
