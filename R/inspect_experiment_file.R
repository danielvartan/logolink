#' Inspect a BehaviorSpace experiment XML file
#'
#' @description
#'
#' `inspect_experiment_file()` reads and prints the content of a
#' BehaviorSpace experiment XML file to the console. This is useful for
#' debugging and verifying the structure of experiment files created by
#' [`create_experiment()`][create_experiment()].
#'
#' @param file A [`character`][base::character()] string specifying the path to
#'   the BehaviorSpace experiment XML file.
#'
#' @return An [invisible][base::invisible()] `NULL`. This function is called for
#'   its side effect of printing the XML content to the console.
#'
#' @family utility functions
#' @export
#'
#' @examples
#' file <- create_experiment(name = "My Experiment")
#'
#' file |> inspect_experiment_file()
inspect_experiment_file <- function(file) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file, access = "r", extension = "xml")

  file |>
    readr::read_lines() |>
    paste(collapse = "\n") |>
    cat()

  invisible()
}
