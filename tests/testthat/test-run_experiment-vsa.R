# Voting Sensitivity Model Experiments
# (Included in NetLogo's Model Library)

## Predefined Experiments

testthat::test_that("`run_experiment()` | Sensitivity Experiment", {
  testthat::skip_on_cran()
  testthat::skip_on_covr()
  testthat::skip_if(is.na(find_netlogo_console()))
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
      "chapter 7",
      "Voting Sensitivity Analysis.nlogox"
    )

  # Experiment mirror
  setup_file <- create_experiment(
    name = "Sensitivity Experiment",
    repetitions = 10,
    sequential_run_order = TRUE,
    run_metrics_every_step = FALSE,
    time_limit = 100,
    setup = 'setup',
    go = 'go',
    metrics = 'count patches with [ vote = 0 ] / count patches',
    constants = list(
      "initial-green-pct" = list(
        first = 25,
        step = 5,
        last = 75
      ),
      "award-close-calls-to-loser?" = FALSE,
      "change-vote-if-tied?" = FALSE
    )
  )

  experiment <- "sensitivity-experiment"

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
