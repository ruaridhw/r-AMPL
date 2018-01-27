library(testthat)

context("Utility Functions")

test_that("Modules are called correctly; call_python", {
  builtins <- reticulate::import_builtins()
  x <- builtins %>% call_python("ascii", "string")
  expect_identical(x, builtins$ascii("string"))
  x <- r_to_py(x)
  expect_equal(call_python(x, "index", "r"), x$index("r"))
  #TODO why does expect_identical fail: "Objects equal but not identical"

  x <- call_python(builtins, "list", 1:3)
  expect_identical(x, builtins$list(1:3))
})

test_that("Lookup list headers; reverse_list_lookup", {
  lookup <- list(
    "ONE" = "a",
    "TWO" = "b",
    "THREE" = "c")
  x <- "a"
  expect_equal(reverse_list_lookup(lookup, x), "ONE")
  x <- c("b", "c")
  expect_equal(reverse_list_lookup(lookup, x), c("TWO", "THREE"))
  x <- unlist(lookup)
  expect_equal(reverse_list_lookup(lookup, x), names(lookup))
})

test_that("Lookup headers from list with varying length elements", {
  lookup <- list(
    "ONE" = "a",
    "TWO" = c("b1", "b2"),
    "THREE" = c("c1", "c2", "c3"))
  x <- "a"
  expect_equal(reverse_list_lookup_n(lookup, x), "ONE")
  x <- "b2"
  expect_equal(reverse_list_lookup_n(lookup, x), "TWO")
  x <- "c3"
  expect_equal(reverse_list_lookup_n(lookup, x), "THREE")

  #TODO
  # expect_failure(reverse_list_lookup_n(lookup, "c4"))
  # expect_failure(reverse_list_lookup_n(lookup, c("b1", "b2")))
  # expect_failure(reverse_list_lookup_n(lookup, c("a", "c1")))
})

test_that("Sets are correctly extracted from indexing expressions; extract_set_expr", {
  pairs_to_test <-
    c("A" = "A",
      "j in B" = "B",
      "C[i]" = "C",
      "(j,k) in D" = "D",
      "i in A: p[i] > 0" = "A",
      "j in C[i]: i <= j" = "C",
      "(i,j) in D: i <= j" = "D",
      "i in A: ord(j,\n B) > 1" = "A")
  set_exprs <- names(pairs_to_test)
  vals <- unname(pairs_to_test)
  expect_equal(extract_set_expr(set_exprs), vals)
})
