
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

### Additional Info

**Configure Python**

If you installed `amplpy` using a Python installation other than the system default, such as `conda`, you can specify which version to use with a command similar to the following prior to loading `AMPL`:

``` r
reticulate::use_python("/Users/username/anaconda3/envs/my_env/bin/python")
```

**Configure AMPL**

The default `ampl` binary location is `/Applications/ampl` however if you have AMPLDev installed, you can use this binary instead:

``` r
ampl <- ampl_env("/Applications/AMPLDev.app/Contents/Resources/AMPL")
```

If you do this, there are a couple of steps to be aware of:

-   The AMPLDev binary must be licensed correctly otherwise R will crash. (In the future, this package will check this ahead of time and throw a warning). You can check this yourself by running the following in a Terminal:

    ``` bash
    cd /Applications/AMPLDev.app/Contents/Resources/AMPL
    ampl --version
    #> AMPL Version 20161231 (Darwin 10.8.0 x86_64)
    ```

    You cannot shortcut this step without the `cd` command due to OptiRisk's License Manager.

    If this doesn't work, ensure that the file `LICENSE.KEY` appears in both the *Resources* and *AMPL* directories.

-   Any paths inside your AMPL model files will need to be absolute paths rather than relative paths. The AMPL environment runs from inside the AMPLDev app so relative file paths will be evaluated against this directory which is almost certainly not the user's intention.
