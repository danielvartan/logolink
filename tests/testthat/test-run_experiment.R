testthat::test_that("`run_experiment()` | General test", {
  model_path <- tempfile(fileext = ".nlogox")
  setup_file <- tempfile(pattern = "experiment-", fileext = ".xml")
  table_file <- tempfile(pattern = "table-", fileext = ".csv")

  model_path |> file.create()
  setup_file |> file.create()
  table_file |> file.create()

  c(
    '"BehaviorSpace results (NetLogo 7.*.*)","Table version 2.0"',
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
    readr::write_lines(table_file)

  testthat::local_mocked_bindings(
    assert_netlogo_console = function(...) NULL,
    system_2 = function(...) "Test",
    run_experiment.gather_outputs = function(...) list(table_file)
  )

  run_experiment(
    model_path = model_path,
    setup_file = setup_file,
  ) |>
    checkmate::expect_list()
})

testthat::test_that("`run_experiment()` | Messages & Warnings test", {
  model_path <- tempfile(fileext = ".nlogox")
  setup_file <- tempfile(pattern = "experiment-", fileext = ".xml")
  table_file_1 <- tempfile(pattern = "table-", fileext = ".csv")
  table_file_2 <- tempfile(pattern = "table-", fileext = ".csv")

  model_path |> file.create()
  setup_file |> file.create()
  table_file_1 |> file.create()
  table_file_2 |> file.create()

  dplyr::tibble(a = 1:10, b = 1:10) |> readr::write_csv(table_file_1)

  dplyr::tibble(a = character(), b = character()) |>
    readr::write_csv(table_file_2)

  # if (!length(system2_output) == 0) {

  testthat::local_mocked_bindings(
    assert_netlogo_console = function(...) NULL,
    system_2 = function(...) "Test",
    run_experiment.gather_outputs = function(...) list()
  )

  run_experiment(
    model_path = model_path,
    setup_file = setup_file
  ) |>
    testthat::expect_message(
      regexp = "The experiment run produced the following messages"
    ) |>
    suppressMessages() |>
    suppressWarnings()

  # if (status == 124) {

  testthat::local_mocked_bindings(
    assert_netlogo_console = function(...) NULL,
    system_2 = function(...) `attributes<-`(NULL, list(status = 124)),
    run_experiment.gather_outputs = function(...) list()
  )

  run_experiment(
    model_path = model_path,
    setup_file = setup_file,
    timeout = 1
  ) |>
    testthat::expect_message(
      regexp = "The experiment timed out after."
    ) |>
    suppressMessages() |>
    suppressWarnings()
})

testthat::test_that("`run_experiment()` | Error test", {
  model_path_1 <- tempfile(fileext = ".nlogox")
  model_path_2 <- tempfile(fileext = ".txt")
  setup_file <- tempfile(pattern = "experiment-", fileext = ".xml")
  table_file_1 <- tempfile(pattern = "table-", fileext = ".csv")
  table_file_2 <- tempfile(pattern = "table-", fileext = ".csv")

  model_path_1 |> file.create()
  model_path_2 |> file.create()
  setup_file |> file.create()
  table_file_1 |> file.create()
  table_file_2 |> file.create()

  dplyr::tibble(a = 1:10, b = 1:10) |> readr::write_csv(table_file_1)

  dplyr::tibble(a = character(), b = character()) |>
    readr::write_csv(table_file_2)

  # checkmate::assert_string(model_path)

  run_experiment(
    model_path = 1,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE,
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # checkmate::assert_file_exists(model_path)

  run_experiment(
    model_path = tempfile(fileext = ".nlogox"),
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE,
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # checkmate::assert_choice(fs::path_ext(model_path), model_path_choices)

  run_experiment(
    model_path = model_path_2,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE,
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(experiment, null.ok = TRUE)

  run_experiment(
    model_path = model_path_1,
    experiment = 1,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE,
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(setup_file, null.ok = TRUE)

  run_experiment(
    model_path = model_path_1,
    experiment = NULL,
    setup_file = 1,
    other_arguments = NULL,
    parse = FALSE,
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # if (!is.null(setup_file)) { [...]

  run_experiment(
    model_path = model_path_1,
    experiment = NULL,
    setup_file = tempfile(fileext = ".xml"),
    other_arguments = NULL,
    parse = FALSE,
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(other_arguments, null.ok = TRUE)

  run_experiment(
    model_path = model_path_1,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = 1,
    parse = FALSE,
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(parse)

  run_experiment(
    model_path = model_path_1,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = "",
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # checkmate::assert_number(timeout, lower = 0)

  run_experiment(
    model_path = model_path_1,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = TRUE,
    timeout = "a",
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # if (is.null(experiment) && is.null(setup_file)) { [...]

  run_experiment(
    model_path = model_path_1,
    experiment = NULL,
    setup_file = NULL,
    other_arguments = NULL,
    parse = FALSE,
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # if (!is.null(experiment) && !is.null(setup_file)) { [...]

  run_experiment(
    model_path = model_path_1,
    experiment = "Test",
    setup_file = setup_file,
    other_arguments = NULL,
    parse = FALSE,
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error()

  # if (!is.null(status)) { [...] } else {

  testthat::local_mocked_bindings(
    assert_netlogo_console = function(...) NULL,
    system_2 = function(...) `attributes<-`("Test", list(status = 5)),
    temp_file = function(...) table_file_1
  )

  run_experiment(
    model_path = model_path,
    experiment = NULL,
    setup_file = setup_file,
    other_arguments = NULL,
    parse = TRUE,
    timeout = Inf,
    tidy_outputs = TRUE,
    netlogo_home = Sys.getenv("NETLOGO_HOME"),
  ) |>
    testthat::expect_error() |>
    suppressMessages() |>
    suppressWarnings()
})
