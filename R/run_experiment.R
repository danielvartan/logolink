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
#' Note that this function requires the path to the NetLogo installation to be
#' set as an environment variable named `NETLOGO_HOME`. See the *Details*
#' section for more information.
#'
#' For complete guidance on setting up and running experiments in NetLogo,
#' please refer to the
#' [BehaviorSpace Guide](https://docs.netlogo.org/behaviorspace.html).
#'
#' @details
#'
#' `run_experiment()` requires the path to the NetLogo installation to be set
#' as an environment variable named `NETLOGO_HOME`. On Windows, the path
#' typically looks like `C:\Program Files\NetLogo 7.0.0`. You can set this
#' environment variable temporarily in your R session using
#' `Sys.setenv("NETLOGO_HOME" = "[PATH]")`, or permanently by adding it to your
#' [`.Renviron`](https://rstats.wtf/r-startup.html#renviron) file.
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
#' @param parse (optional) A [`logical`][logical()] flag indicating whether to
#'   parse NetLogo lists in the output data frame. If `TRUE`, columns containing
#'   NetLogo lists (e.g., `[1 2 3]`) will be converted to R lists. If `FALSE`,
#'   the columns will remain as [`character`][character()] strings
#'   (default: `TRUE`).
#' @param netlogo_path `r lifecycle::badge("deprecated")` This argument is no
#'   longer supported. See the *Details* section for more information.
#'
#' @return A [`tibble`][dplyr::as_tibble()] containing the results of the
#'   experiment.
#'
#' @family NetLogo functions
#' @export
#'
#' @examples
#' # Set the Environment -----
#'
#' ## Change the path below to point to your NetLogo installation folder.
#' Sys.setenv(
#'   "NETLOGO_HOME" = file.path("C:", "Program Files", "NetLogo 7.0.0")
#' )
#'
#' model_path <-
#'   Sys.getenv("NETLOGO_HOME") |>
#'   file.path(
#'     "models", "IABM Textbook", "chapter 4", "Wolf Sheep Simple 5.nlogox"
#'   )
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
  parse = TRUE,
  netlogo_path = lifecycle::deprecated()
) {
  model_path_choices <- c("nlogo", "nlogo3d", "nlogox", "nlogox3d")

  checkmate::assert_string(model_path)
  checkmate::assert_file_exists(model_path)
  checkmate::assert_choice(fs::path_ext(model_path), model_path_choices)
  checkmate::assert_string(experiment, null.ok = TRUE)
  checkmate::assert_string(setup_file, null.ok = TRUE)
  if (!is.null(setup_file)) {
    checkmate::assert_file_exists(setup_file, extension = "xml")
  }
  checkmate::assert_character(other_arguments, null.ok = TRUE)
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

  if (lifecycle::is_present(netlogo_path)) {
    lifecycle::deprecate_warn(
      when = "0.1.0.9000",
      what = "run_experiment(netlogo_path)",
      details = paste0(
        "Specifying the NetLogo path via the 'netlogo_path' argument ",
        "is deprecated. Please set the NetLogo home directory using the ",
        "'NETLOGO_HOME' environment variable instead ",
        '(e.g., `Sys.setenv("NETLOGO_HOME" = "path")`).'
      )
    )

    checkmate::assert_string(netlogo_path)
    checkmate::assert_file_exists(netlogo_path)
  } else {
    if (Sys.getenv("NETLOGO_HOME") == "") {
      cli::cli_abort(
        paste0(
          "The NetLogo home directory is not set. Please set it using ",
          "the {.strong {cli::col_red('NETLOGO_HOME')}} environment variable ",
          "(e.g., `Sys.setenv(",
          "{.strong {cli::col_blue('NETLOGO_HOME')}} = 'path')`)."
        )
      )
    }

    netlogo_path <-
      Sys.getenv("NETLOGO_HOME") |>
      normalizePath(mustWork = FALSE) |>
      file.path("bin", "NetLogo")
  }

  file <- temp_file(pattern = "table-", fileext = ".csv")

  raw_data <- system_2(
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
      other_arguments
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
    if (isTRUE(parse)) {
      out |>
        dplyr::mutate(
          dplyr::across(
            .cols = dplyr::everything(),
            .fns = parse_netlogo_list
          )
        )
    } else {
      out
    }
  }
}
