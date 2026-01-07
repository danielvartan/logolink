read_experiment_table <- function(file) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file)

  assert_behaviorspace_file(file)
  assert_behaviorspace_file_output(file)

  # R CMD Check variable bindings fix
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
      show_col_types = FALSE,
      skip_empty_rows = TRUE
    ) |>
    dplyr::as_tibble() |>
    janitor::clean_names() |>
    dplyr::arrange(run_number, step)

  if (nrow(out) == 0) {
    cli::cli_alert_warning(
      paste0(
        "The experiment produced no ",
        "{.strong {cli::col_red('table')}} ",
        "results."
      ),
      wrap = TRUE
    )
  }

  out
}
