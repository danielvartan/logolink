read_experiment_spreadsheet <- function(file, tidy_output = TRUE) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file, extension = "csv")
  checkmate::assert_flag(tidy_output)

  # R CMD Check variable bindings fix.
  # nolint start
  . <- X1 <- value <- where <- run_number <- reporter <- measure <- NULL
  # nolint end

  lines <- file |> readr::read_lines()

  data_index <-
    lines |>
    stringr::str_remove_all('\"') |>
    stringr::str_which("^\\[total steps\\]") |>
    magrittr::add(2)

  stats_data <-
    file |>
    readr::read_delim(
      delim = ",",
      col_names = FALSE,
      col_types = readr::cols(.default = readr::col_character()),
      na = c("", "N/A"),
      skip = 6,
      n_max = data_index - 8, # the first 6 lines + 2
      progress = FALSE,
      show_col_types = FALSE
    ) |>
    dplyr::as_tibble()

  data <-
    file |>
    readr::read_delim(
      delim = ",",
      col_names = FALSE,
      col_types = readr::cols(.default = readr::col_character()),
      na = c("", "N/A"),
      skip = 6,
      progress = FALSE,
      show_col_types = FALSE
    ) |>
    dplyr::slice(-(seq(2, data_index - 8))) |>
    dplyr::select(-1) |>
    t() |>
    as.data.frame() |>
    dplyr::as_tibble() %>%
    magrittr::set_colnames(
      c(
        "run_number",
        "reporter",
        paste0(
          "measure_",
          seq_len(ncol(.) - 2)
        )
      )
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
  } else {
    stats_data <-
      stats_data |>
      tidyr::pivot_longer(-X1) |>
      tidyr::pivot_wider(names_from = X1, values_from = value) |>
      dplyr::select(-1) |>
      tidyr::fill(dplyr::everything(), .direction = "down") |>
      janitor::clean_names()

    data <-
      data |>
      dplyr::select(where(\(x) !all(is.na(x)))) |>
      tidyr::pivot_longer(
        cols = -c(run_number, reporter),
        names_to = "measure"
      ) |>
      dplyr::mutate(
        measure = stringr::str_remove(measure, "^measure_"),
        dplyr::across(
          dplyr::everything(),
          \(x) readr::parse_guess(x, na = c("", "N/A"))
        )
      )
  }

  list(
    statistics = stats_data,
    measures = data
  )
}
