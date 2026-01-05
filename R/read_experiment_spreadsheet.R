read_experiment_spreadsheet <- function(file, tidy_output = TRUE) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file, extension = "csv")
  checkmate::assert_flag(tidy_output)

  lines <-
    file |>
    readr::read_lines() |>
    stringr::str_remove_all('\"')

  run_number_index <- lines |> stringr::str_which("^\\[run number\\]")
  reporter_index <- lines |> stringr::str_which("^\\[reporter\\]")
  total_steps_index <- lines |> stringr::str_which("^\\[total steps\\]")
  all_run_data_index <- lines |> stringr::str_which("^\\[all run data\\]")

  statistics <-
    file |>
    readr::read_delim(
      delim = ",",
      col_names = FALSE,
      col_types = readr::cols(.default = readr::col_character()),
      na = c("", "N/A"),
      skip = run_number_index - 1,
      n_max = total_steps_index - run_number_index + 1,
      progress = FALSE,
      show_col_types = FALSE
    ) |>
    dplyr::as_tibble()

  data <-
    file |>
    readr::read_delim(
      delim = ",",
      col_types = readr::cols(.default = readr::col_character()),
      na = c("", "N/A"),
      skip = all_run_data_index - 1,
      name_repair = "minimal",
      progress = FALSE,
      show_col_types = FALSE
    ) |>
    suppressMessages() |>
    janitor::clean_names()

  out <- list(
    statistics = statistics,
    data = data
  )

  if (nrow(data) == 0) {
    cli::cli_alert_warning(
      paste0(
        "The experiment produced no ",
        "{.strong {cli::col_red('spreadsheet')}} ",
        "results."
      ),
      wrap = TRUE
    )

    out
  } else {
    if (isTRUE(tidy_output)) {
      statistics <-
        statistics |>
        read_experiment_spreadsheet.tidy_settings()

      data <-
        data |>
        read_experiment_spreadsheet.tidy_data(statistics)

      out <- list(
        statistics = statistics,
        data = data
      )
    }

    out
  }
}

read_experiment_spreadsheet.tidy_settings <- function(data) {
  checkmate::assert_tibble(data)

  # R CMD Check variable bindings fix
  # nolint start
  final <- reporter <- total_steps <- value <- X1 <- NULL
  # nolint end

  data <-
    data |>
    tidyr::pivot_longer(-X1) |>
    tidyr::pivot_wider(names_from = X1, values_from = value) |>
    dplyr::select(-1) |>
    tidyr::fill(dplyr::everything(), .direction = "down") |>
    janitor::clean_names()

  reporter_names <-
    data |>
    dplyr::pull(reporter) |>
    unique() |>
    janitor::make_clean_names()

  data <-
    data |>
    tidyr::pivot_wider(
      names_from = reporter,
      values_from = c(final, min, max, mean, total_steps),
      names_glue = "{reporter}_{.value}"
    ) |>
    dplyr::mutate(
      dplyr::across(
        .cols = dplyr::everything(),
        .fns = \(x) readr::parse_guess(x, na = c("", "N/A"))
      )
    ) |>
    janitor::clean_names()

  for (i in reporter_names) {
    data <-
      data |>
      dplyr::relocate(
        dplyr::starts_with(i),
        .after = dplyr::last_col()
      )
  }

  data
}

read_experiment_spreadsheet.tidy_data <- function(data, statistics) {
  checkmate::assert_tibble(data)
  checkmate::assert_tibble(statistics)

  # R CMD Check variable bindings fix
  # nolint start
  reporter <- run_number <- value <- row_id <- step <- NULL
  # nolint end

  data <-
    data |>
    dplyr::select(-1) |>
    dplyr::rename_with(
      .fn = \(x) paste0(x, "_1"),
      .cols = !dplyr::matches("\\d$")
    ) |>
    tidyr::pivot_longer(
      cols = dplyr::everything(),
      names_to = "reporter",
      values_to = "value"
    ) |>
    tidyr::separate_wider_regex(
      cols = reporter,
      patterns = c(reporter = ".*", "_", run_number = ".*")
    ) |>
    dplyr::group_by(run_number, reporter) |>
    dplyr::mutate(row_id = dplyr::row_number()) |>
    dplyr::ungroup() |>
    tidyr::pivot_wider(
      names_from = reporter,
      values_from = value
    ) |>
    dplyr::select(-row_id) |>
    dplyr::mutate(
      dplyr::across(
        .cols = dplyr::everything(),
        .fns = \(x) readr::parse_guess(x, na = c("", "N/A"))
      )
    ) |>
    dplyr::arrange(run_number, step)

  col_names <-
    data |>
    names() |>
    stringr::str_subset("run_number", negate = TRUE)

  # fmt: skip
  col_pattern <- paste0(
    c("_final$","_min$", "_max$", "_mean$", "_total_steps$"),
    collapse = "|"
  )

  data |>
    dplyr::left_join(
      y = statistics |>
        dplyr::select(-dplyr::matches(col_pattern)),
      by = "run_number",
    ) |>
    dplyr::relocate(
      dplyr::all_of(col_names),
      .after = dplyr::last_col()
    )
}
