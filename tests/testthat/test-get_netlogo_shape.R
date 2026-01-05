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
    require_pkg = function(...) NULL,
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
    require_pkg = function(...) NULL,
    assert_internet = function(...) NULL
  )

  get_netlogo_shape(
    shape = 1,
    collection = "test",
    dir = tempdir(),
    auth_token = "test"
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(collection)

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL,
    assert_internet = function(...) NULL
  )

  get_netlogo_shape(
    shape = "test",
    collection = 1,
    dir = tempdir(),
    auth_token = "test"
  ) |>
    testthat::expect_error()

  # checkmate::assert_directory_exists(dir)

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL,
    assert_internet = function(...) NULL
  )

  get_netlogo_shape(
    shape = "test",
    collection = "test",
    dir = "non_existent_directory",
    auth_token = "test"
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(auth_token)

  testthat::local_mocked_bindings(
    require_pkg = function(...) NULL,
    assert_internet = function(...) NULL
  )

  get_netlogo_shape(
    shape = "test",
    collection = "test",
    dir = tempdir(),
    auth_token = 1
  ) |>
    testthat::expect_error()
})
