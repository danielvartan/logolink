testthat::test_that("`parse_netlogo_list()` | Scalar test", {
  "a" |>
    parse_netlogo_list() |>
    testthat::expect_equal("a")

  '[1]' |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(1L))

  '["a" "b" "c"]' |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(c("a", "b", "c")))

  '[1 2 3]' |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(1:3))

  '[1.1 2.1 3.1]' |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(c(1.1, 2.1, 3.1)))

  '[true false true]' |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(c(TRUE, FALSE, TRUE)))

  "[NaN]" |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(c("NaN")))
})

testthat::test_that("`parse_netlogo_list()` | Vector test", {
  c("a", "b") |>
    parse_netlogo_list() |>
    testthat::expect_equal(c("a", "b"))

  c('["a" "b" "c"]', '["d" "e" "f"]') |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(c("a", "b", "c"), c("d", "e", "f")))

  c('[1 2 3]', '[4 5 6]') |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(1:3, 4:6))

  c('[1.1 2.1 3.1]', '[4.1 5.1 6.1]') |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(c(1.1, 2.1, 3.1), c(4.1, 5.1, 6.1)))

  c('[true false true]', '[false true false]') |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(c(TRUE, FALSE, TRUE), c(FALSE, TRUE, FALSE)))
})

testthat::test_that("`parse_netlogo_list()` | Combined test", {
  c('["a" "b" "c"]', '[4 5 6]') |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(c("a", "b", "c"), 4:6))

  c('[1.1 2.1 3.1]', '[true false true]')  |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(c(1.1, 2.1, 3.1), c(TRUE, FALSE, TRUE)))

  c('[1.1 "a" true]') |>
    parse_netlogo_list() |>
    testthat::expect_equal(list(list(1.1, "a", TRUE)))
})

testthat::test_that("`parse_netlogo_list()` | Nested test", {
  c('["a" "b" "c" [1 2]]', '[4 5 6]')|>
    parse_netlogo_list() |>
    testthat::expect_equal(list(list(c("a", "b", "c"), 1:2), 4:6))

  c('["a" "b" "c" [1 2] true ["d" "c"]]')  |>
    parse_netlogo_list() |>
    testthat::expect_equal(
      list(list(c("a", "b", "c"), 1:2, TRUE, c("d", "c")))
    )
})

testthat::test_that("`parse_netlogo_list()` | Error test", {
  # checkmate::assert_atomic(x)

  list(a = 1, b = 2) |>
    parse_netlogo_list() |>
    testthat::expect_error()
})

testthat::test_that("`parse_netlogo_list.scalar()` | Error test", {
  # checkmate::assert_atomic(x)

  list(a = 1, b = 2) |>
    parse_netlogo_list() |>
    testthat::expect_error()
})
