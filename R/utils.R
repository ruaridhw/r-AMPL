call_python <- function(python_module, attribute, ...) {
  do.call(python_module[[attribute]], list(...))
}

reverse_list_lookup <- function(lookup, x) {
  names(lookup)[match(x, unlist(lookup))]
}
