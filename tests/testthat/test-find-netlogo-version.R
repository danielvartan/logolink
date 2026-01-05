testthat::test_that("`find_netlogo_version()` | General test", {
  netlogo_home_backup <- Sys.getenv("NETLOGO_HOME")
  netlogo_console_backup <- Sys.getenv("NETLOGO_CONSOLE")

  mock_file <- tempfile() |> fs::path_expand()
  file.create(mock_file)

  Sys.setenv("NETLOGO_CONSOLE" = mock_file)

  testthat::local_mocked_bindings(
    system_2 = function(...) "9.9.9",
  )

  find_netlogo_version() |>
    testthat::expect_equal("9.9.9")

  Sys.setenv("NETLOGO_HOME" = "9.9.9")
  Sys.setenv("NETLOGO_CONSOLE" = "")

  find_netlogo_version() |>
    testthat::expect_equal("9.9.9")

  Sys.setenv("NETLOGO_HOME" = netlogo_home_backup)
  Sys.setenv("NETLOGO_CONSOLE" = netlogo_console_backup)
})
