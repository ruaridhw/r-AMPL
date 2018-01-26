call_python <- function(python_module, attribute, ...) {
  do.call(python_module[[attribute]], list(...))
}
