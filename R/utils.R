#' @param python_module python.builtin.module Object
#' @param attribute Attribute/Method etc of `python_module`
#' @param ... Arguments passed to `attribute`
#'
#' @importFrom reticulate py_validate_xptr
#' @noRd
call_python <- function(python_module, attribute, ...) {
  #py_validate_xptr(python_module)
  do.call(python_module[[attribute]], list(...))
}

#' @param lookup List with all elements length 1
#' @param x Vector with elements as the values of `lookup`
#'
#' @return Vector with elements as the names of `lookup`
#' corresponding to each value of `x`
#' @noRd
#TODO move this to `reverse_list_lookup_n` as a singular case
reverse_list_lookup <- function(lookup, x) {
  names(lookup)[match(x, unlist(lookup))]
}

#' @param lookup List with elements of varying length
#' @param x Character to `lookup`
#'
#' @return Character name of list header containing `x`
#' @noRd
reverse_list_lookup_n <- function(lookup, x) {
  re <- sprintf("^%s$", x)
  res <- purrr::map(lookup, ~ grep(re, .))
  which(purrr::map_lgl(res, ~ length(.) > 0)) %>% names
}

#TODO rewrite using library(rex)
.set_expr_re <- "(?s)^.*?(?:in)?\\s*(\\w+)\\s*(?:\\[[\\s\\w]+\\])?(?::.*)?$"

extract_set_expr <- function(expr) {
  stringr::str_match(expr, .set_expr_re)[,2]
}

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`
