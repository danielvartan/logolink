# Wolf Sheep Predation Model Experiments
# (Included in NetLogo's Model Library)

## Custom Experiments

testthat::test_that("`run_experiment()` | Wolf Sheep Simple Model Analysis", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if(Sys.getenv("LOGOLINK_TEST_NETLOGO") == "FALSE")

  testthat::skip_if(
    find_netlogo_console() |>
      suppressMessages() |>
      identical("")
  )

  model_path <-
    find_netlogo_home() |>
    file.path(
      "models",
      "IABM Textbook",
      "chapter 4",
      "Wolf Sheep Simple 5.nlogox"
    )

  setup_file <- create_experiment(
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
      "energy-gain-from-sheep" = 5
    )
  )

  results <-
    model_path |>
    run_experiment(
      setup_file = setup_file,
      experiment = NULL,
      output = c("table", "spreadsheet", "lists", "statistics"),
      other_arguments = NULL,
      timeout = Inf,
      tidy_output = TRUE
    ) |>
    suppressMessages() |>
    suppressWarnings()

  results |>
    checkmate::expect_list(len = 5)

  results |>
    magrittr::extract2("table") |>
    checkmate::expect_tibble(min.rows = 1)

  results |>
    magrittr::extract2("table") |>
    colnames() |>
    checkmate::expect_subset(
      c(
        "run_number",
        "number_of_sheep",
        "number_of_wolves",
        "movement_cost",
        "grass_regrowth_rate",
        "energy_gain_from_grass",
        "energy_gain_from_sheep",
        "step",
        "count_wolves",
        "count_sheep"
      )
    )

  results |>
    magrittr::extract2("spreadsheet") |>
    checkmate::expect_list(len = 2)

  results |>
    magrittr::extract2("spreadsheet") |>
    magrittr::extract2("statistics") |>
    checkmate::expect_tibble(min.rows = 1)

  results |>
    magrittr::extract2("spreadsheet") |>
    magrittr::extract2("statistics") |>
    colnames() |>
    checkmate::expect_subset(
      c(
        "run_number",
        "number_of_sheep",
        "number_of_wolves",
        "movement_cost",
        "grass_regrowth_rate",
        "energy_gain_from_grass",
        "energy_gain_from_sheep",
        "step_final",
        "step_min",
        "step_max",
        "step_mean",
        "step_total_steps",
        "count_wolves_final",
        "count_wolves_min",
        "count_wolves_max",
        "count_wolves_mean",
        "count_wolves_total_steps",
        "count_sheep_final",
        "count_sheep_min",
        "count_sheep_max",
        "count_sheep_mean",
        "count_sheep_total_steps"
      )
    )

  results |>
    magrittr::extract2("spreadsheet") |>
    magrittr::extract2("data") |>
    checkmate::expect_tibble(min.rows = 1)

  results |>
    magrittr::extract2("spreadsheet") |>
    magrittr::extract2("data") |>
    colnames() |>
    checkmate::expect_subset(
      c(
        "run_number",
        "number_of_sheep",
        "number_of_wolves",
        "movement_cost",
        "grass_regrowth_rate",
        "energy_gain_from_grass",
        "energy_gain_from_sheep",
        "step",
        "count_wolves",
        "count_sheep"
      )
    )

  results |>
    magrittr::extract2("lists") |>
    checkmate::expect_tibble()

  results |>
    magrittr::extract2("lists") |>
    colnames() |>
    checkmate::expect_subset(
      c(
        "reporter",
        "run_number",
        "number_of_sheep",
        "number_of_wolves",
        "movement_cost",
        "grass_regrowth_rate",
        "energy_gain_from_grass",
        "energy_gain_from_sheep",
        "step"
      )
    )

  results |>
    magrittr::extract2("statistics") |>
    checkmate::expect_tibble(min.rows = 1)

  results |>
    magrittr::extract2("statistics") |>
    colnames() |>
    checkmate::expect_subset(
      c(
        "number_of_sheep",
        "number_of_wolves",
        "movement_cost",
        "grass_regrowth_rate",
        "energy_gain_from_grass",
        "energy_gain_from_sheep",
        "step",
        "mean_count_wolves",
        "std_count_wolves",
        "mean_count_sheep",
        "std_count_sheep"
      )
    )
})

