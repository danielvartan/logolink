#' Run a NetLogo BehaviorSpace experiment
#'
#' @description
#'
#' `run_experiment()` runs a NetLogo
#' [BehaviorSpace](https://docs.netlogo.org/behaviorspace.html) experiment in
#' headless mode and returns a [`list`][base::list()] with results as [tidy data
#' frames](https://r4ds.hadley.nz/data-tidy.html). It can be used with
#' [`create_experiment()`][create_experiment()] to create the experiment
#' [XML](https://en.wikipedia.org/wiki/XML) file on the fly, or with an existing
#' experiment stored in the NetLogo model file.
#'
#' To avoid issues with list parsing, `run_experiment()` includes support for
#' the special [lists](https://docs.netlogo.org/behaviorspace.html#lists-output)
#' output format. If your experiment includes metrics that return NetLogo lists,
#' include `"lists"` in the `output` argument to capture this output. Columns
#' containing NetLogo lists are returned as [`character`][base::character()]
#' vectors.
#'
#' The function tries to locate the NetLogo installation automatically.
#' This is usually successful, but if it fails, you will need to set it
#' manually. See the *Details* section for more information.
#'
#' For complete guidance on setting up and running experiments in NetLogo,
#' please refer to the
#' [BehaviorSpace Guide](https://docs.netlogo.org/behaviorspace.html).
#'
#' @details
#'
#' ## Setting the NetLogo Installation Path
#'
#' If `run_experiment()` cannot find the NetLogo installation, you will need to
#' set the path manually using the `NETLOGO_HOME` environment variable. On
#' Windows, a typical path is something like `C:\Program Files\NetLogo 7.0.3`.
#' You can set this variable temporarily in your R session with:
#'
#' ```r
#' Sys.setenv(NETLOGO_HOME = "PATH/TO/NETLOGO/INSTALLATION")
#' ```
#'
#' or permanently by adding it to your
#' [`.Renviron`](https://rstats.wtf/r-startup.html#renviron) file.
#'
#' If even after setting the `NETLOGO_HOME` variable you still encounter issues,
#' try setting a `NETLOGO_CONSOLE` environment variable with the path to
#' the NetLogo executable or binary. On Windows, a typical path is something
#' like `C:\Program Files\NetLogo 7.0.3\NetLogo.exe`.
#'
#' ## Handling NetLogo Lists
#'
#' NetLogo uses a specific syntax for lists (e.g., `"[1 2 3]"`) that is
#' incompatible with standard
#' [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) formats. To
#' address this, NetLogo provides a special output format called
#' [lists](https://docs.netlogo.org/behaviorspace.html#lists-output) that
#' exports list metrics in a tabular structure. If your experiment includes
#' metrics that return NetLogo lists, include `"lists"` in the `output`
#' argument to capture this output. Columns containing NetLogo lists are
#' returned as [`character`][base::character()] vectors.
#'
#' The [`parse_netlogo_list()`][parse_netlogo_list()] function is available
#' for parsing list values embedded in other outputs. However, we recommend
#' using it only when necessary, as it can be computationally intensive for
#' large datasets and may not handle all edge cases.
#'
#' ## Additional Command-Line Arguments
#'
#' You can pass additional command-line arguments to the NetLogo executable
#' using the `other_arguments` parameter. This can be useful for specifying
#' options such as the number of threads to use or other NetLogo-specific flags.
#'
#' For example, to specify the number of threads, you can use:
#'
#' ```r
#' run_experiment(
#'   model_path = "path/to/model.nlogox",
#'   setup_file = "path/to/experiment.xml",
#'   other_arguments = c("--threads 4")
#' )
#' ```
#'
#' There are a variety of command-line options available, but some are reserved
#' for internal use by `run_experiment()` and cannot be modified. These are:
#'
#' - `--headless`: Ensures NetLogo runs in headless mode.
#' - `--3D`: Specifies if the model is a 3D model (automatically set based on
#'   the model file extension).
#' - `--model`: Specifies the path to the NetLogo model file.
#' - `--setup-file`: Specifies the path to the experiment XML file.
#' - `--experiment`: Specifies the name of the experiment defined in the model.
#' - `--table`: Specifies the output file for the results table.
#' - `--spreadsheet`: Specifies the output file for the spreadsheet results.
#' - `--lists`: Specifies the output file for the lists results.
#' - `--stats`: Specifies the output file for the statistics results.
#'
#' For a complete list of available options, please refer to the
#' [BehaviorSpace Guide](
#' https://docs.netlogo.org/behaviorspace.html#running-from-the-command-line
#' ).
#'
#' ## NetLogo 3D
#'
#' The function automatically detects whether the provided model is a 3D model
#' (based on the file extension) and adjusts the command-line arguments
#' accordingly. You do not need to set the `--3D` flag manually.
#'
#' ## Non-Tabular Output
#'
#' If the experiment generates any non-tabular output (e.g., prints, error
#' messages, warnings), it will be captured and displayed as an informational
#' message after the results data frame is returned. This allows you to see any
#' important messages generated during the experiment run. Keep in mind that
#' excessive non-tabular output may clutter your R console.
#'
#' @param model_path A [`character`][base::character()] string specifying the
#'   path to the NetLogo model file (with extension `.nlogo`, `.nlogo3d`,
#'   `.nlogox`, or `.nlogox3d`).
#' @param setup_file (optional) A [`character`][base::character()] string
#'   specifying the path to an [XML](https://en.wikipedia.org/wiki/XML) file
#'   containing the experiment definition. This file can be created using
#'   [`create_experiment()`][create_experiment()] or exported from the NetLogo
#'   BehaviorSpace interface (default: `NULL`).
#' @param experiment (optional) A [`character`][base::character()] string
#'   specifying the name of the experiment defined in the NetLogo model file
#'   (default: `NULL`).
#' @param output (optional) A [`character`][base::character()] vector
#'   specifying which output types to generate from the experiment. Valid
#'   options are: `"table"`, `"spreadsheet"`, `"lists"`, and
#'   `"statistics"`. At least one of `"table"` or `"spreadsheet"` must be
#'   included. See the BehaviorSpace documentation on
#'   [formats](https://docs.netlogo.org/behaviorspace.html#run-options-formats)
#'   for details about each output type (default: `c("table", "lists")`).
#' @param other_arguments (optional) A [`character`][base::character()] vector
#'   specifying any additional command-line arguments to pass to the NetLogo
#'   executable. For example, you can use `c("--threads 4")` to specify the
#'   number of threads. See the *Details* section for more information
#'   (default: `NULL`).
#' @param timeout (optional) A [`numeric`][base::numeric()] value specifying the
#'   maximum time (in seconds) to wait for the NetLogo process to complete. If
#'   the process exceeds this time limit, it will be terminated, and the
#'   function will return the available output up to that point. Use `Inf` for
#'   no time limit (default: `Inf`).
#' @param tidy_output (optional) A [`logical`][base::logical()] flag indicating
#'   whether to tidy the output data frames. If `TRUE`, output data frames are
#'   arranged according to [tidy data
#'   principles](https://r4ds.hadley.nz/data-tidy.html). If `FALSE`, only the
#'   default transformations from [`read_delim()`][readr::read_delim()] and
#'   [`clean_names()`][janitor::clean_names()] are applied to the output data
#'   (default: `TRUE`).
#'
#' @return A [`list`][base::list()] containing the experiment results. The list
#'   includes the following elements, depending on the specified `output`:
#'   - `metadata`: A [`list`][base::list()] with metadata about the experiment
#'     run.
#'   - `table`: A [`tibble`][tibble::tibble()] with the results of the
#'     [`table`](https://docs.netlogo.org/behaviorspace.html#table-output)
#'     output (if requested).
#'   - `spreadsheet`: A [`tibble`][tibble::tibble()] with the results of the
#'     [`spreadsheet`](
#'     https://docs.netlogo.org/behaviorspace.html#spreadsheet-output)
#'     output (if requested).
#'   - `lists`: A [`tibble`][tibble::tibble()] with the results of the
#'     [`lists`](https://docs.netlogo.org/behaviorspace.html#lists-output)
#'     output (if requested).
#'   - `statistics`: A [`tibble`][tibble::tibble()] with the results of the
#'     [`statistics`](
#'     https://docs.netlogo.org/behaviorspace.html#statistics-output)
#'     output (if requested).
#'    See the
#'    [BehaviorSpace Guide](https://docs.netlogo.org/behaviorspace.html)
#'    for details about each output type.
#'
#' @family NetLogo functions
#' @export
#'
#' @examples
#' # Defining the Model -----
#'
#' \dontrun{
#'   model_path <- # This model is included with NetLogo installations.
#'     find_netlogo_home() |>
#'     file.path(
#'       "models",
#'       "IABM Textbook",
#'       "chapter 4",
#'       "Wolf Sheep Simple 5.nlogox"
#'     )
#' }
#'
#' # Creating an Experiment -----
#'
#' \dontrun{
#'   setup_file <- create_experiment(
#'     name = "Wolf Sheep Simple Model Analysis",
#'     repetitions = 10,
#'     sequential_run_order = TRUE,
#'     run_metrics_every_step = TRUE,
#'     setup = "setup",
#'     go = "go",
#'     time_limit = 1000,
#'     metrics = c(
#'       'count wolves',
#'       'count sheep'
#'     ),
#'     run_metrics_condition = NULL,
#'     constants = list(
#'       "number-of-sheep" = 500,
#'       "number-of-wolves" = list(
#'         first = 5,
#'         step = 1,
#'         last = 15
#'       ),
#'       "movement-cost" = 0.5,
#'       "grass-regrowth-rate" = 0.3,
#'       "energy-gain-from-grass" = 2,
#'       "energy-gain-from-sheep" = 5
#'     )
#'   )
#' }
#'
#' # Running the Experiment -----
#'
#' \dontrun{
#'   model_path |>
#'     run_experiment(
#'       setup_file = setup_file
#'     )
#' }
#'
#' # Running an Experiment Defined in the NetLogo Model File -----
#'
#' \dontrun{
#'   model_path |>
#'     run_experiment(
#'       experiment = "Wolf Sheep Simple model analysis"
#'     )
#' }
run_experiment <- function(
  model_path,
  setup_file = NULL,
  experiment = NULL,
  output = "table",
  other_arguments = NULL,
  timeout = Inf,
  tidy_output = TRUE
) {
  model_path_choices <- c("nlogo", "nlogo3d", "nlogox", "nlogox3d")
  output_choices <- c("table", "spreadsheet", "lists", "statistics")

  reserved_arguments <- c(
    "--headless",
    "--3D",
    "--model",
    "--setup-file",
    "--experiment",
    "--table",
    "--spreadsheet",
    "--lists",
    "--stats"
  )

  assert_netlogo_console()
  checkmate::assert_string(model_path)
  checkmate::assert_file_exists(model_path)
  checkmate::assert_choice(fs::path_ext(model_path), model_path_choices)
  checkmate::assert_string(setup_file, null.ok = TRUE)
  checkmate::assert_string(experiment, null.ok = TRUE)
  assert_pick_one(setup_file, experiment)
  checkmate::assert_character(output, min.len = 1)
  checkmate::assert_subset(output, output_choices)
  checkmate::assert_character(other_arguments, null.ok = TRUE)
  assert_other_arguments(other_arguments, reserved_arguments, null_ok = TRUE)
  checkmate::assert_number(timeout, lower = 0)
  checkmate::assert_flag(tidy_output)

  if (!is.null(setup_file)) {
    checkmate::assert_file_exists(setup_file, extension = "xml")
  }

  if (!any(c("table", "spreadsheet") %in% output)) {
    cli::cli_abort(
      paste0(
        "At least one of {.strong {cli::col_blue('table')}} or ",
        "{.strong {cli::col_red('spreadsheet')}} ",
        "must be included in the {.strong output} argument."
      )
    )
  }

  netlogo_console <- find_netlogo_console()
  model_path <- fs::path_expand(model_path)
  timeout <- ifelse(is.infinite(timeout), 0, as.integer(timeout))
  output_argument <- run_experiment.output_argument(output)

  arguments <- c(
    "--headless ",
    ifelse(
      fs::path_ext(model_path) %in% c("nlogo3d", "nlogox3d"),
      "--3D",
      ""
    ),
    glue::glue("--model {glue::double_quote(model_path)}"),
    ifelse(
      !is.null(setup_file),
      glue::glue("--setup-file {glue::double_quote(setup_file)}"),
      ""
    ),
    ifelse(
      !is.null(experiment),
      glue::glue("--experiment {glue::double_quote(experiment)}"),
      ""
    ),
    output_argument |> magrittr::extract2("command"),
    other_arguments
  )

  # "{netlogo_console} {paste0(arguments, collapse = ' ')}" |>
  #   glue::glue() |>
  #   print()

  cli::cli_progress_step("Running model")

  system2_output <-
    netlogo_console |>
    stringr::str_remove("\\.exe$") |>
    system_2(
      args = arguments,
      stdout = TRUE,
      stderr = TRUE,
      timeout = timeout
    ) |>
    suppressMessages() |>
    suppressWarnings()

  cli::cli_progress_done()

  status <-
    system2_output |>
    attributes() |>
    magrittr::extract2("status")

  if (!is.null(status)) {
    if (status == 124) {
      cli::cli_alert_warning(
        paste0(
          "The experiment timed out after ",
          "{.strong {cli::col_red(timeout)}} seconds. ",
          "Results may be incomplete."
        )
      )
    } else {
      cli::cli_abort(
        c(
          "NetLogo produced the following error during the experiment run:",
          "",
          paste(system2_output)
        )
      )
    }
  }

  out <-
    output |>
    run_experiment.gather_output(
      argument = output_argument,
      tidy_output = tidy_output
    )

  if (!length(system2_output) == 0) {
    cli::cli_alert_info(
      paste0(
        "The experiment run produced the following messages:",
        "\n\n",
        paste(system2_output, collapse = "\n")
      )
    )
  }

  out
}

