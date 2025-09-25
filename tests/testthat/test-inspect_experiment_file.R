test_that("`inspect_experiment_file()` | General test", {
  create_experiment(name = "My Experiment") |>
    inspect_experiment_file() |>
    expect_output(regexp = "<experiment")
})

test_that("`inspect_experiment_file()` | Error test", {
  # checkmate::assert_string(file)

  inspect_experiment_file(1) |>
    expect_error()

  # checkmate::assert_file_exists(file, access = "r", extension = "xml")

  inspect_experiment_file(tempfile(fileext = ".txt")) |>
    expect_error()
})
