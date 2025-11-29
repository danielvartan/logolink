testthat::test_that("`test_nested_list()` | General test", {
  list(1, 1) |>
    test_nested_list() |>
    testthat::expect_false()

  list(1, 1:2) |>
    test_nested_list() |>
    testthat::expect_true()

  "a" |>
    test_nested_list() |>
    testthat::expect_false()
})

testthat::test_that("`test_one_depth_list()` | General test", {
  list(1, 2, 3) |>
    test_one_depth_list() |>
    testthat::expect_true()

  list(list(1, 2, 3)) |>
    test_one_depth_list() |>
    testthat::expect_false()
})

testthat::test_that("`test_same_class()` | General test", {
  list(1, 2, 3) |>
    test_same_class() |>
    testthat::expect_true()

  list("a", 1, "c") |>
    test_same_class() |>
    testthat::expect_false()
})

testthat::test_that("`test_unitary_list()` | General test", {
  list(1, 2, 3) |>
    test_unitary_list() |>
    testthat::expect_true()

  list(1, 2:5, 3) |>
    test_unitary_list() |>
    testthat::expect_false()
})
