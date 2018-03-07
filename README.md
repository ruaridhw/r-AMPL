
<!-- README.md is generated from README.Rmd. Please edit that file -->
rAMPL
=====

[![Travis build status](https://travis-ci.org/ruaridhw/r-AMPL.svg?branch=master)](https://travis-ci.org/ruaridhw/r-AMPL) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ruaridhw/r-AMPL?branch=master&svg=true)](https://ci.appveyor.com/project/ruaridhw/r-AMPL)

Provides convenience wrappers around the Python package `amplpy` using `reticulate`.

Installation
------------

You can install AMPL from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("ruaridhw/r-AMPL")
```

As this package relies on the `amplpy` API you will need a Python installation and the required package.

You can check if you have Python installed by opening a Terminal and running:

``` bash
python -V
#> Python 3.6.3 :: Anaconda custom (64-bit)
```

If this doesn't print a Python version, you will need to install it first and then run:

``` bash
pip install amplpy
```

You can obviously run this with Anaconda or a Python installation other than the system default.

Usage
-----

This is a basic example which shows you how to solve a common problem.

First, start an AMPL environment. The default path is `/Applications/ampl` and assumes you have an AMPL binary installed here.

``` r
library(AMPL)
ampl <- ampl_env()
```

Next, we will point to the location of the model and data files. This package includes the AMPL book's example models so we'll use its "steel" model:

``` r
model_file <- system.file("models/steel.mod", package = "AMPL")
data_file <- system.file("models/steel.dat", package = "AMPL")
```

Finally, run the model:

``` r
ampl <- set_solver(ampl, "/Applications/ampl/cplex")
ampl <- read_model(ampl, model_file)
ampl <- read_data(ampl, data_file)
ampl <- solve_model(ampl)
ampl$close()
```

Using the `magrittr` pipe to chain commands, this can be executed without continuously repeating assignment:

``` r
ampl <- ampl_env() %>%
  set_solver("/Applications/ampl/cplex") %>%
  read_model(model_file) %>%
  read_data(data_file) %>%
  solve_model()
steel_results <- get_data_all(ampl)
ampl$close()

steel_results$Parameters$market
#>     PROD market
#> 1: bands   6000
#> 2: coils   4000
steel_results$Variables
#>     PROD Make
#> 1: bands 6000
#> 2: coils 1400
steel_results$Objectives
#> Total_Profit 
#>       192000
```
