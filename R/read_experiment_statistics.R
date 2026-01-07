read_experiment_statistics <- function(file) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file)

  assert_behaviorspace_file(file)
  assert_behaviorspace_file_output(file)

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
    janitor::clean_names()

  if (nrow(out) == 0) {
    cli::cli_alert_warning(
      paste0(
        "The experiment produced no ",
        "{.strong {cli::col_red('statistics')}} ",
        "results."
      ),
      wrap = TRUE
    )
  }

  out
}
