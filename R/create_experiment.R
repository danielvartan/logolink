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
#' ## Enclosing
#'
#' Since NetLogo only accepts double quotes for strings inside commands, we
#' recommend always using single quotes when writing commands in R. For example,
#' to run the `setup` command, use `'setup'`, not `"setup"`.
#'
#' ## `character` strings
#'
#' [`character`][base::character()] strings should be passed as is, without
#' adding quotes to them. For example, to set the variable `scenario` to
#' `"SSP-585"`, you should use `list("scenario" = "SSP-585")`, not
#' `list("scenario" = '"SSP-585"')`.
#'
#' Insert quotes only if the command requires them. For example:
#' `'n-values 10 ["N/A"]'`.
#'
#' ## Multiple Commands
#'
#' Some arguments accept multiple NetLogo commands to be run in sequence. In
#' such cases, you can provide a [`character`][base::character()] vector with
#' each command as a separate element.
#'
#' For example, to run two commands in sequence for the `go` argument,
#' you can provide:
#'
#' ```r
#' go = c("command-1", "command-2")
#' ```
#'
#' ## `constants` Argument
#'
#' The `constants` argument allows you to specify the parameters to vary in the
#' experiment. It should be a named [`list`][base::list()] where each name
#' corresponds to a NetLogo global variable. The value for each name can be
#' either:
#'
#' - A scalar or vector (for enumerated values). For example, to set the
#'   variable `initial-number-of-turtles` to `10`, you would use
#'   `list("initial-number-of-turtles" = 10)`.
#' - A [`list`][base::list()] with `first`, `step`, and `last` elements (for
#'   stepped values). For example, to vary the variable
#'   `initial-number-of-turtles` from `10` to `50` in steps of `10`, you would
#'   use
#' `list("initial-number-of-turtles" = list(first = 10, step = 10, last = 50))`.
#'
#' @param name (optional) A [`character`][base::character()] string specifying
#'   the name of the experiment (default: `""`).
#' @param repetitions (optional) An integer number specifying the number of
#'   times to repeat the experiment (default: `1`).
#' @param sequential_run_order (optional) A [`logical`][base::logical()] flag
#'   indicating whether to run the experiments in sequential order
#'   (default: `TRUE`).
#' @param run_metrics_every_step (optional) A [`logical`][base::logical()] flag
#'   indicating whether to record metrics at every step (default: `FALSE`).
#' @param time_limit (optional) An integer number specifying the maximum number
#'   of steps to run for each repetition. Set to `0` or `NULL` to have no time
#'   limit (default: `1`).
#' @param pre_experiment (optional) A [`character`][base::character()] string
#'   specifying the NetLogo command(s) to run before the experiment starts. This
#'   can be a single command or multiple commands provided as a
#'   [`character`][base::character()] vector; see the *Details > Multiple
#'   Commands* section for usage (default: `NULL`).
#' @param setup (optional) A [`character`][base::character()] vector specifying
#'   the NetLogo command(s) to set up the model. This can be a single command or
#'   multiple commands provided as a [`character`][base::character()] vector
#'   (default: `'setup'`).
#' @param go (optional) A [`character`][base::character()] vector specifying the
#'   NetLogo command(s) to run the model. This can be a single command or
#'   multiple commands provided as a [`character`][base::character()] vector
#'   (default: `'go'`).
#' @param post_run (optional) A [`character`][base::character()] string
#'   specifying the NetLogo command(s) to run after each run. This can be a
#'   single command or multiple commands provided as a
#'   [`character`][base::character()] vector (default: `NULL`).
#' @param post_experiment (optional) A [`character`][base::character()] string
#'   specifying the NetLogo command(s) to run after the experiment ends. This
#'   can be a single command or multiple commands provided as a
#'   [`character`][base::character()] vector (default: `NULL`).
#' @param exit_condition (optional) A [`character`][base::character()] string
#'   specifying the NetLogo command that defines the exit condition for the
#'   experiment (default: `NULL`).
#' @param run_metrics_condition (optional) A [`character`][base::character()]
#'   string specifying the NetLogo command that defines the condition to record
#'   metrics (default: `NULL`).
#' @param metrics A [`character`][base::character()] vector specifying the
#'   NetLogo commands to record as metrics
#'   (default: `c('count turtles', 'count patches')`).
#' @param constants (optional) A named [`list`][base::list()] specifying the
#'   parameters for the experiment. Each element can be either a scalar,
#'   vector (for fixed/enumerated values), or a [`list`][base::list()] with
#'   `first`, `step`, and `last` elements (for stepped/varying values). See the
#'   *Details* and *Examples* sections to learn more (default: `NULL`).
#' @param sub_experiments (optional) A [`list`][base::list()] where each element
#'   is a named [`list`][base::list()] specifying the constants for a
#'   sub-experiment. Each sub-experiment uses the same structure as the
#'   `constants` argument. See the `constants` argument documentation for
#'   details on how to specify parameter values (default: `NULL`).
#' @param file (optional) A [`character`][base::character()] string specifying
#'   the path to save the created XML file
#'   (default: `tempfile(pattern = "experiment-", fileext = ".xml")`).
#'
#' @return A [`character`][base::character()] string with the path to the
#'   created XML file.
#'
#' @family NetLogo functions
#' @export
#'
#' @examples
#' # The examples below reproduce experiments from the NetLogo Models Library.
#' # Try exporting these experiments from NetLogo and compare the XML files.
#'
#' ## Examples from the *Wolf Sheep Predation* Model (Sample Models) ----
#'
#' ### BehaviorSpace Combinatorial
#'
#' setup_file <- create_experiment(
#'   name = "BehaviorSpace Combinatorial",
#'   repetitions = 1,
#'   sequential_run_order = TRUE,
#'   run_metrics_every_step = FALSE,
#'   time_limit = 1500,
#'   setup = 'setup',
#'   go = 'go',
#'   post_run = 'wait .5',
#'   run_metrics_condition = 'ticks mod 10 = 0',
#'   metrics = c(
#'     'count sheep',
#'     'count wolves',
#'     'count grass'
#'   ),
#'   constants = list(
#'     "model-version" = "sheep-wolves-grass",
#'     "wolf-reproduce" = c(3, 5, 10, 15),
#'     "wolf-gain-from-food" = c(10, 15, 30, 40)
#'   )
#' )
#'
#' setup_file
#'
#' setup_file |> inspect_experiment_file()
#'
#' ### Behaviorspace Run 3 Experiments
#'
#' setup_file <- create_experiment(
#'   name = "Behaviorspace Run 3 Experiments",
#'   repetitions = 1,
#'   sequential_run_order = TRUE,
#'   run_metrics_every_step = FALSE,
#'   time_limit = 1500,
#'   setup = c(
#'     'setup',
#'     paste0(
#'       'print (word "sheep-reproduce: " sheep-reproduce ", wolf-reproduce: ',
#'       '" wolf-reproduce)'
#'     ),
#'     paste0(
#'       'print (word "sheep-gain-from-food: " sheep-gain-from-food ", ',
#'       'wolf-gain-from-food: " wolf-gain-from-food)'
#'     )
#'   ),
#'   go = 'go',
#'   post_run = c(
#'     'print (word "sheep: " count sheep ", wolves: " count wolves)',
#'     'print ""',
#'     'wait 1'
#'   ),
#'   run_metrics_condition = 'ticks mod 10 = 0',
#'   metrics = c(
#'     'count sheep',
#'     'count wolves',
#'     'count grass'
#'   ),
#'   constants = list(
#'     "model-version" = "sheep-wolves-grass"
#'   ),
#'   sub_experiments = list(
#'     list(
#'       "sheep-reproduce" = 1,
#'       "sheep-gain-from-food" = 1,
#'       "wolf-reproduce" = 2,
#'       "wolf-gain-from-food" = 10
#'     ),
#'     list(
#'       "sheep-reproduce" = 6,
#'       "sheep-gain-from-food" = 8,
#'       "wolf-reproduce" = 5,
#'       "wolf-gain-from-food" = 20
#'     ),
#'     list(
#'       "sheep-reproduce" = 20,
#'       "sheep-gain-from-food" = 15,
#'       "wolf-reproduce" = 15,
#'       "wolf-gain-from-food" = 30
#'     )
#'   )
#' )
#'
#' setup_file
#'
#' setup_file |> inspect_experiment_file()
#'
#' ### BehaviorSpace Run 3 Variable Values Per Experiments
#'
#' setup_file <- create_experiment(
#'   name = "BehaviorSpace Run 3 Variable Values Per Experiments",
#'   repetitions = 1,
#'   sequential_run_order = TRUE,
#'   run_metrics_every_step = FALSE,
#'   time_limit = 1500,
#'   setup = c(
#'     'setup',
#'     paste0(
#'       'print (word "sheep-reproduce: " sheep-reproduce ", ',
#'       'wolf-reproduce: " wolf-reproduce)'
#'     ),
#'     paste0(
#'       'print (word "sheep-gain-from-food: " sheep-gain-from-food ", ',
#'       'wolf-gain-from-food: " wolf-gain-from-food)'
#'     )
#'   ),
#'   go = 'go',
#'   post_run = c(
#'     'print (word "sheep: " count sheep ", wolves: " count wolves)',
#'     'print ""',
#'     'wait 1'
#'   ),
#'   run_metrics_condition = 'ticks mod 10 = 0',
#'   metrics = c(
#'     'count sheep',
#'     'count wolves',
#'     'count grass'
#'   ),
#'   constants = list(
#'     "model-version" = "sheep-wolves-grass",
#'     "sheep-reproduce" = 4,
#'     "wolf-reproduce" = 2,
#'     "sheep-gain-from-food" = 4,
#'     "wolf-gain-from-food" = 20
#'   ),
#'   sub_experiments = list(
#'     list(
#'       "sheep-reproduce" = c(1, 6, 20)
#'     ),
#'     list(
#'       "wolf-reproduce" = c(2, 7, 15)
#'     ),
#'     list(
#'       "sheep-gain-from-food" = c(1, 8, 15)
#'     ),
#'     list(
#'       "wolf-gain-from-food" = c(10, 20, 30)
#'     )
#'   )
#' )
#'
#' setup_file
#'
#' setup_file |> inspect_experiment_file()
#'
#' ## Examples from the *Spread of Disease* Model (IABM Textbook) ----
#'
#' ### Population Density
#'
#' setup_file <- create_experiment(
#'   name = "Population Density",
#'   repetitions = 10,
#'   sequential_run_order = TRUE,
#'   run_metrics_every_step = FALSE,
#'   time_limit = NULL,
#'   setup = 'setup',
#'   go = 'go',
#'   metrics = 'ticks',
#'   constants = list(
#'     "variant" = "mobile",
#'     "connections-per-node" = 4.1,
#'     "num-people" = list(
#'       first = 50,
#'       step = 50,
#'       last = 200
#'     ),
#'     "num-infected" = 1,
#'     "disease-decay" = 0
#'   )
#' )
#'
#' setup_file
#'
#' setup_file |> inspect_experiment_file()
#'
#' ### Degree
#'
#' setup_file <- create_experiment(
#'   name = "Degree",
#'   repetitions = 10,
#'   sequential_run_order = TRUE,
#'   run_metrics_every_step = FALSE,
#'   time_limit = 50,
#'   setup = 'setup',
#'   go = 'go',
#'   metrics = 'count turtles with [infected?]',
#'   constants = list(
#'     "num-people" = 200,
#'     "connections-per-node" = list(
#'       first = 0.5,
#'       step = 0.5,
#'       last = 4
#'     ),
#'     "disease-decay" = 10,
#'     "variant" = "network",
#'     "num-infected" = 1
#'   )
#' )
#'
#' setup_file
#'
#' setup_file |> inspect_experiment_file()
#'
#' ### Environmental
#'
#' setup_file <- create_experiment(
#'   name = "Environmental",
#'   repetitions = 10,
#'   sequential_run_order = TRUE,
#'   run_metrics_every_step = FALSE,
#'   time_limit = NULL,
#'   setup = 'setup',
#'   go = 'go',
#'   metrics = 'ticks',
#'   constants = list(
#'     "num-people" = 200,
#'     "connections-per-node" = 4,
#'     "disease-decay" = list(
#'       first = 0,
#'       step = 1,
#'       last = 10
#'     ),
#'     "variant" = "environmental",
#'     "num-infected" = 1
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
  time_limit = 1,
  pre_experiment = NULL,
  setup = 'setup',
  go = 'go',
  post_run = NULL,
  post_experiment = NULL,
  exit_condition = NULL,
  run_metrics_condition = NULL,
  metrics = c('count turtles', 'count patches'),
  constants = NULL,
  sub_experiments = NULL,
  file = tempfile(pattern = "experiment-", fileext = ".xml")
) {
  checkmate::assert_string(name)
  checkmate::assert_int(repetitions, lower = 1)
  checkmate::assert_flag(sequential_run_order)
  checkmate::assert_flag(run_metrics_every_step)
  checkmate::assert_int(time_limit, lower = 0, null.ok = TRUE)
  checkmate::assert_character(pre_experiment, null.ok = TRUE)
  checkmate::assert_character(setup, null.ok = TRUE)
  checkmate::assert_character(go, null.ok = TRUE)
  checkmate::assert_character(post_run, null.ok = TRUE)
  checkmate::assert_character(post_experiment, null.ok = TRUE)
  checkmate::assert_character(exit_condition, null.ok = TRUE)
  checkmate::assert_character(run_metrics_condition, null.ok = TRUE)
  checkmate::assert_character(metrics, min.len = 1)
  checkmate::assert_list(constants, names = "named", null.ok = TRUE)
  checkmate::assert_list(sub_experiments, null.ok = TRUE)
  checkmate::assert_path_for_output(file, overwrite = TRUE, extension = "xml")

  # See:
  # https://github.com/NetLogo/NetLogo/wiki/
  # XML-File-Format#behaviorspace-experiments

  root <- xml2::xml_new_root("experiments")

  args <- c(
    name = name |> unname(),
    repetitions = repetitions |> unname(),
    sequentialRunOrder = tolower(sequential_run_order) |> unname(),
    runMetricsEveryStep = tolower(run_metrics_every_step) |> unname(),
    if (!is.null(time_limit) && (time_limit != 0)) {
      list(timeLimit = time_limit |> unname())
    }
  )

  experiment <- do.call(
    xml2::xml_add_child,
    c(
      list(
        .x = root,
        .value = "experiment"
      ),
      args
    )
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
    i_value <-
      simple_elements |>
      magrittr::extract2(i) |>
      unname()

    if (!is.null(i_value)) {
      experiment |>
        xml2::xml_add_child(
          .value = simple_elements |>
            names() |>
            magrittr::extract(i),
          paste0(i_value, collapse = "\n")
        )
    }
  }

  metrics_node <-
    experiment |>
    xml2::xml_add_child("metrics")

  for (i in metrics) {
    metrics_node |>
      xml2::xml_add_child(
        .value = "metric",
        unname(i)
      )
  }

  if (!is.null(constants)) {
    constants_node <-
      experiment |>
      xml2::xml_add_child("constants")

    constants_node |>
      create_experiment.value_sets(constants)
  }

  if (!is.null(sub_experiments)) {
    sub_experiments_node <-
      experiment |>
      xml2::xml_add_child("subExperiments")

    for (i in seq_along(sub_experiments)) {
      i_constants <-
        sub_experiments |>
        magrittr::extract2(i)

      i_node <-
        sub_experiments_node |>
        xml2::xml_add_child("subExperiment")

      i_node |>
        create_experiment.value_sets(i_constants)
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

create_experiment.value_sets <- function(node, constants) {
  checkmate::assert_class(node, "xml_node")
  checkmate::assert_list(constants, names = "named", null.ok = TRUE)

  if (!is.null(constants) && length(constants) > 0) {
    for (i in seq_along(constants)) {
      i_value <- constants |> magrittr::extract2(i)

      if (is.list(i_value)) {
        checkmate::assert_subset(names(i_value), c("first", "step", "last"))
        checkmate::assert_number(i_value$first)
        checkmate::assert_number(i_value$step, lower = 0.00001)
        checkmate::assert_number(i_value$last)

        node |>
          xml2::xml_add_child(
            .value = "steppedValueSet",
            NULL,
            variable = constants |>
              names() |>
              magrittr::extract(i),
            first = i_value$first |> unname(),
            step = i_value$step |> unname(),
            last = i_value$last |> unname()
          )
      } else {
        if (is.character(i_value)) {
          i_value <- paste0('\"', i_value, '\"')
        }
        if (is.logical(i_value)) {
          i_value <- tolower(i_value)
        }

        i_node <-
          node |>
          xml2::xml_add_child(
            .value = "enumeratedValueSet",
            variable = constants |>
              names() |>
              magrittr::extract(i)
          )

        for (j in i_value) {
          i_node |>
            xml2::xml_add_child(
              .value = "value",
              NULL,
              value = unname(j)
            )
        }
      }
    }
  }
}
