#' Inspect a BehaviorSpace experiment XML file
#'
#' @description
#'
#' `inspect_experiment()` reads and prints the content of a
#' [BehaviorSpace](https://docs.netlogo.org/behaviorspace.html) experiment XML
#' file to the console. This is useful for debugging and verifying the
#' structure of experiment files created by
#' [`create_experiment()`][create_experiment()].
#'
#' Please refer to the
#' [BehaviorSpace Guide](https://docs.netlogo.org/behaviorspace.html) for
#' complete guidance on how to set and run experiments in NetLogo.
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
#' file |> inspect_experiment()
inspect_experiment <- function(file) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file, access = "r", extension = "xml")

  file |>
    readLines() |>
    paste(collapse = "\n") |>
    cat()

  invisible()
}
