testthat::test_that("`find_netlogo_console()` | General test", {
  netlogo_console_backup <- Sys.getenv("NETLOGO_CONSOLE")

  mock_file <- tempfile() |> fs::path_expand()
  file.create(mock_file)

  Sys.setenv("NETLOGO_CONSOLE" = ".")

  testthat::local_mocked_bindings(
    find_netlogo_home = function(...) "",
  )

  find_netlogo_console() |>
    testthat::expect_equal(
      "." |>
        normalizePath() |>
        fs::path_expand()
    )

  Sys.setenv("NETLOGO_CONSOLE" = "")

  for (i in c("", "windows", "linux", "darwin", "macos")) {
    testthat::local_mocked_bindings(
      find_netlogo_home = function(...) "",
      sys_info = function(...) c(sysname = i),
      path = function(...) ""
    )

    find_netlogo_console() |>
      testthat::expect_equal("") |>
      suppressMessages()
  }

  Sys.setenv("NETLOGO_CONSOLE" = "")

  testthat::local_mocked_bindings(
    find_netlogo_home = function(...) "",
    path = function(...) mock_file,
    path_expand = function(...) mock_file
  )

  find_netlogo_console() |>
    testthat::expect_equal(mock_file)

  Sys.setenv("NETLOGO_CONSOLE" = netlogo_console_backup)
})

testthat::test_that("`find_netlogo_console()` | Message test", {
  netlogo_console_backup <- Sys.getenv("NETLOGO_CONSOLE")

  mock_file <- tempfile() |> fs::path_expand()
  file.create(mock_file)

  # if (netlogo_console != "" && !file.exists(netlogo_console)) {

  Sys.setenv("NETLOGO_CONSOLE" = "-non_existent_path-")

  testthat::local_mocked_bindings(
    find_netlogo_home = function(...) "",
    sys_info = function(...) c(sysname = "linux"),
    path = function(...) mock_file,
    path_expand = function(...) mock_file
  )

  find_netlogo_console() |>
    testthat::expect_message()

  # if (!file.exists(out)) {

  Sys.setenv("NETLOGO_CONSOLE" = "")

  testthat::local_mocked_bindings(
    find_netlogo_home = function(...) "",
    path = function(...) tempfile(),
  )

  find_netlogo_console() |>
    testthat::expect_message()

  Sys.setenv("NETLOGO_CONSOLE" = netlogo_console_backup)
})
