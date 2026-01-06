testthat::test_that("`inspect_experiment()` | General test", {
  create_experiment(name = "My Experiment") |>
    inspect_experiment() |>
    testthat::expect_output(regexp = "<experiment")
})

testthat::test_that("`inspect_experiment()` | Error test", {
  # checkmate::assert_string(file)

  inspect_experiment(1) |>
    testthat::expect_error()

  # checkmate::assert_file_exists(file, access = "r", extension = "xml")

  inspect_experiment(tempfile(fileext = ".txt")) |>
    testthat::expect_error()
})
