testthat::test_that("`find_netlogo_home()` | General test", {
  netlogo_home_backup <- Sys.getenv("NETLOGO_HOME")

  Sys.setenv("NETLOGO_HOME" = ".")

  find_netlogo_home() |>
    testthat::expect_equal(
      "." |>
        normalizePath() |>
        fs::path_expand()
    )

  Sys.setenv("NETLOGO_HOME" = "")

  for (i in c("", "windows", "linux", "darwin", "macos")) {
    testthat::local_mocked_bindings(
      sys_info = function(...) c(sysname = i),
      path = function(...) ".",
      path_expand = function(...) "test"
    )

    find_netlogo_home() |>
      testthat::expect_equal("test")
  }

  Sys.setenv("NETLOGO_HOME" = netlogo_home_backup)
})
