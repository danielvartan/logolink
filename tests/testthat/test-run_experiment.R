test_that("`run_experiment()` | General test", {
  library(datasets)
  library(readr)

  model_path <- tempfile(fileext = ".nlogox")
  setup_file <- tempfile(pattern = "experiment-", fileext = ".xml")
  table_file <- tempfile(pattern = "table-", fileext = ".csv")

  model_path |> file.create()
  setup_file |> file.create()
  table_file |> file.create()

  c(
    '"BehaviorSpace results (NetLogo 7.0.0)","Table version 2.0"',
    paste0(
      '"/opt/netlogo-7-0-0/models/IABM Textbook/chapter 4/',
      'Wolf Sheep Simple 5.nlogox"'
    ),
    '"Wolf Sheep Simple Model Analysis"',
    '"09/25/2025 18:53:53:897 -0300"',
    '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
    '"-17","17","-17","17"',
    paste0(
      '"[run number]","number-of-sheep","number-of-wolves","movement-cost",',
      '"grass-regrowth-rate","energy-gain-from-grass",',
      '"energy-gain-from-sheep","[step]","count wolves","count sheep"'
    ),
    '"3","500","5","0.5","0.3","2","5","0","5","500"',
    '"9","500","5","0.5","0.3","2","5","0","5","500"',
    '"4","500","5","0.5","0.3","2","5","0","5","500"'
  ) |>
    writeLines(table_file)

  local_mocked_bindings(
    system_2 = function(...) "Test",
    temp_file = function(...) table_file
  )

  run_experiment(
    netlogo_path = "",
    model_path = model_path,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = TRUE
  ) |>
    expect_tibble(ncols = 10)

  run_experiment(
    netlogo_path = "",
    model_path = model_path,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE
  ) |>
    expect_tibble(ncols = 10)
})

test_that("`run_experiment()` | Error test", {
  library(checkmate)
  library(dplyr)
  library(readr)

  model_path_1 <- tempfile(fileext = ".nlogox")
  model_path_2 <- tempfile(fileext = ".txt")
  setup_file <- tempfile(pattern = "experiment-", fileext = ".xml")
  table_file <- tempfile(pattern = "table-", fileext = ".csv")

  model_path_1 |> file.create()
  model_path_2 |> file.create()
  setup_file |> file.create()
  table_file |> file.create()

  tibble(a = character(), b = character()) |> write_csv(table_file)

  # checkmate::assert_string(netlogo_path)

  run_experiment(
    netlogo_path = 1,
    model_path = model_path,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE
  ) |>
    expect_error()

  # checkmate::assert_string(model_path)

  run_experiment(
    netlogo_path = "",
    model_path = 1,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE
  ) |>
    expect_error()

  # checkmate::assert_file_exists(model_path)

  run_experiment(
    netlogo_path = "",
    model_path = tempfile(fileext = ".nlogox"),
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE
  ) |>
    expect_error()

  # checkmate::assert_choice(fs::path_ext(model_path), model_path_choices)

  run_experiment(
    netlogo_path = "",
    model_path = model_path_2,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE
  ) |>
    expect_error()

  # checkmate::assert_string(experiment, null.ok = TRUE)

  run_experiment(
    netlogo_path = "",
    model_path = model_path,
    experiment = 1,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE
  ) |>
    expect_error()

  # checkmate::assert_string(setup_file, null.ok = TRUE)

  run_experiment(
    netlogo_path = "",
    model_path = model_path,
    experiment = NULL,
    setup_file = 1,
    other_arguments = NULL,
    parse = FALSE
  ) |>
    expect_error()

  # if (!is.null(setup_file)) { [...]

  run_experiment(
    netlogo_path = "",
    model_path = model_path,
    experiment = NULL,
    setup_file = tempfile(),
    other_arguments = NULL,
    parse = FALSE
  ) |>
    expect_error()

  # checkmate::assert_character(other_arguments, null.ok = TRUE)

  run_experiment(
    netlogo_path = "",
    model_path = model_path,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = 1,
    parse = FALSE
  ) |>
    expect_error()

  # checkmate::assert_flag(parse)

  run_experiment(
    netlogo_path = "",
    model_path = model_path,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = ""
  ) |>
    expect_error()

  # if (is.null(experiment) && is.null(setup_file)) { [...]

  run_experiment(
    netlogo_path = "",
    model_path = model_path,
    experiment = NULL,
    setup_file = NULL,
    other_arguments = NULL,
    parse = FALSE
  ) |>
    expect_error()

  # if (!is.null(experiment) && !is.null(setup_file)) { [...]

  run_experiment(
    netlogo_path = "",
    model_path = model_path,
    experiment = "Test",
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE
  ) |>
    expect_error()

  # if (nrow(out) == 0) { [...]

  local_mocked_bindings(
    system_2 = function(...) "Test",
    temp_file = function(...) table_file
  )

  run_experiment(
    netlogo_path = "",
    model_path = model_path,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = TRUE
  ) |>
    expect_error()
})
