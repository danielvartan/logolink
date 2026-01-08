testthat::test_that("`get_netlogo_shape()` | Internet test", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if_offline()

  user_agent <- "logolink (Test) <https://CRAN.R-project.org/package=logolink>"

  results <-
    get_netlogo_shape(
      shape = c("wolf", "sheep"),
      collection = "netlogo-refined",
      dir = tempdir(),
      user_agent = user_agent,
      auth_token = Sys.getenv("GH_TOKEN")
    )

  results |>
    checkmate::expect_character(len = 2)

  results |>
    magrittr::extract(1) |>
    file.exists() |>
    testthat::expect_true()

  results |>
    magrittr::extract(1) |>
    readLines(n = 2) |>
    magrittr::extract(2) |>
    checkmate::expect_string(pattern = "<svg")

  results <-
    get_netlogo_shape(
      shape = c("person-business", "person-construction"),
      collection = "netlogo-7-0-3",
      dir = tempdir(),
      user_agent = user_agent,
      auth_token = Sys.getenv("GH_TOKEN")
    )

  results |>
    checkmate::expect_character(len = 2)

  results |>
    magrittr::extract(1) |>
    file.exists() |>
    testthat::expect_true()

  results |>
    magrittr::extract(1) |>
    readLines(n = 2) |>
    magrittr::extract(2) |>
    checkmate::expect_string(pattern = "<svg")
})

testthat::test_that("`get_netlogo_shape()` | General test", {
  fake_api_response <- paste0(
    '[',
    '\n',
    '  {',
    '\n',
    '    \"name\": \"test\",',
    '\n',
    '    \"download_url\": \"https://test.com\"',
    '\n',
    '  }',
    '\n',
    ']'
  )

  list_response <- list(
    list(
      name = "test_1",
      download_url = "https://test1.com"
    ),
    list(
      name = "test_2",
      download_url = "https://test2.com"
    )
  )

  testthat::local_mocked_bindings(
    require_package = function(...) NULL,
    assert_internet = function(...) NULL,
    req_perform = function(...) NULL,
    resp_body_json = function(...) list_response,
    resp_body_string = function(...) "<svg>Test</svg>"
  )

  get_netlogo_shape(
    shape = c("test_1", "test_2"),
    collection = "test_1",
    dir = tempdir(),
    auth_token = "test"
  ) |>
    testthat::expect_type("character")
})

testthat::test_that("`get_netlogo_shape()` | Error test", {
  # checkmate::assert_character(shape, min.len = 1)

  testthat::local_mocked_bindings(
    require_package = function(...) NULL,
    assert_internet = function(...) NULL
  )

  get_netlogo_shape(
    shape = 1,
    collection = "test",
    dir = tempdir(),
    user_agent = "logolink <https://CRAN.R-project.org/package=logolink>",
    auth_token = Sys.getenv("GH_TOKEN")
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(collection)

  testthat::local_mocked_bindings(
    require_package = function(...) NULL,
    assert_internet = function(...) NULL
  )

  get_netlogo_shape(
    shape = "test",
    collection = 1,
    dir = tempdir(),
    user_agent = "logolink <https://CRAN.R-project.org/package=logolink>",
    auth_token = Sys.getenv("GH_TOKEN")
  ) |>
    testthat::expect_error()

  # checkmate::assert_directory_exists(dir)

  testthat::local_mocked_bindings(
    require_package = function(...) NULL,
    assert_internet = function(...) NULL
  )

  get_netlogo_shape(
    shape = "test",
    collection = "test",
    dir = "non_existent_directory",
    user_agent = "logolink <https://CRAN.R-project.org/package=logolink>",
    auth_token = Sys.getenv("GH_TOKEN")
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(user_agent)

  testthat::local_mocked_bindings(
    require_package = function(...) NULL,
    assert_internet = function(...) NULL
  )

  get_netlogo_shape(
    shape = "test",
    collection = "test",
    dir = tempdir(),
    user_agent = 1,
    auth_token = Sys.getenv("GH_TOKEN")
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(auth_token)

  testthat::local_mocked_bindings(
    require_package = function(...) NULL,
    assert_internet = function(...) NULL
  )

  get_netlogo_shape(
    shape = "test",
    collection = "test",
    dir = tempdir(),
    user_agent = "logolink <https://CRAN.R-project.org/package=logolink>",
    auth_token = 1
  ) |>
    testthat::expect_error()
})
