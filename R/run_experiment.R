#' Run a NetLogo BehaviorSpace experiment
#'
#' @description
#'
#' `run_experiment()` runs a NetLogo BehaviorSpace experiment in headless mode
#' and returns the results as a tidy data frame. It can be used with
#' [`create_experiment()`][create_experiment()] to create the experiment XML
#' file on the fly, or with an existing experiment defined in an XML file or
#' stored in the NetLogo model file.
#'
#' Please refer to the
#' [BehaviorSpace Guide](https://docs.netlogo.org/behaviorspace.html) for
#' complete guidance on how to set and run experiments in NetLogo.
#'
#' @param netlogo_path A string specifying the path to the NetLogo executable.
#'   In Windows, this is usually something like
#'   `C:/Program Files/NetLogo 7.0.0/NetLogo.exe`.
#' @param model_path A string specifying the path to the NetLogo model file
#'   (with extension `.nlogo`, `.nlogo3d`, `.nlogox`, or `.nlogox3d`).
#' @param experiment (optional) A string specifying the name of the experiment
#'   defined in the NetLogo model file (default: `NULL`).
#' @param setup_file (optional) A string specifying the path to an XML file
#'   containing the experiment definition. This file can be created using
#'  [`create_experiment()`][create_experiment()] or exported from the
#'  NetLogo BehaviorSpace interface (default: `NULL`).
#' @param other_args (optional) A character vector specifying any additional
#'   command-line arguments to pass to the NetLogo executable. For example,
#'   you can use `c("--threads", "4")` to specify the number of threads to use
#'   (default: `NULL`).
#' @param parse (optional) A boolean indicating whether to parse NetLogo lists
#'   in the output data frame (default: `TRUE`). If `TRUE`, columns containing
#'   NetLogo lists (e.g., `[1 2 3]`) will be converted to R lists. If `FALSE`,
#'   the columns will remain as character strings.
#'
#' @return A [`tibble`][dplyr::as_tibble()] containing the results of the
#'   experiment.
#'
#' @family NetLogo functions
#' @export
#'
#' @examples
#' \dontrun{
#'   1 + 1
#' }
run_experiment <- function(
  netlogo_path,
  model_path,
  experiment = NULL,
  setup_file = NULL,
  other_args = NULL,
  parse = TRUE
) {
  model_path_choices <- c("nlogo", "nlogo3d", "nlogox", "nlogox3d")

  checkmate::assert_string(netlogo_path)
  checkmate::assert_string(model_path)
  checkmate::assert_file_exists(model_path)
  checkmate::assert_choice(fs::path_ext(model_path), model_path_choices)
  checkmate::assert_string(experiment, null.ok = TRUE)
  checkmate::assert_string(setup_file, null.ok = TRUE)
  if (!is.null(setup_file)) checkmate::assert_file_exists(setup_file)
  checkmate::assert_character(other_args, null.ok = TRUE)
  checkmate::assert_flag(parse)

  if (is.null(experiment) && is.null(setup_file)) {
    cli::cli_abort(
      paste0(
        "One of {.strong {cli::col_blue('experiment')}} or ",
        "{.strong {cli::col_red('setup_file')}} must be provided."
      )
    )
  }

  if (!is.null(experiment) && !is.null(setup_file)) {
    cli::cli_abort(
      paste0(
        "Only one of {.strong {cli::col_blue('experiment')}} or ",
      "{.strong {cli::col_red('setup_file')}} can be provided."
      )
    )
  }

  file <- tempfile(pattern = "table-", fileext = ".csv")

  raw_data <- system2(
    command = glue::glue("{netlogo_path}"),
    args = c(
      "--headless ",
      glue::glue("--model {glue::double_quote(model_path)}"),
      ifelse(
        !is.null(experiment),
        glue::glue("--experiment {glue::double_quote(experiment)}"),
        ""
      ),
      ifelse(
        !is.null(setup_file),
        glue::glue("--setup-file {glue::double_quote(setup_file)}"),
        ""
      ),
      # "--table -",
      glue::glue("--table {glue::double_quote(file)}"),
      other_args
    ),
    stdout = TRUE,
    stderr = TRUE
  )

  out <-
    file |>
      readr::read_delim(delim = ",", skip = 6) |>
      janitor::clean_names() |>
      suppressWarnings() |>
      suppressMessages()

  if (nrow(out) == 0) {
    raw_data |> paste(collapse = "\n") |> cli::cli_abort()
  } else {
    if(isTRUE(parse)) {
      out |>
        dplyr::mutate(dplyr::across(dplyr::everything(), parse_netlogo_list))
    } else {
      out
    }
  }
}
