library(testthat)

context("Environment")

test_that("AMPL session exists; ampl_env", {
  on.exit(close_ampl_sessions)
  expect_null(.globals$sessions)
  ampl <- ampl_env()
  expect_true(ampl$isRunning())
  expect_false(is.null(.globals$sessions))
  expect_length(.globals$sessions, 1)
})

test_that("AMPL session exits; close_ampl_sessions", {
  on.exit(close_ampl_sessions)
  ampl <- ampl_env()
  close_ampl_sessions()
  expect_false(ampl$isRunning())
})
