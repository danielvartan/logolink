test_that("`system_2()` | General test", {
  system_2() |> expect_error()
})

test_that("`temp_file()` | General test", {
  library(checkmate)

  temp_file() |> expect_string()
})
