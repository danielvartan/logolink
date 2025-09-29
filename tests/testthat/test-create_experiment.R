testthat::test_that("`create_experiment()` | General test", {
  create_experiment() |>
    checkmate::expect_file_exists(extension = "xml")

  create_experiment() |>
    readr::read_lines() |>
    checkmate::expect_character() |>
    magrittr::extract(1) |>
    checkmate::expect_string(pattern = "<experiments>")

  create_experiment(
    name = "Wolf Sheep Simple Model Analysis",
    repetitions = 10,
    sequential_run_order = TRUE,
    run_metrics_every_step = TRUE,
    setup = "setup",
    go = "go",
    time_limit = 1000,
    metrics = c(
      'count wolves',
      'count sheep'
    ),
    run_metrics_condition = NULL,
    constants = list(
      "number-of-sheep" = 500,
      "number-of-wolves" = list(
        first = 5,
        step = 1,
        last = 15
      ),
      "movement-cost" = 0.5,
      "grass-regrowth-rate" = 0.3,
      "energy-gain-from-grass" = 2,
      "energy-gain-from-sheep" = 5,
      "character-constant-test" = "a string constant",
      "logical-constant-test" = TRUE
    )
  ) |>
    checkmate::expect_file_exists(extension = "xml")
})

test_that("`create_experiment()` | Error test", {
  # checkmate::assert_string(name)

  create_experiment(
    name = 1,
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_int(repetitions, lower = 1)

  create_experiment(
    name = "",
    repetitions = 0,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(sequential_run_order)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = "a",
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(run_metrics_every_step)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = "a",
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(pre_experiment, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = 1,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(setup)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = 1,
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(go)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = 1,
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(post_run, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = 1,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(post_experiment, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = 1,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_int(time_limit, lower = 1)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = NULL,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(exit_condition, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = 1,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(metrics, min.len = 1)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = 1:2,
    run_metrics_condition = NULL,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_string(run_metrics_condition, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = 1,
    constants = NULL
  ) |>
    testthat::expect_error()

  # checkmate::assert_list(constants, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    time_limit = 1,
    exit_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    run_metrics_condition = NULL,
    constants = "a"
  ) |>
    testthat::expect_error()
})
