#' Read NetLogo BehaviorSpace Experiment output
#'
#' @description
#'
#' `read_experiment()` reads NetLogo
#' [BehaviorSpace](https://docs.netlogo.org/behaviorspace.html)
#' experiment output files as
#' [tidy data frames](https://r4ds.hadley.nz/data-tidy.html).
#' It automatically detects the output format
#' ([Table](https://docs.netlogo.org/behaviorspace.html#table-output),
#' [Spreadsheet](
#' https://docs.netlogo.org/behaviorspace.html#spreadsheet-output),
#' [Lists](https://docs.netlogo.org/behaviorspace.html#lists-output), or
#' [Stats](https://docs.netlogo.org/behaviorspace.html#statistics-output))
#' and parses the data accordingly. The function also extracts metadata from
#' the files.
#'
#' Only version 2.0 (NetLogo 6.4 and later) of BehaviorSpace output files is
#' supported.
#'
#' @param file A [`character`][base::character()] string specifying the path to
#'   the
#'   [BehaviorSpace](https://docs.netlogo.org/behaviorspace.html)
#'   output
#'   [CSV](https://en.wikipedia.org/wiki/Comma-separated_values)
#'   file.
#' @inheritParams run_experiment
#'
#' @return A [`list`][base::list()] containing the experiment results. The list
#'   includes the following elements, depending on the output file provided:
#'   - `metadata`: A [`list`][base::list()] with metadata about the experiment
#'     run (present in all cases).
#'   - `table`: A [`tibble`][tibble::tibble()] with the results of the
#'     [`table`](https://docs.netlogo.org/behaviorspace.html#table-output)
#'     output.
#'   - `spreadsheet`: A [`list`][base::list()] with the results of the
#'     [`spreadsheet`](
#'     https://docs.netlogo.org/behaviorspace.html#spreadsheet-output)
#'     output containing two elements:
#'     - `statistics`: A [`tibble`][tibble::tibble()] with data from the
#'       output first section.
#'     - `data`: A [`tibble`][tibble::tibble()] with data from the
#'       output second section.
#'   - `lists`: A [`tibble`][tibble::tibble()] with the results of the
#'     [`lists`](https://docs.netlogo.org/behaviorspace.html#lists-output)
#'     output.
#'   - `statistics`: A [`tibble`][tibble::tibble()] with the results of the
#'     [`statistics`](
#'     https://docs.netlogo.org/behaviorspace.html#statistics-output)
#'     output.
#'
#' @family BehaviorSpace functions
#' @export
#'
#' @examples
#' file <- tempfile()
#'
#' c(
#'   'BehaviorSpace results (NetLogo 7.0.3), "Table version 2.0"',
#'   paste0(
#'     '"/opt/NetLogo 7-0-3/models/',
#'     'IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
#'   ),
#'   '"Wolf Sheep Simple Model Analysis"',
#'   '"01/05/2026 06:37:48:683 -0300"',
#'   '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
#'   '"-17","17","-17","17"',
#'   paste0(
#'     '"[run number]","number-of-sheep","number-of-wolves",',
#'     '"movement-cost","grass-regrowth-rate","energy-gain-from-grass",',
#'     '"energy-gain-from-sheep","[step]","count wolves","count sheep"'
#'   ),
#'   '"3","500","5","0.5","0.3","2","5","0","5","500"',
#'   '"5","500","5","0.5","0.3","2","5","0","5","500"',
#'   '"4","500","5","0.5","0.3","2","5","0","5","500"',
#'   '"6","500","5","0.5","0.3","2","5","0","5","500"',
#'   '"1","500","5","0.5","0.3","2","5","0","5","500"',
#'   '"8","500","5","0.5","0.3","2","5","0","5","500"',
#'   '"9","500","5","0.5","0.3","2","5","0","5","500"',
#'   '"2","500","5","0.5","0.3","2","5","0","5","500"'
#' ) |>
#'   writeLines(file)
#'
#' read_experiment(file)
read_experiment <- function(file, tidy_output = TRUE) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file)
  checkmate::assert_flag(tidy_output)

  assert_behaviorspace_file(file)
  assert_behaviorspace_file_output(file)

  file_header <-
    file |>
    readr::read_lines(
      skip_empty_rows = TRUE,
      n_max = 1
    )

  out <- list(metadata = read_experiment_metadata(file))

  if (stringr::str_detect(file_header, "Table")) {
    out$table <- file |> read_experiment_table()
  } else if (stringr::str_detect(file_header, "Spreadsheet")) {
    out$spreadsheet <-
      file |>
      read_experiment_spreadsheet(tidy_output = tidy_output)
  } else if (stringr::str_detect(file_header, "Lists")) {
    out$lists <- file |> read_experiment_lists(tidy_output = tidy_output)
  } else if (stringr::str_detect(file_header, "Stats")) {
    out$statistics <- file |> read_experiment_statistics()
  } else {
    cli::cli_abort(
      paste0(
        "Unsupported BehaviorSpace output format detected. ",
        "Please open an issue informing us about this at ",
        "{.url https://github.com/danielvartan/logolink/issues}."
      )
    )
  }

  out
}
