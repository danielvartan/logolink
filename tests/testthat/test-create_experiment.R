testthat::test_that("`create_experiment()` | General test", {
  create_experiment() |>
    checkmate::expect_file_exists(extension = "xml")

  create_experiment() |>
    readr::read_lines() |>
    checkmate::expect_character() |>
    magrittr::extract(1) |>
    checkmate::expect_string(pattern = "<experiments>")

  create_experiment(
    name = "BehaviorSpace Run 3 Variable Values Per Experiments",
    repetitions = 10,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1500,
    pre_experiment = NULL,
    setup = c(
      'setup',
      paste0(
        'print (word "sheep-reproduce: " sheep-reproduce ", ',
        'wolf-reproduce: " wolf-reproduce)'
      ),
      paste0(
        'print (word "sheep-gain-from-food: " sheep-gain-from-food ", ',
        'wolf-gain-from-food: " wolf-gain-from-food)'
      )
    ),
    go = 'go',
    post_run = c(
      'print (word "sheep: " count sheep ", wolves: " count wolves)',
      'print ""',
      'wait 1'
    ),
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = 'ticks mod 10 = 0',
    metrics = c(
      'count sheep',
      'count wolves',
      'count grass'
    ),
    constants = list(
      "model-version" = "sheep-wolves-grass",
      "initial-number-sheep" = 100,
      "initial-number-wolves" = list(
        first = 5,
        step = 1,
        last = 15
      ),
      "sheep-reproduce" = 4,
      "wolf-reproduce" = 2,
      "sheep-gain-from-food" = 4,
      "wolf-gain-from-food" = 20,
      "grass-regrowth-time" = 30,
      "show-energy?" = FALSE
    ),
    sub_experiments = list(
      list(
        "sheep-reproduce" = c(1, 6, 20)
      ),
      list(
        "wolf-reproduce" = c(2, 7, 15)
      ),
      list(
        "sheep-gain-from-food" = c(1, 8, 15)
      ),
      list(
        "wolf-gain-from-food" = c(10, 20, 30)
      )
    ),
    file = tempfile(pattern = "experiment-", fileext = ".xml")
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
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_int(repetitions, lower = 1)

  create_experiment(
    name = "",
    repetitions = "a",
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  create_experiment(
    name = "",
    repetitions = 0,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(sequential_run_order)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = "a",
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(run_metrics_every_step)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = "a",
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_int(time_limit, lower = 1)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = "a",
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = -1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(pre_experiment, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = 1,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(setup)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = 1,
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(go)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = 1,
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(post_run, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = 1,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(post_experiment, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = 1,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    .sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(exit_condition, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = 1,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(run_metrics_condition, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = 1,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_character(metrics, min.len = 1)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = 1:2,
    constants = NULL,
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_list(constants, names = "named", null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = "a",
    sub_experiments = NULL,
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_list(sub_experiments, null.ok = TRUE)

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = "a",
    file = tempfile(pattern = "experiment-", fileext = ".xml")
  ) |>
    testthat::expect_error()

  # checkmate::assert_path_for_output(file, overwrite = TRUE, extension = "xml")

  create_experiment(
    name = "",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1,
    pre_experiment = NULL,
    setup = "setup",
    go = "go",
    post_run = NULL,
    post_experiment = NULL,
    exit_condition = NULL,
    run_metrics_condition = NULL,
    metrics = c('count turtles', 'count patches'),
    constants = NULL,
    sub_experiments = NULL,
    file = "experiment.txt"
  ) |>
    testthat::expect_error()
})