testthat::test_that("`run_experiment()` | Agent Attributes Extraction", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if(Sys.getenv("LOGOLINK_TEST_NETLOGO") == "FALSE")

  testthat::skip_if(
    find_netlogo_console() |>
      suppressMessages() |>
      identical("")
  )

  model_path <-
    find_netlogo_home() |>
    file.path(
      "models",
      "Sample Models",
      "Biology",
      "Wolf Sheep Predation.nlogox"
    )

  setup_file <- create_experiment(
    name = "Agent Attributes Extraction",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = TRUE,
    time_limit = 1,
    metrics = c(
      '[who] of sheep',
      '[xcor] of sheep',
      '[ycor] of sheep',
      '[shape] of sheep',
      '[color] of sheep',
      '[who] of wolves',
      '[xcor] of wolves',
      '[ycor] of wolves',
      '[shape] of wolves',
      '[color] of wolves',
      '[pxcor] of patches',
      '[pycor] of patches',
      '[pcolor] of patches'
    ),
    constants = list(
      "model-version" = "sheep-wolves-grass"
    )
  )

  results <-
    model_path |>
    run_experiment(
      setup_file = setup_file,
      output = c("table", "lists")
    ) |>
    suppressMessages() |>
    suppressWarnings()

  results |>
    checkmate::expect_list(len = 3)
})

## Predefined Experiments

testthat::test_that("`run_experiment()` | BehaviorSpace Combinatorial", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if(Sys.getenv("LOGOLINK_TEST_NETLOGO") == "FALSE")

  testthat::skip_if(
    find_netlogo_console() |>
      suppressMessages() |>
      identical("")
  )

  model_path <-
    find_netlogo_home() |>
    file.path(
      "models",
      "Sample Models",
      "Biology",
      "Wolf Sheep Predation.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "BehaviorSpace Combinatorial",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1500,
    setup = 'setup',
    go = 'go',
    post_run = 'wait .5',
    run_metrics_condition = 'ticks mod 10 = 0',
    metrics = c(
      'count sheep',
      'count wolves',
      'count grass'
    ),
    constants = list(
      "model-version" = "sheep-wolves-grass",
      "wolf-reproduce" = c(3, 5, 10, 15),
      "wolf-gain-from-food" = c(10, 15, 30, 40)
    )
  )

  experiment <- "BehaviorSpace combinatorial"

  results <-
    model_path |>
    run_experiment(
      # setup_file = setup_file
      experiment = experiment
    ) |>
    suppressMessages() |>
    suppressWarnings()

  results |>
    checkmate::expect_list(len = 2)
})

testthat::test_that("`run_experiment()` | Behaviorspace Run 3 Experiments", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if(Sys.getenv("LOGOLINK_TEST_NETLOGO") == "FALSE")

  testthat::skip_if(
    find_netlogo_console() |>
      suppressMessages() |>
      identical("")
  )

  # Experiment mirror
  model_path <-
    find_netlogo_home() |>
    file.path(
      "models",
      "Sample Models",
      "Biology",
      "Wolf Sheep Predation.nlogox"
    )

  setup_file <- create_experiment(
    name = "Behaviorspace Run 3 Experiments",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1500,
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
    run_metrics_condition = 'ticks mod 10 = 0',
    metrics = c(
      'count sheep',
      'count wolves',
      'count grass'
    ),
    constants = list(
      "model-version" = "sheep-wolves-grass"
    ),
    sub_experiments = list(
      list(
        "sheep-reproduce" = 1,
        "sheep-gain-from-food" = 1,
        "wolf-reproduce" = 2,
        "wolf-gain-from-food" = 10
      ),
      list(
        "sheep-reproduce" = 6,
        "sheep-gain-from-food" = 8,
        "wolf-reproduce" = 5,
        "wolf-gain-from-food" = 20
      ),
      list(
        "sheep-reproduce" = 20,
        "sheep-gain-from-food" = 15,
        "wolf-reproduce" = 15,
        "wolf-gain-from-food" = 30
      )
    )
  )

  experiment <- "BehaviorSpace run 3 experiments"

  results <-
    model_path |>
    run_experiment(
      setup_file = setup_file
      # experiment = experiment
    ) |>
    suppressMessages() |>
    suppressWarnings()

  results |>
    checkmate::expect_list(len = 2)
})

