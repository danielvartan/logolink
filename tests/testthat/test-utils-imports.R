testthat::test_that("require_package() | General test", {
  "base" |>
    require_package() |>
    testthat::expect_null()

  "a.package.that.does.not.exist" |>
    require_package() |>
    testthat::expect_error()

  require_package(
    "a.package.that.does.not.exist",
    "another.non.existent.package"
  ) |>
    testthat::expect_error()

  testthat::local_mocked_bindings(
    require_namespace = function(...) TRUE
  )

  require_package("test") |>
    testthat::expect_null()
})

testthat::test_that("require_package() | Error test", {
  # lapply(out, checkmate::assert_string, ...

  1 |>
    require_package() |>
    testthat::expect_error("Assertion on 'X\\[\\[i\\]\\]' failed")

  ".test" |>
    require_package() |>
    testthat::expect_error("Assertion on 'X\\[\\[i\\]\\]' failed")

  # if (!identical(unique(unlist(out)), unlist(out)))

  require_package("test", "test") |>
    testthat::expect_error()
})
