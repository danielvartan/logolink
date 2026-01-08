testthat::test_that("`find_netlogo_version()` | General test", {
  netlogo_console_backup <- Sys.getenv("NETLOGO_CONSOLE")

  test_file <- tempfile() |> fs::path_expand()
  test_file |> file.create()

  Sys.setenv("NETLOGO_CONSOLE" = test_file)

  testthat::local_mocked_bindings(
    system_2 = function(...) "9.9.9",
  )

  find_netlogo_version() |>
    testthat::expect_equal("9.9.9")

  Sys.setenv("NETLOGO_CONSOLE" = "")

  testthat::local_mocked_bindings(
    find_netlogo_home = function(...) "9.9.9",
  )

  find_netlogo_version() |>
    testthat::expect_equal("9.9.9")

  Sys.setenv("NETLOGO_CONSOLE" = "")

  testthat::local_mocked_bindings(
    find_netlogo_home = function(...) NA_character_,
  )

  find_netlogo_version() |>
    testthat::expect_equal(NA_character_) |>
    suppressMessages()

  Sys.setenv("NETLOGO_CONSOLE" = netlogo_console_backup)
})

testthat::test_that("`find_netlogo_version()` | Message test", {
  netlogo_console_backup <- Sys.getenv("NETLOGO_CONSOLE")

  # if (is.na(out)) {

  Sys.setenv("NETLOGO_CONSOLE" = "")

  testthat::local_mocked_bindings(
    find_netlogo_home = function(...) NA_character_,
  )

  find_netlogo_version() |>
    testthat::expect_message()

  Sys.setenv("NETLOGO_CONSOLE" = netlogo_console_backup)
})
