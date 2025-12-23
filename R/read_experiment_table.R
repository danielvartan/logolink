read_experiment_table <- function(file, tidy_output = TRUE) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file)
  checkmate::assert_flag(tidy_output)

  # R CMD Check variable bindings fix.
  # nolint start
  run_number <- step <- NULL
  # nolint end

  out <-
    file |>
    readr::read_delim(
      delim = ",",
      na = c("", "N/A"),
      skip = 6,
      progress = FALSE,
      show_col_types = FALSE
    ) |>
    dplyr::as_tibble() |>
    janitor::clean_names() |>
    dplyr::arrange(run_number, step)

  if (nrow(out) == 0) {
    cli::cli_alert_warning("The experiment produced no table results.")
  }

  out
}
