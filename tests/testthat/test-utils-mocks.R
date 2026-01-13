# `base`

testthat::test_that("`require_namespace()` | General test", {
  require_namespace("base") |>
    testthat::expect_equal(require_namespace("base"))
})

testthat::test_that("`sys_info()` | General test", {
  sys_info() |> checkmate::expect_character()
})

testthat::test_that("`system_2()` | General test", {
  system_2() |> testthat::expect_error()
})

testthat::test_that("`temp_dir()` | General test", {
  temp_dir() |> checkmate::expect_string()
})

testthat::test_that("`temp_file()` | General test", {
  temp_file() |> checkmate::expect_string()
})

## `fs`

testthat::test_that("`path()` | General test", {
  path("test") |>
    testthat::expect_equal(fs::path("test"))
})

testthat::test_that("`path_expand()` | General test", {
  path_expand("test") |>
    testthat::expect_equal(fs::path_expand("test"))
})

## `httr2`

testthat::test_that("`is_online()` | General test", {
  is_online() |> testthat::expect_equal(httr2::is_online())
})

testthat::test_that("`resp_body_json()` | General test", {
  resp_body_json() |> testthat::expect_error()
})

testthat::test_that("`resp_body_string()` | General test", {
  resp_body_string() |> testthat::expect_error()
})

testthat::test_that("`req_perform()` | General test", {
  req_perform() |> testthat::expect_error()
})
