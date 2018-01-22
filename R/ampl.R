#' @export
set_option <- function(ampl, solver, solver_path) {
  call_python(ampl, "setOption", solver, solver_path)
}

#' @export
read_model <- function(ampl, fileName) {
  call_python(ampl, "read", fileName)
}

#' @export
read_data <- function(ampl, fileName) {
  call_python(ampl, "readData", fileName)
}

#' @export
evaluate <- function(ampl, amplstatements) {
  call_python(ampl, "eval", amplstatements)
}

#' @export
set_objective <- function(ampl, objective) {
  evaluate(ampl, paste0('objective ', objective, ';'))
}
