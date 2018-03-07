#' AMPL Environment
#'
#' Creates a new AMPL model
#'
#' As this function instantiates a new background AMPL
#' process, if you only require one model environment at
#' a time, use `reset` to clear the current process
#' instead.
#'
#' @param ampl_path Character Path to AMPL executable
#'
#' @export
ampl_env <- function(ampl_path = "/Applications/ampl") {
  if (grepl("AMPLDev.app", ampl_path)) {
    curr_dir <- getwd()
    setwd(ampl_path)
    on.exit(setwd(curr_dir), add = TRUE)
  }
  ampl <- amplpy$AMPL(amplpy$Environment(ampl_path))
  .globals$sessions <- c(.globals$sessions, ampl)
  ampl
}

close_ampl_sessions <- function() {
  if (!is.null(.globals$sessions)) {
    lapply(.globals$sessions, call_python, "close")
  }
}
