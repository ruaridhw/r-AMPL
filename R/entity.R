
#' Display
#'
#' Low-level function equivalent to the AMPL call
#'
#' `display ds1, ..., dsn;`
#'
#' where `ds1, ..., dsn` are given as the parameter `statements` here.
#'
#' @inheritParams read
#' @param statements Character. The display statements to be fetched.
#' Can return more than one model entity provided they are defined
#' over the same indexing sets (See Details.)
#'
#' @return data.table containing the resulting display command
#' in tabular form.
#'
#' @details As AMPL only returns one table, the operation will fail if the
#' results of the display statements cannot be indexed over the same set.
#' As a result, any attempt to get data from more than one set, or to get
#' data for multiple parameters with a different number of indexing sets
#' will fail.
#'
#' @export
display <- function(ampl, entity) {
  ampldf <- call_python(ampl, "getData", entity)
  ampldf_to_r(ampldf, entity)
}

#' @importFrom data.table rbindlist
#' @importFrom magrittr %>% %<>%
ampldf_to_r <- function(ampldf, entity) {
  dt <- amplpy$DataFrame$toList(ampldf)
  if (ampldf$getNumCols() == 1) {
    dt %<>% unlist %>% unname
    #names(dt) <- ampldf$getHeaders() %>% unlist
  } else {
    dt %<>% data.table::rbindlist()
    headers <- ampldf$getHeaders() %>% unlist
    e <- get_entity(ampl, entity)
    indexing_sets <- extract_set_expr(e$getIndexingSets())
    headers[1:length(indexing_sets)] <- indexing_sets
    names(dt) <- headers
  }
  dt
}

#' @export
get_entity <- function(ampl, entity_name) {
  call_python(ampl, "getEntity", entity_name)
}

#' @importFrom stringr str_match
get_entity_type <- function(ampl, entity_name) {
  entity_type <- reverse_list_lookup_n(get_names_all(ampl), entity_name)
  types <- c("Parameter", "Variable", "Constraint", "Objective", "Set")

  matches <- stringr::str_match(entity_type, types)
  types[!is.na(matches)]
}

entity_default_values <- function(entity) {
  entity_type <- get_entity_type(ampl, entity_name)
  entity_suffixes_defaults[[entity_type]]
}

.get_values <- function(ampl, entity, values = entity_default_values(entity)) {
  e <- get_entity(ampl, entity)
  ampl_df <- call_python(e, "getValues", values)
  ampldf_to_r(ampldf, entity)
}

#' @export
get_values <- function(ampl, entity) {
  map_entities(ampl, entity, .get_values)
}

#' @importFrom purrr map
map_entities <- function(ampl, entity, f) {
  if (length(entity) == 1) {
    return(f(ampl, entity))
  }
  names(entity) <- entity
  purrr::map(entity, ~ f(ampl, .x))
}


.get_data <- function(ampl, entity) {
  dt <- display(ampl, entity)
  e <- get_entity(ampl, entity)
  names(dt) <- if (e$isScalar()) {
    entity
  } else {
    indexing_sets <- extract_set_expr(e$getIndexingSets())
    c(indexing_sets, entity)
  }
  dt
}

#' @export
get_data <- function(ampl, entity) {
  map_entities(ampl, entity, .get_data)
}


.get_names <- function(ampl, entity) {
  stopifnot(entity %in% names(entity_names))
  dt <- display(ampl, entity)
  dt
}

entity_names <- list(
  "_SETS" = "Sets",
  "_PARS" = "Parameters",
  "_VARS" = "Variables",
  "_CONS" = "Constraints",
  "_OBJS" = "Objectives",
  "_PROBS" = "Problem Names",
  "_ENVS" = "Environments",
  "_FUNCS" = "User-Defined Functions")

entity_suffixes <- list(
  "Variable" = c(
    "astatus",
    "init",
    "init0",
    "lb",
    "lb0",
    "lb1",
    "lb2",
    "lrc",
    "lslack",
    "rc",
    "relax",
    "slack",
    "sstatus",
    "status",
    "ub",
    "ub0",
    "ub1",
    "ub2",
    "urc",
    "uslack",
    "val"
  ),
  "Constraint" = c(
    "astatus",
    "body",
    "dinit",
    "dinit0",
    "dual",
    "lb",
    "lbs",
    "ldual",
    "lslack",
    "slack",
    "sstatus",
    "status",
    "ub",
    "ubs",
    "udual",
    "uslack"
  ),
  "Objective" = "val",
  "Parameter" = "val"
)

entity_suffixes_defaults <- list(
  "Variable" = c(
    "rc",
    "relax",
    "slack",
    "val"
  ),
  "Constraint" = c(
    "body",
    "dual"
  ),
  "Objective" = "val",
  "Parameter" = "val"
)