testthat::test_that("`run_experiment()` | BehaviorSpace Run 3 Variable ...", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if(Sys.getenv("LOGOLINK_TEST_NETLOGO") == "FALSE")

  testthat::skip_if(
    find_netlogo_console() |>
      suppressMessages() |>
      identical("")
  )

  model_path <-
    find_netlogo_home() |>
    file.path(
      "models",
      "Sample Models",
      "Biology",
      "Wolf Sheep Predation.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "BehaviorSpace Run 3 Variable Values Per Experiments",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1500,
    setup = c(
      'setup',
      paste0(
        'print (word "sheep-reproduce: " sheep-reproduce ", wolf-reproduce: ',
        '" wolf-reproduce)'
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
    run_metrics_condition = 'ticks mod 10 = 0',
    metrics = c(
      'count sheep',
      'count wolves',
      'count grass'
    ),
    constants = list(
      "model-version" = "sheep-wolves-grass",
      "sheep-reproduce" = 4,
      "wolf-reproduce" = 2,
      "sheep-gain-from-food" = 4,
      "wolf-gain-from-food" = 20
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
    )
  )

  experiment <- "BehaviorSpace run 3 variable values per experiments"

  results <-
    model_path |>
    run_experiment(
      setup_file = setup_file
      # experiment = experiment
    ) |>
    suppressMessages() |>
    suppressWarnings()

  results |>
    checkmate::expect_list(len = 2)
})

testthat::test_that("`run_experiment()` | BehaviorSpace Subset", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if(Sys.getenv("LOGOLINK_TEST_NETLOGO") == "FALSE")

  testthat::skip_if(
    find_netlogo_console() |>
      suppressMessages() |>
      identical("")
  )

  model_path <-
    find_netlogo_home() |>
    file.path(
      "models",
      "Sample Models",
      "Biology",
      "Wolf Sheep Predation.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "BehaviorSpace Subset",
    repetitions = 1,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1500,
    setup = 'setup',
    go = 'go',
    post_run = 'wait .5',
    run_metrics_condition = 'ticks mod 10 = 0',
    metrics = c(
      'count sheep',
      'count wolves',
      'count grass'
    ),
    constants = list(
      "model-version" = "sheep-wolves-grass"
    ),
    sub_experiments = list(
      list(
        "wolf-reproduce" = c(3, 5),
        "wolf-gain-from-food" = c(30, 40)
      ),
      list(
        "wolf-reproduce" = c(10, 15),
        "wolf-gain-from-food" = c(10, 15)
      )
    )
  )

  experiment <- "BehaviorSpace subset"

  results <-
    model_path |>
    run_experiment(
      setup_file = setup_file
      # experiment = experiment
    ) |>
    suppressMessages() |>
    suppressWarnings()

  results |>
    checkmate::expect_list(len = 2)
})

