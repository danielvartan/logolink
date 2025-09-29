testthat::test_that("`system_2()` | General test", {
  system_2() |> testthat::expect_error()
})

testthat::test_that("`temp_file()` | General test", {
  temp_file() |> checkmate::expect_string()
})
