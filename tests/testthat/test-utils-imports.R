testthat::test_that("require_pkg() | general test", {
  "base" |>
    require_pkg() |>
    testthat::expect_null()

  "test65464564" |>
    require_pkg() |>
    testthat::expect_error()

  require_pkg("test1654654", "test265464564") |>
    testthat::expect_error()

  mock <- function(.parent = parent.frame(), .env = topenv(.parent)) {
    mockr::with_mock(
      require_namespace = function(...) TRUE,
      {
        require_pkg("test")
      }
    )
  }

  testthat::expect_null(mock())
})

testthat::test_that("require_pkg() | error test", {
  # lapply(out, checkmate::assert_string,
  #        pattern = "^[A-Za-z][A-Za-z0-9.]+[A-Za-z0-9]$")
  1 |>
    require_pkg() |>
    testthat::expect_error("Assertion on 'X\\[\\[i\\]\\]' failed")

  ".test" |>
    require_pkg() |>
    testthat::expect_error("Assertion on 'X\\[\\[i\\]\\]' failed")

  # (!identical(unique(unlist(out)), unlist(out)))
  require_pkg("test", "test") |>
    testthat::expect_error("'...' cannot have duplicated values.")
})
