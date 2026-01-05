testthat::test_that("`run_experiment()` | General test", {
  model_path_1 <- tempfile(fileext = ".nlogox")
  setup_file_1 <- tempfile(pattern = "experiment-", fileext = ".xml")

  model_path_1 |> file.create()
  setup_file_1 |> file.create()

  testthat::local_mocked_bindings(
    assert_netlogo_console = function(...) NULL,
    system_2 = function(...) "Test",
    run_experiment.gather_output = function(...) list()
  )

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    checkmate::expect_list() |>
    suppressMessages() |>
    suppressWarnings()
})

testthat::test_that("`run_experiment()` | Message test", {
  model_path_1 <- tempfile(fileext = ".nlogox")
  setup_file_1 <- tempfile(pattern = "experiment-", fileext = ".xml")

  model_path_1 |> file.create()
  setup_file_1 |> file.create()

  # if (!is.null(status)) { [...] } else {

  testthat::local_mocked_bindings(
    assert_netlogo_console = function(...) NULL,
    find_netlogo_console = function(...) NULL,
    system_2 = function(...) `attributes<-`(NULL, list(status = 124)),
    run_experiment.gather_output = function(...) NULL
  )

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_message() |>
    suppressMessages() |>
    suppressWarnings()

  # if (!length(system2_output) == 0) {

  testthat::local_mocked_bindings(
    assert_netlogo_console = function(...) NULL,
    find_netlogo_console = function(...) NULL,
    system_2 = function(...) "Test",
    run_experiment.gather_output = function(...) NULL
  )

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_message() |>
    suppressMessages() |>
    suppressWarnings()
})

testthat::test_that("`run_experiment()` | Error test", {
  netlogo_console_backup <- Sys.getenv("NETLOGO_CONSOLE")

  model_path_1 <- tempfile(fileext = ".nlogox")
  model_path_2 <- tempfile(fileext = ".txt")
  setup_file_1 <- tempfile(pattern = "experiment-", fileext = ".xml")
  setup_file_2 <- tempfile(pattern = "experiment-", fileext = ".txt")

  model_path_1 |> file.create()
  model_path_2 |> file.create()
  setup_file_1 |> file.create()
  setup_file_2 |> file.create()

  # checkmate::assert_string(model_path)

  run_experiment(
    model_path = 1,
    setup_file = NULL,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_file_exists(model_path)

  run_experiment(
    model_path = tempfile(fileext = ".nlogox"),
    setup_file = setup_file,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_choice(fs::path_ext(model_path), model_path_choices)

  run_experiment(
    model_path = model_path_2,
    setup_file = NULL,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(setup_file, null.ok = TRUE)

  run_experiment(
    model_path = model_path_1,
    setup_file = 1,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(experiment, null.ok = TRUE)

  run_experiment(
    model_path = model_path_1,
    setup_file = NULL,
    experiment = 1,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # assert_pick_one(setup_file, experiment)

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = "a",
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(output, min.len = 1)

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = 1,
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = character(),
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_subset(output, output_choices)

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "test",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(other_arguments, null.ok = TRUE)

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "table",
    other_arguments = 1,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # assert_other_arguments(other_arguments, reserved_arguments, null_ok = TRUE)

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "table",
    other_arguments = c("--3D", "--headless"),
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_number(timeout, lower = 0)

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = "a",
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = -1,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(tidy_output)

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = "a"
  ) |>
    testthat::expect_error()

  # if (!is.null(setup_file)) { [...]

  run_experiment(
    model_path = model_path_1,
    setup_file = tempfile(fileext = ".xml"),
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_2,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # if (!any(c("table", "spreadsheet") %in% output)) {

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = c("lists", "statistics"),
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # assert_netlogo_console()

  Sys.setenv("NETLOGO_CONSOLE" = "")

  testthat::local_mocked_bindings(
    find_netlogo_home = function(...) "",
    sys_info = function(...) c(sysname = "linux"),
    path = function(...) ""
  )

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  Sys.setenv("NETLOGO_CONSOLE" = netlogo_console_backup)

  # if (!is.null(status)) { [...] } else {

  testthat::local_mocked_bindings(
    assert_netlogo_console = function(...) NULL,
    find_netlogo_console = function(...) NULL,
    system_2 = function(...) `attributes<-`("Test", list(status = 5))
  )

  run_experiment(
    model_path = model_path_1,
    setup_file = setup_file_1,
    experiment = NULL,
    output = "table",
    other_arguments = NULL,
    timeout = Inf,
    tidy_output = TRUE
  ) |>
    testthat::expect_error() |>
    suppressMessages() |>
    suppressWarnings()
})

testthat::test_that("`run_experiment.output_argument()` | General test", {
  c("table", "spreadsheet", "lists", "statistics") |>
    run_experiment.output_argument() |>
    checkmate::expect_tibble(ncols = 3)
})

testthat::test_that("`run_experiment.output_argument()` | Error test", {
  # checkmate::assert_character(output)

  run_experiment.output_argument(
    output = 1
  ) |>
    testthat::expect_error()

  # checkmate::assert_subset(output, outputs_choices)

  run_experiment.output_argument(
    output = "test"
  ) |>
    testthat::expect_error()
})

testthat::test_that("`run_experiment.gather_output()` | General test", {
  arguments <-
    c("table", "spreadsheet", "lists", "statistics") |>
    run_experiment.output_argument()

  testthat::local_mocked_bindings(
    read_experiment_metadata = function(...) "",
    read_experiment_table = function(...) "",
    read_experiment_spreadsheet = function(...) "",
    read_experiment_lists = function(...) "",
    read_experiment_statistics = function(...) ""
  )

  run_experiment.gather_output(
    output = c("table", "spreadsheet", "lists", "statistics"),
    argument = arguments,
    tidy_output = TRUE
  ) |>
    checkmate::expect_list(len = 5) |>
    suppressMessages() |>
    suppressWarnings()
})

testthat::test_that("`run_experiment.gather_output()` | Error test", {
  arguments <-
    c("table", "spreadsheet", "lists", "statistics") |>
    run_experiment.output_argument()

  # checkmate::assert_subset(output, output_choices)

  run_experiment.gather_output(
    output = "test",
    argument = arguments,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_tibble(argument, ncols = 3)

  run_experiment.gather_output(
    output = "table",
    argument = 1,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(tidy_output)

  run_experiment.gather_output(
    output = "table",
    argument = arguments,
    tidy_output = "a"
  ) |>
    testthat::expect_error()
})
