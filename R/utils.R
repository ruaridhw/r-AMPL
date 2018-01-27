#' @param python_module python.builtin.module Object
#' @param attribute Attribute/Method etc of `python_module`
#' @param ... Arguments passed to `attribute`
#'
#' @importFrom reticulate py_validate_xptr
#' @noRd
call_python <- function(python_module, attribute, ...) {
  py_validate_xptr(python_module)
  do.call(python_module[[attribute]], list(...))
}

#' @param lookup List with all elements length 1
#' @param x Vector with elements as the values of `lookup`
#'
#' @return Vector with elements as the names of `lookup`
#' corresponding to each value of `x`
#' @noRd
reverse_list_lookup <- function(lookup, x) {
  names(lookup)[match(x, unlist(lookup))]
}
