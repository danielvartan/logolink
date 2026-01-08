#' Inspect NetLogo BehaviorSpace experiment file
#'
#' @description
#'
#' `inspect_experiment()` reads and prints the content of a NetLogo
#' [BehaviorSpace](https://docs.netlogo.org/behaviorspace.html)
#' experiment
#' [XML](https://en.wikipedia.org/wiki/XML)
#' file to the R console. This is useful for debugging and verifying the
#' structure of experiment files created by
#' [`create_experiment()`][create_experiment()].
#'
#' For complete guidance on setting up and running experiments in NetLogo,
#' please refer to the
#' [BehaviorSpace Guide](
#' https://docs.netlogo.org/behaviorspace.html#creating-an-experiment-setup).
#'
#' @param file A [`character`][base::character()] string specifying the path to
#'   the
#'   [BehaviorSpace](https://docs.netlogo.org/behaviorspace.html)
#'   experiment
#'   [XML](https://en.wikipedia.org/wiki/XML)
#'   file.
#'
#' @return An [invisible][base::invisible()] `NULL`. This function is called for
#'   its side effect of printing the
#'   [XML](https://en.wikipedia.org/wiki/XML)
#'   content to the R console.
#'
#' @family BehaviorSpace functions
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