run_experiment.output_argument <- function(output) {
  outputs_choices <- c("table", "spreadsheet", "lists", "statistics")

  checkmate::assert_character(output)
  checkmate::assert_subset(output, outputs_choices)

  output |>
    purrr::map(
      function(x) {
        argument <- ifelse(
          x == "statistics",
          "stats",
          x
        )

        file <- temp_file(pattern = paste0(x, "-"), fileext = ".csv")

        dplyr::tibble(
          argument = argument,
          file = file,
          command = glue::glue("--{argument} {glue::double_quote(file)}")
        )
      }
    ) |>
    purrr::list_rbind()
}

run_experiment.gather_output <- function(
  output,
  argument,
  tidy_output = TRUE
) {
  output_choices <- c("table", "spreadsheet", "lists", "statistics")

  checkmate::assert_subset(output, output_choices)
  checkmate::assert_tibble(argument, ncols = 3)
  checkmate::assert_flag(tidy_output)

  cli::cli_progress_step("Gathering metadata")

  out <- list(
    metadata = argument |>
      dplyr::pull(file) |>
      magrittr::extract(1) |>
      read_experiment_metadata()
  )

  if ("table" %in% output) {
    cli::cli_progress_step("Processing table output")

    out$table <-
      argument |>
      dplyr::filter(argument == "table") |>
      dplyr::pull(file) |>
      read_experiment_table(tidy_output)
  }

  if ("spreadsheet" %in% output) {
    cli::cli_progress_step("Processing spreadsheet output")

    out$spreadsheet <-
      argument |>
      dplyr::filter(argument == "spreadsheet") |>
      dplyr::pull(file) |>
      read_experiment_spreadsheet(tidy_output)
  }

  if ("lists" %in% output) {
    cli::cli_progress_step("Processing lists output")

    out$lists <-
      argument |>
      dplyr::filter(argument == "lists") |>
      dplyr::pull(file) |>
      read_experiment_lists(tidy_output)
  }

  if ("statistics" %in% output) {
    cli::cli_progress_step("Processing statistics output")

    out$statistics <-
      argument |>
      dplyr::filter(argument == "stats") |>
      dplyr::pull(file) |>
      read_experiment_statistics(tidy_output)
  }

  cli::cli_process_done()

  out
}
