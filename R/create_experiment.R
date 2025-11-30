#' Create a NetLogo BehaviorSpace experiment
#'
#' @description
#'
#' `create_experiment()` creates a NetLogo BehaviorSpace experiment XML in a
#' temporary file that can be used to run headless experiments with the
#' [`run_experiment()`][run_experiment()] function.
#'
#' Please refer to the
#' [BehaviorSpace Guide](https://docs.netlogo.org/behaviorspace.html) for
#' complete guidance on how to set and run experiments in NetLogo.
#'
#' @details
#'
#' ## Constants
#'
#' The `constants` argument allows you to specify the parameters to vary in the
#' experiment. It should be a named [`list`][base::list] where each name
#' corresponds to a NetLogo variable. The value for each name can be either:
#'
#' - A single value (for enumerated values). For example, to set the variable
#'  `initial-number-of-turtles` to `10`, you would use
#' `list("initial-number-of-turtles" = 10)`.
#' - A [`list`][list()] with `first`, `step`, and `last` elements (for stepped
#'  values). For example, to vary the variable `initial-number-of-turtles` from
#' `10` to `50` in steps of `10`, you would use
#' `list("initial-number-of-turtles" = list(first = 10, step = 10, last = 50))`.
#'
#' Please note that any mistake in the constants names will cause the experiment
#' to return an empty result set. Be careful when changing them.
#'
#' Also, enclose commands with single quotes (e.g., `'n-values 10 ["N/A"]'`),
#' since NetLogo only accepts double quotes for strings.
#'
#' @param name (optional) A [`character`][base::character] string specifying the
#'   name of the experiment (default: `""`).
#' @param repetitions (optional) An integer number specifying the number of
#'   times to repeat the experiment (default: `1`).
#' @param sequential_run_order (optional) A [`logical`][logical] flag
#'   indicating whether to run the experiments in sequential order
#'   (default: `TRUE`).
#' @param run_metrics_every_step (optional) A [`logical`][logical] flag
#'   indicating whether to record metrics at every step (default: `FALSE`).
#' @param pre_experiment (optional) A [`character`][base::character] string
#'   specifying the NetLogo command to run before the experiment starts
#'   (default: `NULL`).
#' @param setup (optional) A [`character`][base::character] string specifying
#'   the NetLogo command to set up the model (default: `"setup"`).
#' @param go (optional) A [`character`][base::character] string specifying the
#'   NetLogo command to run the model (default: `"go"`).
#' @param post_run (optional) A [`character`][base::character] string specifying
#'   the NetLogo command to run after each run (default: `NULL`).
#' @param post_experiment (optional) A [`character`][base::character] string
#'   specifying the NetLogo command to run after the experiment ends (default:
#'   `NULL`).
#' @param time_limit (optional) An integer number specifying the maximum number
#'   of steps to run for each repetition (default: `1`).
#' @param exit_condition (optional) A [`character`][base::character] string
#'   specifying the NetLogo command that defines the exit condition for the
#'   experiment (default: `NULL`).
#' @param metrics A [`character`][base::character] vector specifying the NetLogo
#'   commands to record as metrics
#'   (default: `c('count turtles', 'count patches')`).
#' @param run_metrics_condition (optional) A [`character`][base::character]
#'   string specifying the NetLogo command that defines the condition to record
#'   metrics (default: `NULL`).
#' @param constants (optional) A named [`list`][base::list] specifying the
#'   constants to vary in the experiment. Each element can be either a single
#'   value (for enumerated values) or a [`list`][base::list] with `first`,
#'   `step`, and `last` elements (for stepped values). See the *Details* and
#'   *Examples* sections to learn more (default: `NULL`).
#' @param file (optional) A [`character`][base::character] string specifying the
#'   path to save the created XML file
#'   (default: `tempfile(pattern = "experiment-", fileext = ".xml")`).
#'
#' @return A [`character`][base::character] string with the path to the created
#'   XML file.
#'
#' @family NetLogo functions
#' @export
#'
#' @examples
#' setup_file <- create_experiment(
#'   name = "Wolf Sheep Simple Model Analysis",
#'   repetitions = 10,
#'   sequential_run_order = TRUE,
#'   run_metrics_every_step = TRUE,
#'   setup = "setup",
#'   go = "go",
#'   time_limit = 1000,
#'   metrics = c(
#'     'count wolves',
#'     'count sheep'
#'   ),
#'   run_metrics_condition = NULL,
#'   constants = list(
#'     "number-of-sheep" = 500,
#'     "number-of-wolves" = list(
#'       first = 5,
#'       step = 1,
#'       last = 15
#'     ),
#'     "movement-cost" = 0.5,
#'     "grass-regrowth-rate" = 0.3,
#'     "energy-gain-from-grass" = 2,
#'     "energy-gain-from-sheep" = 5
#'   )
#' )
#'
#' setup_file
#'
#' setup_file |> inspect_experiment_file()
create_experiment <- function(
  name = "",
  repetitions = 1,
  sequential_run_order = TRUE,
  run_metrics_every_step = FALSE,
  pre_experiment = NULL,
  setup = "setup",
  go = "go",
  post_run = NULL,
  post_experiment = NULL,
  time_limit = 1,
  exit_condition = NULL,
  metrics = c('count turtles', 'count patches'),
  run_metrics_condition = NULL,
  constants = NULL,
  file = tempfile(pattern = "experiment-", fileext = ".xml")
) {
  checkmate::assert_string(name)
  checkmate::assert_int(repetitions, lower = 1)
  checkmate::assert_flag(sequential_run_order)
  checkmate::assert_flag(run_metrics_every_step)
  checkmate::assert_string(pre_experiment, null.ok = TRUE)
  checkmate::assert_string(setup, null.ok = TRUE)
  checkmate::assert_string(go, null.ok = TRUE)
  checkmate::assert_string(post_run, null.ok = TRUE)
  checkmate::assert_string(post_experiment, null.ok = TRUE)
  checkmate::assert_int(time_limit, lower = 1)
  checkmate::assert_string(exit_condition, null.ok = TRUE)
  checkmate::assert_character(metrics, min.len = 1)
  checkmate::assert_string(run_metrics_condition, null.ok = TRUE)
  checkmate::assert_list(constants, names = "named", null.ok = TRUE)
  checkmate::assert_path_for_output(file, overwrite = TRUE, extension = "xml")

  root <- xml2::xml_new_root("experiments")

  experiment <-
    root |>
    xml2::xml_add_child(
      "experiment",
      name = name |> unname(),
      repetitions = repetitions |> unname(),
      sequentialRunOrder = tolower(sequential_run_order) |> unname(),
      runMetricsEveryStep = tolower(run_metrics_every_step) |> unname(),
      timeLimit = time_limit |> unname()
    )

  simple_elements <- list(
    "preExperiment" = pre_experiment,
    "setup" = setup,
    "go" = go,
    "postRun" = post_run,
    "postExperiment" = post_experiment,
    "exitCondition" = exit_condition,
    "runMetricsCondition" = run_metrics_condition
  )

  for (i in seq_along(simple_elements)) {
    i_value <- simple_elements[[i]] |> unname()

    if (!is.null(i_value)) {
      experiment |>
        xml2::xml_add_child(names(simple_elements)[i], i_value)
    }
  }

  metrics_node <-
    experiment |>
    xml2::xml_add_child("metrics")

  for (i in metrics) {
    metrics_node |>
      xml2::xml_add_child("metric", i |> unname())
  }

  constants_node <-
    experiment |>
    xml2::xml_add_child("constants")

  if (!is.null(constants) && length(constants) > 0) {
    for (i in seq_along(constants)) {
      i_value <- constants[[i]]

      if (is.list(i_value)) {
        checkmate::assert_subset(names(i_value), c("first", "step", "last"))
        checkmate::assert_number(i_value$first)
        checkmate::assert_int(i_value$step, lower = 1)
        checkmate::assert_number(i_value$last)

        constants_node |>
          xml2::xml_add_child(
            "steppedValueSet",
            NULL,
            variable = names(constants)[i],
            first = i_value$first |> unname(),
            step = i_value$step |> unname(),
            last = i_value$last |> unname()
          )
      } else {
        if (is.character(i_value)) i_value <- paste0('\"', i_value, '\"')
        if (is.logical(i_value)) i_value <- tolower(i_value)

        constants_node |>
          xml2::xml_add_child(
            "enumeratedValueSet",
            variable = names(constants)[i]
          ) |>
          xml2::xml_add_child("value", NULL, value = i_value |> unname())
      }
    }
  }

  root |> xml2::write_xml(file)

  file |>
    readr::read_lines() |>
    magrittr::extract(-1) |>
    stringr::str_remove_all("NULL") |>
    readr::write_lines(file)

  file
}
