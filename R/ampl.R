#' Set Option
#'
#' Set an AMPL option to a specified value.
#'
#' @inheritParams read
#' @param name Character Name of the option to be set (alphanumeric without spaces)
#' @param value Character The value the option must be set to.
#'
#' @export
set_option <- function(ampl, name, value) {
  call_python(ampl, "setOption", name, value)
  ampl
}

#' Set Solver
#'
#' Set the current model solver.
#'
#' @inheritParams read
#' @param solver_path Character Path to the solver executable
#'
#' @export
set_solver <- function(ampl, solver_path) {
  set_option(ampl, "solver", solver_path)
  ampl
}

#' Read
#'
#' Interprets the specified file.
#' As a side effect, it invalidates all entities
#' (as the passed file can contain any arbitrary command);
#' the lists of entities will be re-populated lazily
#' (at first access).
#'
#' `read_model` accepts a script or model or mixed.
#'
#' `read_data` accepts an AMPL data file. After reading
#' the file the interpreter is put back to "model" mode.
#'
#' @param ampl `amplpy.ampl.AMPL` object
#' @param filename Full path to the file.
#' @param cd Logical indicating whether to run the file
#' in its directory to allow for relative path names.
#' `FALSE` will cause AMPL to `read` in its current working
#' directory. Defaults to `TRUE`.
#'
#' @return amplpy.ampl.AMPL object
#'
#' @name read
#' @export
read <- function(ampl, filename, cd = TRUE) {
  if (cd) {
    pwd <- display(ampl, "_cd")
    call_python(ampl, "cd", dirname(filename))
    on.exit(call_python(ampl, "cd", pwd))
  }
  call_python(ampl, "read", filename)
  ampl
}

#' @rdname read
#' @export
read_model <- read

#' @rdname read
#' @export
read_data <- function(ampl, filename, cd = TRUE) {
  if (cd) {
    pwd <- display(ampl, "_cd")
    call_python(ampl, "cd", dirname(filename))
    on.exit(call_python(ampl, "cd", pwd))
  }
  call_python(ampl, "readData", filename)
  ampl
}


#' Evaluate
#'
#' Parses AMPL code and evaluates it as a possibly empty sequence of AMPL
#' declarations and statements.
#'
#' As a side effect, it invalidates all entities (as the passed statements
#' can contain any arbitrary command); the lists of entities will be
#' re-populated lazily (at first access).
#'
#' The output of interpreting the statements is passed to the current
#' OutputHandler (see getOutputHandler and setOutputHandler).
#'
#' By default, errors are reported as exceptions and warnings are printed
#' on stdout. This behavior can be changed reassigning an ErrorHandler
#' using setErrorHandler.
#'
#' @inheritParams read
#' @param amplstatements A collection of AMPL statements and declarations to
#' be passed to the interpreter.
#'
#' @export
evaluate <- function(ampl, amplstatements) {
  call_python(ampl, "eval", amplstatements)
  ampl
}

#' Use Objective
#'
#' Sets an objective function as the current model context
#'
#' Call this function if your model has multiple objectives defined in
#' order to switch between them. This only alters the state of the model
#' environment and doesn't execute the solver.
#'
#' @inheritParams read
#' @param objective Character name of the objective function to be solved
#'
#' @export
use_objective <- function(ampl, objective) {
  evaluate(ampl, paste0('objective ', objective, ';'))
}

#' @export
solve_model <- function(ampl) {
  call_python(ampl, "solve")
  ampl
}

#' @importFrom purrr map
#' @export
get_data_all <- function(ampl) {
  model_names <- get_names_all(ampl, c("Parameters", "Variables",
                                       "Constraints", "Objectives"))
  #TODO return additional information from display using getValues
  #     eg. bounds, reduced costs, slack, dual...
  purrr::map(model_names, ~ get_data(ampl, .x))
}

#' @export
get_names_sets <- function(ampl) {
  .get_names(ampl, "_SETS")
}

#' @export
get_names_params <- function(ampl) {
  .get_names(ampl, "_PARS")
}

#' @export
get_names_vars <- function(ampl) {
  .get_names(ampl, "_VARS")
}

#' @export
get_names_all <- function(ampl,
                          entity_type = c("Sets", "Parameters", "Variables",
                                          "Constraints", "Objectives")) {
  stopifnot(entity_type %in% as.character(entity_names))

  entity_list <- lapply(reverse_list_lookup(entity_names, entity_type),
                        function(x) .get_names(ampl, x))
  names(entity_list) <- entity_type
  entity_list
}



