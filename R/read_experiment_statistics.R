read_experiment_statistics <- function(file, tidy_output = TRUE) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file)
  checkmate::assert_flag(tidy_output)

  # R CMD Check variable bindings fix.
  # nolint start
  scenario <- NULL
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
    dplyr::mutate(
      scenario = dplyr::row_number()
    ) |>
    dplyr::relocate(scenario)

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
