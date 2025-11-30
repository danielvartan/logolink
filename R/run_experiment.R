#' Run a NetLogo BehaviorSpace experiment
#'
#' @description
#'
#' `run_experiment()` runs a NetLogo BehaviorSpace experiment in headless mode
#' and returns the results as a tidy data frame. It can be used with
#' [`create_experiment()`][create_experiment()] to create the experiment XML
#' file on the fly, or with an existing experiment stored in the NetLogo model
#' file.
#'
#' The function tries to locate the NetLogo installation automatically.
#' This is usually successful, but if it fails, you will need to set it
#' manually. In the latter case, see *Details* section for more information.
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
#' Windows, a typical path is something like `C:\Program Files\NetLogo 7.0.2`.
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
#' please try to set a `NETLOGO_CONSOLE` environment variable with the path of
#' the NetLogo executable or binary. On Windows, a typical path is something
#' like `C:\Program Files\NetLogo 7.0.2\NetLogo.exe`.
#'
#' ## Non-Tabular Output
#'
#' If the experiment generates any non-tabular output (e.g., prints, error
#' messages, warnings), this output will be captured and displayed as an
#' informational message after the results data frame is returned. This allows
#' you to see any important messages generated during the experiment run.
#' Keep in mind that excessive non-tabular output may clutter your R console.
#'
#' @param model_path A string specifying the path to the NetLogo model file
#'   (with extension `.nlogo`, `.nlogo3d`, `.nlogox`, or `.nlogox3d`).
#' @param experiment (optional) A string specifying the name of the experiment
#'   defined in the NetLogo model file (default: `NULL`).
#' @param setup_file (optional) A string specifying the path to an XML file
#'   containing the experiment definition. This file can be created using
#'  [`create_experiment()`][create_experiment()] or exported from the
#'  NetLogo BehaviorSpace interface (default: `NULL`).
#' @param other_arguments (optional) A [`character`][character()] vector
#'   specifying any additional command-line arguments to pass to the NetLogo
#'   executable. For example, you can use `c("--threads 4")` to specify the
#'   number of threads to use (default: `NULL`).
#' @param netlogo_3d (optional) A [`logical`][logical()] flag indicating whether
#'   the model is a 3D model. This is necessary for models with extensions
#'   `.nlogo3d` or `.nlogox3d` (default: `FALSE`).
#' @param parse (optional) A [`logical`][logical()] flag indicating whether to
#'   parse NetLogo lists in the output data frame. If `TRUE`, columns containing
#'   NetLogo lists (e.g., `[1 2 3]`) will be converted to R lists. If `FALSE`,
#'   the columns will remain as [`character`][character()] strings
#'   (default: `TRUE`).
#' @param timeout (optional) A [`numeric`][numeric()] value specifying the
#'   maximum time (in seconds) to wait for the NetLogo process to complete. If
#'   the process exceeds this time limit, it will be terminated, and the
#'   function will return the available output up to that point. Use `Inf`
#'   for no time limit (default: `Inf`).
#' @param netlogo_path `r lifecycle::badge("deprecated")` This argument is no
#'   longer supported. See the *Details* section for more information.
#'
#' @return A [`tibble`][dplyr::as_tibble()] containing the results of the
#'   experiment.
#'
#' @template params-netlogo-home
#' @family NetLogo functions
#' @export
#'
#' @examples
#' # Set the Environment -----
#'
#' \dontrun{
#'   ## Change the path below to point to your NetLogo installation folder.
#'   Sys.setenv(
#'     "NETLOGO_HOME" = file.path("C:", "Program Files", "NetLogo 7.0.2")
#'   )
#'
#'   model_path <-
#'     Sys.getenv("NETLOGO_HOME") |>
#'     file.path(
#'       "models", "IABM Textbook", "chapter 4", "Wolf Sheep Simple 5.nlogox"
#'     )
#' }
#'
#' # Using `create_experiment()` to Create the Experiment XML File -----
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
#'
#'   run_experiment(
#'     model_path = model_path,
#'     setup_file = setup_file
#'   )
#'   ## Expected output:
#'   #> # A tibble: 110,110 × 10
#'   #>   run_number number_of_sheep number_of_wolves movement_cost
#'   #>         <dbl>           <dbl>            <dbl>         <dbl>
#'   #>  1          3             500                5           0.5
#'   #>  2          9             500                5           0.5
#'   #>  3          4             500                5           0.5
#'   #>  4          1             500                5           0.5
#'   #>  5          6             500                5           0.5
#'   #>  6          8             500                5           0.5
#'   #>  7          7             500                5           0.5
#'   #>  8          2             500                5           0.5
#'   #>  9          5             500                5           0.5
#'   #> 10          2             500                5           0.5
#'   #>  # 110,100 more rows
#'   #>  # 6 more variables: grass_regrowth_rate <dbl>,
#'   #>  # energy_gain_from_grass <dbl>, energy_gain_from_sheep <dbl>,
#'   #>  # step <dbl>, count_wolves <dbl>, count_sheep <dbl>
#'   #>  # Use `print(n = ...)` to see more rows
#' }
#'
#' # Using an Experiment Defined in the NetLogo Model File -----
#'
#' \dontrun{
#'   run_experiment(
#'     model_path = model_path,
#'     experiment = "Wolf Sheep Simple model analysis"
#'   )
#'   ## Expected output:
#'   #> # A tibble: 110 × 11
#'   #>    run_number energy_gain_from_grass number_of_wolves movement_cost
#'   #>         <dbl>                  <dbl>            <dbl>         <dbl>
#'   #>  1          4                      2                5           0.5
#'   #>  2          8                      2                5           0.5
#'   #>  3          2                      2                5           0.5
#'   #>  4          9                      2                5           0.5
#'   #>  5          1                      2                5           0.5
#'   #>  6          5                      2                5           0.5
#'   #>  7          7                      2                5           0.5
#'   #>  8          3                      2                5           0.5
#'   #>  9          6                      2                5           0.5
#'   #> 10         12                      2                6           0.5
#'   #> # 100 more rows
#'   #> # 7 more variables: energy_gain_from_sheep <dbl>,
#'   #> # number_of_sheep <dbl>, grass_regrowth_rate <dbl>, step <dbl>,
#'   #> # count_wolves <dbl>, count_sheep <dbl>,
#'   #> # sum_grass_amount_of_patches <dbl>
#'   #> # Use `print(n = ...)` to see more rows
#' }
run_experiment <- function(
  model_path,
  experiment = NULL,
  setup_file = NULL,
  other_arguments = NULL,
  netlogo_3d = FALSE,
  parse = TRUE,
  timeout = Inf,
  netlogo_home = find_netlogo_home(),
  netlogo_path = lifecycle::deprecated()
) {
  model_path_choices <- c("nlogo", "nlogo3d", "nlogox", "nlogox3d")

  checkmate::assert_string(model_path)
  checkmate::assert_file_exists(model_path)
  checkmate::assert_choice(fs::path_ext(model_path), model_path_choices)
  checkmate::assert_string(experiment, null.ok = TRUE)
  checkmate::assert_string(setup_file, null.ok = TRUE)
  checkmate::assert_character(other_arguments, null.ok = TRUE)
  checkmate::assert_flag(netlogo_3d)
  checkmate::assert_flag(parse)
  checkmate::assert_number(timeout, lower = 0)

  if (!is.null(setup_file)) {
    checkmate::assert_file_exists(setup_file, extension = "xml")
  }

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

  if (lifecycle::is_present(netlogo_path)) {
    lifecycle::deprecate_warn(
      when = "0.1.0.9000",
      what = "run_experiment(netlogo_path)",
      details = paste0(
        "Specifying the NetLogo path via the `netlogo_path` argument ",
        "is deprecated. Please set the NetLogo home directory using the ",
        "`NETLOGO_HOME` environment variable instead ",
        '(e.g., `Sys.setenv("NETLOGO_HOME" = "path")`).'
      )
    )

    if (isTRUE(netlogo_3d)) {
      model_path_choices <- c("nlogo3d", "nlogox3d")

      if (!fs::path_ext(model_path) %in% model_path_choices) {
        cli::cli_abort(
          paste0(
            "The provided model file is not a 3D model. ",
            "When {.strong {cli::col_blue('netlogo_3d')}} is set to ",
            "{.strong TRUE}, the model file must have one of the following ",
            "extensions: ",
            paste0(
              "{.strong {cli::col_red('",
              model_path_choices,
              "')}}",
              collapse = ' or '
            ),
            "."
          )
        )
      }
    }

    checkmate::assert_string(netlogo_path)
    checkmate::assert_file_exists(netlogo_path)

    netlogo_executable <- stringr::str_remove(netlogo_path, "\\.exe$")
  } else {
    if (
      identical(netlogo_home, Sys.getenv("NETLOGO_HOME")) &&
        (Sys.getenv("NETLOGO_HOME") == "")
    ) {
      cli::cli_abort(
        paste0(
          "The NetLogo installation directory is not set. ",
          "Please set it using the ",
          "{.strong {cli::col_red('NETLOGO_HOME')}} environment variable ",
          '(e.g., `Sys.setenv("NETLOGO_HOME" = "[PATH]")`).'
        )
      )
    }

    checkmate::assert_string(netlogo_home)
    checkmate::assert_directory_exists(netlogo_home)

    netlogo_executable <-
      netlogo_home |>
      find_netlogo_console()
  }

  assert_netlogo_works(netlogo_home)

  file <- temp_file(pattern = "table-", fileext = ".csv")
  model_path <- fs::path_expand(model_path)
  timeout <- ifelse(is.infinite(timeout), 0, as.integer(timeout))

  args <- c(
    "--headless ",
    ifelse(
      isTRUE(netlogo_3d),
      "--3D",
      ""
    ),
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
    other_arguments
  )

  command <- glue::glue( #nolint
    "{netlogo_executable} {paste0(args, collapse = ' ')}"
  )

  cli::cli_progress_step("Running model")

  system2_output <-
    system_2(
      command = glue::glue("{netlogo_executable}"),
      args = args,
      stdout = TRUE,
      stderr = TRUE,
      timeout = timeout
    ) |>
    suppressMessages() |>
    suppressWarnings()

  cli::cli_progress_done()

  # print(command)

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
        paste0(
          "NetLogo produced the following error during the experiment run:",
          "\n\n",
          paste(system2_output, collapse = "\n")
        )
      )
    }
  }

  cli::cli_progress_step("Reading output")

  out <-
    file |>
    readr::read_delim(delim = ",", skip = 6) |>
    janitor::clean_names() |>
    suppressWarnings() |>
    suppressMessages()

  cli::cli_progress_done()

  if (isTRUE(parse)) {
    cli::cli_progress_step("Parsing lists")

    out <-
      out |>
      dplyr::mutate(
        dplyr::across(
          .cols = dplyr::everything(),
          .fns = parse_netlogo_list
        )
      )

    cli::cli_progress_done()
  }

  if (nrow(out) == 0) {
    cli::cli_alert_warning("The experiment run did not return any results.")
  }

  if (!length(system2_output) == 0) {
    cli::cli_alert_info(
      paste0(
        "The experiment run generated the following non-tabular output:",
        "\n\n",
        paste(system2_output, collapse = "\n")
      )
    )
  }

  out
}
