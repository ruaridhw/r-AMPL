#' AMPL Environment
#'
#' Creates a new AMPL model
#'
#' As this function instantiates a new background AMPL
#' process, if you only require one model environment at
#' a time, use `reset` to clear the current process
#' instead.
#'
#' @param amplpy `python.builtin.module` AMPLPY module
#' @param ampl_path Character Path to AMPL executable
#'
#' @importFrom reticulate import
#' @export
new_ampl_env <- function(amplpy = import("amplpy"),
                         ampl_path = "/Applications/ampl") {
  amplpy$AMPL(amplpy$Environment(ampl_path))
}
