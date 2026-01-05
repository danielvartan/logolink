testthat::test_that("`parse_netlogo_color()` | General test", {
  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = c(10, 25, 55, 100),
    bias = 0.1
  ) |>
    checkmate::expect_character(pattern = "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$")
})

testthat::test_that("`parse_netlogo_color()` | Bias adjustment test", {
  # Base Color

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 15,
    bias = 0.1
  ) |>
    testthat::expect_equal("#D73229")

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 15,
    bias = 0.5
  ) |>
    testthat::expect_equal("#D73229")

  # Dark Shade

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 12.5,
    bias = 0
  ) |>
    testthat::expect_equal("#711610")

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 12.5,
    bias = -0.5
  ) |>
    testthat::expect_equal("#480200")

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 12.5,
    bias = 0.5
  ) |>
    testthat::expect_equal("#98312D")

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  # Light Shade

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 17.5,
    bias = 0
  ) |>
    testthat::expect_equal("#FF9B98")

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 17.5,
    bias = -0.5
  ) |>
    testthat::expect_equal("#FF5B55")

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 17.5,
    bias = 0.5
  ) |>
    testthat::expect_equal("#FFCECE")
})

testthat::test_that("`parse_netlogo_color()` | Error test", {
  # checkmate::assert_numeric(x, lower = 0, upper = 140)

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = "a",
    bias = 0.1
  ) |>
    testthat::expect_error()

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = -1,
    bias = 0.1
  ) |>
    testthat::expect_error()

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 150,
    bias = 0.1
  ) |>
    testthat::expect_error()

  # checkmate::assert_number(bias, lower = -1, upper = 1)

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 15,
    bias = "a"
  ) |>
    testthat::expect_error()

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 15,
    bias = -2
  ) |>
    testthat::expect_error()

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL
  )

  parse_netlogo_color(
    x = 15,
    bias = 2
  ) |>
    testthat::expect_error()
})
