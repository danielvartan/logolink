testthat::test_that("`find_netlogo_console()` | General test", {
  netlogo_console_backup <- Sys.getenv("NETLOGO_CONSOLE")

  mock_file <- tempfile() |> fs::path_expand()
  file.create(mock_file)

  Sys.setenv("NETLOGO_CONSOLE" = ".")

  find_netlogo_console() |>
    testthat::expect_equal(
      "." |>
        normalizePath() |>
        fs::path_expand()
    )

  Sys.setenv("NETLOGO_CONSOLE" = "")

  for (i in c("", "windows", "linux", "darwin", "macos")) {
    testthat::local_mocked_bindings(
      sys_info = function(...) c(sysname = i),
      path_expand = function(...) ""
    )

    find_netlogo_console() |>
      testthat::expect_equal("")
  }

  Sys.setenv("NETLOGO_CONSOLE" = "")

  testthat::local_mocked_bindings(
    path = function(...) mock_file,
    path_expand = function(...) mock_file
  )

  find_netlogo_console() |>
    testthat::expect_equal(mock_file)

  Sys.setenv("NETLOGO_CONSOLE" = netlogo_console_backup)
})

testthat::test_that("`find_netlogo_console()` | Error test", {
  # checkmate::assert_string(netlogo_home)

  find_netlogo_console(
    netlogo_home = 1
  ) |>
    testthat::expect_error()
})
