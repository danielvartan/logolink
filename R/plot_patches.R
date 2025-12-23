#' Plot NetLogo World Patches
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' `plot_patches()` visualizes the state of NetLogo patches at a specific run
#' and step. Patches are rendered based on their `pcolor` attribute, providing
#' a spatial snapshot of the environment.
#'
#' This function serves as a foundational layer for spatial visualization. Users
#' can extend the resulting plot by adding layers for turtles, links, or other
#' [`ggplot2`](https://ggplot2.tidyverse.org/) components to match their
#' specific model requirements.
#'
#' @details
#'
#' To use this function, your experiment must collect specific patch data.
#' Ensure the following reporters are included in the `metrics` argument of
#' [`run_experiment()`][run_experiment()]:
#'
#' - `[pxcor] of patches`
#' - `[pycor] of patches`
#' - `[pcolor] of patches`
#'
#' These metrics must be available within the `lists` output of the results
#' object.
#'
#' @param results A [`list`][base::list()] of experiment results from
#'   [`run_experiment()`][run_experiment()]. Must contain the `lists` element
#'   with the required patch metrics. See the *Details* section for more
#'   information.
#' @param run_number (optional) An integer number indicating the specific
#'   simulation run to visualize (default: `1`).
#' @param step (optional) An integer number indicating the specific time step
#'   within the run to visualize (default: `0`).
#'
#' @return A [ggplot2::ggplot()] object representing the NetLogo world patches
#'   at the specified run and step.
#'
#' @family plot functions
#' @export
#'
#' @examples
#' # Loading Packages -----
#'
#' \dontrun{
#'   library(ggplot2)
#'   library(ggimage)
#'   library(magrittr)
#'   library(stringr)
#'   library(tidyr)
#' }
#'
#' # Defining the Model -----
#'
#' \dontrun{
#'   model_path <- # This model is included with NetLogo installations.
#'     find_netlogo_home() |>
#'     file.path(
#'       "models",
#'       "Sample Models",
#'       "Biology",
#'       "Wolf Sheep Predation.nlogox"
#'     )
#' }
#'
#' # Creating an Experiment -----
#'
#' \dontrun{
#'   setup_file <- create_experiment(
#'     name = "Agent Attributes Extraction",
#'     repetitions = 1,
#'     sequential_run_order = TRUE,
#'     run_metrics_every_step = TRUE,
#'     time_limit = 1,
#'     metrics = c(
#'       '[who] of sheep',
#'       '[xcor] of sheep',
#'       '[ycor] of sheep',
#'       '[shape] of sheep',
#'       '[color] of sheep',
#'       '[who] of wolves',
#'       '[xcor] of wolves',
#'       '[ycor] of wolves',
#'       '[shape] of wolves',
#'       '[color] of wolves',
#'       '[pxcor] of patches',
#'       '[pycor] of patches',
#'       '[pcolor] of patches'
#'     ),
#'     constants = list(
#'       "model-version" = "sheep-wolves-grass"
#'     )
#'   )
#' }
#'
#' # Running the Experiment -----
#'
#' \dontrun{
#'   results <-
#'     model_path |>
#'     run_experiment(
#'       setup_file = setup_file,
#'       outputs = c("table", "lists")
#'     )
#' }
#'
#' # Visualizing Patches -----
#'
#' \dontrun{
#'   plot <- results |> plot_patches()
#'
#'   print(plot)
#' }
#'
#' # Getting Agents Shapes -----
#'
#' \dontrun{
#'   turtle_shapes <-
#'     system.file("extdata", package = "logolink") |>
#'     list.files(full.names = TRUE)
#' }
#'
#' # Adding Agents to the Plot -----
#'
#' \dontrun{
#'   plot +
#'     geom_image(
#'       data = results |>
#'         extract2("lists") |>
#'         drop_na(xcor_of_sheep),
#'       mapping = aes(
#'         x = xcor_of_sheep,
#'         y = ycor_of_sheep,
#'         image = turtle_shapes |>
#'           str_subset("sheep") |>
#'           head(1)
#'       ),
#'       size = 0.035
#'     ) +
#'     geom_image(
#'       data = results |>
#'         extract2("lists") |>
#'         drop_na(xcor_of_wolves),
#'       mapping = aes(
#'         x = xcor_of_wolves,
#'         y = ycor_of_wolves,
#'         image = turtle_shapes |>
#'           str_subset("wolf") |>
#'           head(1)
#'       ),
#'       size = 0.04
#'     )
#' }
plot_patches <- function(
  results,
  run_number = 1,
  step = 0,
  na_value = parse_netlogo_color(7.5)
) {
  require_pkg("ggplot2")

  lists_cols <- c("run_number", "step")

  checkmate::assert_list(results, names = "named")
  checkmate::assert_subset(c("lists", "metadata"), names(results))
  checkmate::assert_tibble(results$lists)
  checkmate::assert_subset(lists_cols, names(results$lists))
  checkmate::assert_list(results$metadata)
  checkmate::assert_subset("world_dimensions", names(results$metadata))
  checkmate::assert_int(run_number, lower = 1)
  checkmate::assert_subset(run_number, unique(results$lists$run_number))
  checkmate::assert_int(step, lower = 0)
  checkmate::assert_subset(step, unique(results$lists$step))
  checkmate::assert_string(na_value, pattern = "^#[0-9a-fA-F]{6}$")

  data <-
    results |>
    magrittr::extract2("lists")

  if (!"index" %in% colnames(data)) {
    data <-
      data |>
      read_experiment_lists.tidy_output()
  }

  patches_metrics <- c(
    '[pxcor] of patches' = "pxcor_of_patches",
    '[pycor] of patches' = "pycor_of_patches",
    '[pcolor] of patches' = "pcolor_of_patches"
  )

  if (!all(patches_metrics %in% colnames(data))) {
    cli::cli_abort(
      paste0(
        "The lists results do not contain all required patch metrics. ",
        "Add the following metrics to your results before using this ",
        "function: ",
        "{.strong {cli::col_red(names(patches_metrics))}}."
      )
    )
  }

  world_dimensions <-
    results |>
    magrittr::extract2("metadata") |>
    magrittr::extract2("world_dimensions")

  data <-
    data |>
    dplyr::filter(
      run_number == .env$run_number,
      step == .env$step
    ) |>
    dplyr::mutate(
      across(
        .cols = dplyr::matches("^pcolor_of_patches|^color_of_"),
        .fns = parse_netlogo_color
      )
    )

  data |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = pxcor_of_patches,
        y = pycor_of_patches,
        fill = pcolor_of_patches
      )
    ) +
    ggplot2::geom_raster() +
    ggplot2::coord_fixed() +
    ggplot2::scale_x_continuous(expand = c(0, 0)) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::scale_fill_identity(
      na.value = na_value
    ) +
    ggplot2::theme_void() +
    ggplot2::theme(
      legend.position = "none"
    )
}
