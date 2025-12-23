read_experiment_lists <- function(file, tidy_output = TRUE) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file)
  checkmate::assert_flag(tidy_output)

  out <-
    file |>
    readr::read_delim(
      delim = ",",
      col_types = readr::cols(.default = readr::col_character()),
      na = c("", "N/A"),
      skip = 6,
      progress = FALSE,
      show_col_types = FALSE
    ) |>
    suppressWarnings() |>
    dplyr::as_tibble() |>
    janitor::clean_names()

  if (nrow(out) == 0) {
    cli::cli_alert_warning("The experiment produced no lists results.")

    out
  } else {
    if (isTRUE(tidy_output)) {
      out <-
        out |>
        read_experiment_lists.tidy_output()
    }

    out
  }
}

read_experiment_lists.tidy_output <- function(data) {
  checkmate::assert_tibble(data)

  # R CMD Check variable bindings fix.
  # nolint start
  reporter <- run_number <- step <- value <- index <- NULL
  # nolint end

  data |>
    dplyr::arrange(reporter, run_number, step) |>
    tidyr::pivot_longer(
      cols = dplyr::matches("^x\\d+$"),
      names_to = "index",
    ) |>
    tidyr::pivot_wider(
      names_from = reporter,
      values_from = value
    ) |>
    dplyr::mutate(,
      dplyr::across(
        .cols = dplyr::everything(),
        .fns = \(x) readr::parse_guess(x, na = c("", "N/A"))
      )
    ) |>
    janitor::clean_names() |>
    dplyr::mutate(
      index = stringr::str_remove(index, "^x")
    ) |>
    dplyr::arrange(run_number, step)
}
