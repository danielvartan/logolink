#' Inspect a BehaviorSpace experiment XML file
#'
#' @description
#'
#' `inspect_experiment_file()` reads and prints the content of a
#' BehaviorSpace experiment XML file. This is useful for debugging and
#' understanding the structure of the experiment file.
#'
#' @param file A [`character`][base::character] string specifying the path to
#'   the BehaviorSpace experiment XML file.
#'
#' @return An [invisible][base::invisible] `NULL`. This function is used for its
#' side effect.
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