testthat::test_that("`run_experiment()` | New BehaviorSpace Features", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if(Sys.getenv("LOGOLINK_TEST_NETLOGO") == "FALSE")

  testthat::skip_if(
    find_netlogo_console() |>
      suppressMessages() |>
      identical("")
  )

  model_path <-
    find_netlogo_home() |>
    file.path(
      "models",
      "Sample Models",
      "Biology",
      "Wolf Sheep Predation.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "New BehaviorSpace Features",
    repetitions = 3,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 200,
    pre_experiment = 'reset-timer',
    setup = 'setup',
    go = 'go',
    post_experiment = 'show timer',
    run_metrics_condition = 'ticks mod 2 = 0',
    metrics = c(
      'count sheep',
      'count wolves',
      '[xcor] of sheep',
      '[ycor] of sheep',
      '[xcor] of wolves',
      '[ycor] of wolves'
    ),
    sub_experiments = list(
      list(
        "wolf-gain-from-food" = list(
          first = 30,
          step = 5,
          last = 50
        )
      )
    )
  )

  experiment <- "New BehaviorSpace Features"

  results <-
    model_path |>
    run_experiment(
      setup_file = setup_file
      # experiment = experiment
    ) |>
    suppressMessages() |>
    suppressWarnings()

  results |>
    checkmate::expect_list(len = 2)
})

testthat::test_that("`run_experiment()` | New BehaviorSpace Features ...", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if(Sys.getenv("LOGOLINK_TEST_NETLOGO") == "FALSE")

  testthat::skip_if(
    find_netlogo_console() |>
      suppressMessages() |>
      identical("")
  )

  model_path <-
    find_netlogo_home() |>
    file.path(
      "models",
      "Sample Models",
      "Biology",
      "Wolf Sheep Predation.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "New BehaviorSpace Features Reproducible",
    repetitions = 3,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 200,
    pre_experiment = 'reset-timer',
    setup = c(
      'random-seed (474 + behaviorspace-run-number)',
      '',
      'setup'
    ),
    go = 'go',
    post_experiment = 'show timer',
    run_metrics_condition = 'ticks mod 2 = 0',
    metrics = c(
      'count sheep',
      'count wolves',
      '[xcor] of sheep',
      '[ycor] of sheep',
      '[xcor] of wolves',
      '[ycor] of wolves'
    ),
    constants = list(
      "model-version" = "sheep-wolves-grass",
      "wolf-gain-from-food" = 20,
      "show-energy?" = FALSE,
      "wolf-reproduce" = 5,
      "initial-number-wolves" = 50,
      "initial-number-sheep" = 100
    ),
    sub_experiments = list(
      list(
        "wolf-gain-from-food" = c(10, 20, 30)
      )
    )
  )

  experiment <- "New BehaviorSpace Features reproducible"

  results <-
    model_path |>
    run_experiment(
      setup_file = setup_file,
      # experiment = experiment
      output = c("table", "statistics")
    ) |>
    suppressMessages() |>
    suppressWarnings()

  results |>
    checkmate::expect_list(len = 3)
})

testthat::test_that("`run_experiment()` | Wolf Sheep Crossing", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if(Sys.getenv("LOGOLINK_TEST_NETLOGO") == "FALSE")

  testthat::skip_if(
    find_netlogo_console() |>
      suppressMessages() |>
      identical("")
  )

  model_path <-
    find_netlogo_home() |>
    file.path(
      "models",
      "Sample Models",
      "Biology",
      "Wolf Sheep Predation.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "Wolf Sheep Crossing",
    repetitions = 4,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 1500,
    setup = 'setup',
    go = 'go',
    run_metrics_condition = 'count sheep = count wolves',
    metrics = c(
      'count sheep',
      'count wolves'
    ),
    constants = list(
      "wolf-gain-from-food" = 20,
      "show-energy?" = FALSE,
      "wolf-reproduce" = 5,
      "initial-number-wolves" = 50,
      "initial-number-sheep" = 100,
      "model-version" = "sheep-wolves-grass",
      "sheep-gain-from-food" = 4,
      "grass-regrowth-time" = 30,
      "sheep-reproduce" = 4
    )
  )

  experiment <- "Wolf Sheep Crossing"

  results <-
    model_path |>
    run_experiment(
      setup_file = setup_file
      # experiment = experiment
    ) |>
    suppressMessages() |>
    suppressWarnings()

  results |>
    checkmate::expect_list(len = 2)
})
