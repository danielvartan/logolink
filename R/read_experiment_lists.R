read_experiment_lists <- function(file, tidy_output = TRUE) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file)
  checkmate::assert_flag(tidy_output)

  assert_behaviorspace_file(file)
  assert_behaviorspace_file_output(file)

  # R CMD Check variable bindings fix
  # nolint start
  reporter <- run_number <- step <- value <- index <- NULL
  # nolint end

  out <-
    file |>
    readr::read_delim(
      delim = ",",
      na = c("", "N/A"),
      skip = 6,
      progress = FALSE,
      show_col_types = FALSE,
      skip_empty_rows = TRUE
    ) |>
    suppressWarnings() |>
    dplyr::as_tibble() |>
    janitor::clean_names()

  if (nrow(out) == 0) {
    cli::cli_alert_warning(
      paste0(
        "The experiment produced no ",
        "{.strong {cli::col_red('lists')}} ",
        "results."
      ),
      wrap = TRUE
    )

    out
  } else {
    if (isTRUE(tidy_output)) {
      out <- read_experiment_lists.tidy_data(out)
    }

    out
  }
}

read_experiment_lists.tidy_data <- function(data) {
  checkmate::assert_tibble(data)

  # R CMD Check variable bindings fix
  # nolint start
  index <- reporter <- run_number <- step <- value <- NULL
  # nolint end

  data |>
    dplyr::mutate(,
      dplyr::across(
        .cols = dplyr::everything(),
        .fns = as.character
      )
    ) |>
    tidyr::pivot_longer(
      cols = dplyr::matches("^x\\d+$"),
      names_to = "index",
    ) |>
    tidyr::pivot_wider(
      names_from = reporter,
      values_from = value
    ) |>
    dplyr::mutate(
      index = stringr::str_remove(index, "^x"),
      dplyr::across(
        .cols = dplyr::everything(),
        .fns = \(x) readr::parse_guess(x, na = c("", "N/A"))
      )
    ) |>
    janitor::clean_names() |>
    dplyr::arrange(run_number, step, index)
}
