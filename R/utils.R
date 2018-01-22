#' @importFrom reticulate py_call
call_python <- function(python_module, attribute, ...) {
  py_call(python_module[[attribute]], ...)
}
