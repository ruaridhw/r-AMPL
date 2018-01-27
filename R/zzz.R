.globals <- new.env(parent = emptyenv())
.globals$sessions <- NULL

amplpy <- NULL

#' @importFrom reticulate import
.onLoad <- function(libname, pkgname) {
  amplpy <<- reticulate::import("amplpy", delay_load = TRUE)
}

.onUnload <- function(libpath) {
  close_ampl_sessions()
}
