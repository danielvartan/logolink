# Spread of Disease Model Experiments
# (Included in NetLogo's Model Library)

## Custom Experiments

testthat::test_that("`run_experiment()` | Population Density (Runtime)", {
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
      "chapter 6",
      "Spread of Disease.nlogox"
    )

  setup_file <- create_experiment(
    name = "Population Density (Runtime)",
    repetitions = 10,
    sequential_run_order = TRUE,
    run_metrics_every_step = TRUE,
    time_limit = 1000,
    setup = 'setup',
    go = 'go',
    metrics = 'count turtles with [infected?]',
    constants = list(
      "variant" = "mobile",
      "num-people" = list(
        first = 50,
        step = 50,
        last = 200
      ),
      "connections-per-node" = 4.1,
      "num-infected" = 1,
      "disease-decay" = 0
    )
  )

  results <-
    model_path |>
    run_experiment(
      setup_file = setup_file,
      output = c("table", "spreadsheet", "lists", "statistics")
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
        "variant",
        "num_people",
        "connections_per_node",
        "num_infected",
        "disease_decay",
        "step",
        "count_turtles_with_infected"
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
        "variant",
        "num_people",
        "connections_per_node",
        "num_infected",
        "disease_decay",
        "step_final",
        "step_min",
        "step_max",
        "step_mean",
        "step_total_steps",
        "count_turtles_with_infected_final",
        "count_turtles_with_infected_min",
        "count_turtles_with_infected_max",
        "count_turtles_with_infected_mean",
        "count_turtles_with_infected_total_steps"
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
        "variant",
        "num_people",
        "connections_per_node",
        "num_infected",
        "disease_decay",
        "step",
        "count_turtles_with_infected"
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
        "variant",
        "num_people",
        "connections_per_node",
        "num_infected",
        "disease_decay",
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
        "variant",
        "num_people",
        "connections_per_node",
        "num_infected",
        "disease_decay",
        "step",
        "mean_count_turtles_with_infected",
        "std_count_turtles_with_infected"
      )
    )
})

## Predefined Experiments

testthat::test_that("`run_experiment()` | Population Density", {
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
      "chapter 6",
      "Spread of Disease.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "Population Density",
    repetitions = 10,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = NULL,
    setup = 'setup',
    go = 'go',
    metrics = 'ticks',
    constants = list(
      "variant" = "mobile",
      "connections-per-node" = 4.1,
      "num-people" = list(
        first = 50,
        step = 50,
        last = 200
      ),
      "num-infected" = 1,
      "disease-decay" = 0
    )
  )

  experiment <- "population-density"

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

testthat::test_that("`run_experiment()` | Degree", {
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
      "chapter 6",
      "Spread of Disease.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "Degree",
    repetitions = 10,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 50,
    setup = 'setup',
    go = 'go',
    metrics = 'count turtles with [infected?]',
    constants = list(
      "num-people" = 200,
      "connections-per-node" = list(
        first = 0.5,
        step = 0.5,
        last = 4
      ),
      "disease-decay" = 10,
      "variant" = "network",
      "num-infected" = 1
    )
  )

  experiment <- "degree"

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

testthat::test_that("`run_experiment()` | Degree", {
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
      "chapter 6",
      "Spread of Disease.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "Environmental",
    repetitions = 10,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = NULL,
    setup = 'setup',
    go = 'go',
    metrics = 'ticks',
    constants = list(
      "num-people" = 200,
      "connections-per-node" = 4,
      "disease-decay" = list(
        first = 0,
        step = 1,
        last = 10
      ),
      "variant" = "environmental",
      "num-infected" = 1
    )
  )

  experiment <- "environmental"

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

testthat::test_that("`run_experiment()` | Degree", {
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
      "chapter 6",
      "Spread of Disease.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "Density and Decay",
    repetitions = 10,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = NULL,
    setup = 'setup',
    go = 'go',
    metrics = 'ticks',
    constants = list(
      "variant" = "environmental",
      "disease-decay" = list(
        first = 0,
        step = 1,
        last = 10
      ),
      "num-infected" = 1,
      "num-people" = list(
        first = 50,
        step = 50,
        last = 200
      ),
      "connections-per-node" = 4
    )
  )

  experiment <- "density-and-decay"

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
