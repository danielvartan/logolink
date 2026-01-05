testthat::test_that("`assert_internet()` | General test", {
  testthat::local_mocked_bindings(
    require_package = function(...) NULL,
    is_online = function(...) TRUE
  )

  assert_internet() |>
    testthat::expect_true()

  testthat::local_mocked_bindings(
    require_package = function(...) NULL,
    is_online = function(...) FALSE
  )

  assert_internet() |>
    testthat::expect_error()
})

testthat::test_that("`assert_netlogo_console()` | General test", {
  mock_file <- tempfile() |> fs::path_expand()
  file.create(mock_file)

  # if ((netlogo_console == "") || !file.exists(netlogo_console)) {

  testthat::local_mocked_bindings(
    path_expand = function(...) ""
  )

  assert_netlogo_console() |>
    testthat::expect_error()

  # if (inherits(test, "try-error")) {

  testthat::local_mocked_bindings(
    path_expand = function(...) mock_file,
    system_2 = function(...) "test" |> `class<-`("try-error"),
  )

  assert_netlogo_console() |>
    testthat::expect_error()

  testthat::local_mocked_bindings(
    path_expand = function(...) mock_file,
    system_2 = function(...) "test",
  )

  assert_netlogo_console() |>
    testthat::expect_true()
})

testthat::test_that("`assert_netlogo_console()` | Error test", {
  # checkmate::assert_string(netlogo_home)

  assert_netlogo_console(
    netlogo_home = 1
  ) |>
    testthat::expect_error()
})

testthat::test_that("`assert_other_arguments()` | General test", {
  assert_other_arguments(
    other_arguments = NULL,
    reserved_arguments = "a",
    null_ok = TRUE
  ) |>
    testthat::expect_true()

  assert_other_arguments(
    other_arguments = "a",
    reserved_arguments = "b",
    null_ok = FALSE
  ) |>
    testthat::expect_true()

  # if (length(conflict) > 0) {

  assert_other_arguments(
    other_arguments = "a",
    reserved_arguments = "a",
    null_ok = FALSE
  ) |>
    testthat::expect_error()
})

testthat::test_that("`assert_other_arguments()` | Error test", {
  # checkmate::assert_character(other_arguments, null.ok = TRUE)

  assert_other_arguments(
    other_arguments = 1,
    reserved_arguments = "a",
    null_ok = FALSE
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(reserved_arguments)

  assert_other_arguments(
    other_arguments = "a",
    reserved_arguments = 1,
    null_ok = FALSE
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(null_ok)

  assert_other_arguments(
    other_arguments = "a",
    reserved_arguments = "a",
    null_ok = "a"
  ) |>
    testthat::expect_error()
})

testthat::test_that("`assert_pick_one()` | General test", {
  assert_pick_one(
    x = NULL,
    y = NULL
  ) |>
    testthat::expect_error()

  assert_pick_one(
    x = 1,
    y = 1
  ) |>
    testthat::expect_error()

  assert_pick_one(
    x = 1,
    y = NULL
  ) |>
    testthat::expect_true()
})

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
