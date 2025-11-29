# Run a NetLogo BehaviorSpace experiment

**Note**: The procedure for setting the NetLogo path has changed. For
users of the CRAN release of `logolink` (version 0.1.0), see the
previous instructions
[here](https://github.com/danielvartan/logolink/tree/v0.1.0?tab=readme-ov-file#setting-the-netlogo-path).
To access the latest features and improvements, install the development
version of `logolink` from GitHub using:
`remotes::install_github("danielvartan/logolink")`.

`run_experiment()` runs a NetLogo BehaviorSpace experiment in headless
mode and returns the results as a tidy data frame. It can be used with
[`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)
to create the experiment XML file on the fly, or with an existing
experiment stored in the NetLogo model file.

Note that this function requires the path to the NetLogo installation to
be set as an environment variable named `NETLOGO_HOME`. See the
*Details* section for more information.

For complete guidance on setting up and running experiments in NetLogo,
please refer to the [BehaviorSpace
Guide](https://docs.netlogo.org/behaviorspace.html).

## Usage

``` r
run_experiment(
  model_path,
  experiment = NULL,
  setup_file = NULL,
  other_arguments = NULL,
  parse = TRUE,
  netlogo_home = Sys.getenv("NETLOGO_HOME"),
  netlogo_path = lifecycle::deprecated()
)
```

## Arguments

- model_path:

  A string specifying the path to the NetLogo model file (with extension
  `.nlogo`, `.nlogo3d`, `.nlogox`, or `.nlogox3d`).

- experiment:

  (optional) A string specifying the name of the experiment defined in
  the NetLogo model file (default: `NULL`).

- setup_file:

  (optional) A string specifying the path to an XML file containing the
  experiment definition. This file can be created using
  [`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)
  or exported from the NetLogo BehaviorSpace interface (default:
  `NULL`).

- other_arguments:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector specifying any additional command-line arguments to pass to the
  NetLogo executable. For example, you can use `c("--threads 4")` to
  specify the number of threads to use (default: `NULL`).

- parse:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to parse NetLogo lists in the output data frame. If
  `TRUE`, columns containing NetLogo lists (e.g., `[1 2 3]`) will be
  converted to R lists. If `FALSE`, the columns will remain as
  [`character`](https://rdrr.io/r/base/character.html) strings (default:
  `TRUE`).

- netlogo_home:

  (optional) A string specifying the path to the NetLogo installation
  directory. If not provided, the function will use the value of the
  `NETLOGO_HOME` environment variable. This argument is useful if you
  want to override the environment variable for a specific function call
  (default: `Sys.getenv("NETLOGO_HOME")`).

- netlogo_path:

  **\[deprecated\]** This argument is no longer supported. See the
  *Details* section for more information.

## Value

A [`tibble`](https://dplyr.tidyverse.org/reference/reexports.html)
containing the results of the experiment.

## Details

`run_experiment()` requires the path to the NetLogo installation to be
set as an environment variable named `NETLOGO_HOME`. On Windows, the
path typically looks like `C:\Program Files\NetLogo 7.0.2`. You can set
this environment variable temporarily in your R session using
`Sys.setenv("NETLOGO_HOME" = "[PATH]")`, or permanently by adding it to
your [`.Renviron`](https://rstats.wtf/r-startup.html#renviron) file.

## See also

Other NetLogo functions:
[`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)

## Examples

``` r
# Set the Environment -----

if (FALSE) { # \dontrun{
  ## Change the path below to point to your NetLogo installation folder.
  Sys.setenv(
    "NETLOGO_HOME" = file.path("C:", "Program Files", "NetLogo 7.0.2")
  )

  model_path <-
    Sys.getenv("NETLOGO_HOME") |>
    file.path(
      "models", "IABM Textbook", "chapter 4", "Wolf Sheep Simple 5.nlogox"
    )
} # }

# Using `create_experiment()` to Create the Experiment XML File -----

if (FALSE) { # \dontrun{
  setup_file <- create_experiment(
    name = "Wolf Sheep Simple Model Analysis",
    repetitions = 10,
    sequential_run_order = TRUE,
    run_metrics_every_step = TRUE,
    setup = "setup",
    go = "go",
    time_limit = 1000,
    metrics = c(
      'count wolves',
      'count sheep'
    ),
    run_metrics_condition = NULL,
    constants = list(
      "number-of-sheep" = 500,
      "number-of-wolves" = list(
        first = 5,
        step = 1,
        last = 15
      ),
      "movement-cost" = 0.5,
      "grass-regrowth-rate" = 0.3,
      "energy-gain-from-grass" = 2,
      "energy-gain-from-sheep" = 5
    )
  )

  run_experiment(
    model_path = model_path,
    setup_file = setup_file
  )
  ## Expected output:
  #> # A tibble: 110,110 × 10
  #>   run_number number_of_sheep number_of_wolves movement_cost
  #>         <dbl>           <dbl>            <dbl>         <dbl>
  #>  1          3             500                5           0.5
  #>  2          9             500                5           0.5
  #>  3          4             500                5           0.5
  #>  4          1             500                5           0.5
  #>  5          6             500                5           0.5
  #>  6          8             500                5           0.5
  #>  7          7             500                5           0.5
  #>  8          2             500                5           0.5
  #>  9          5             500                5           0.5
  #> 10          2             500                5           0.5
  #>  # 110,100 more rows
  #>  # 6 more variables: grass_regrowth_rate <dbl>,
  #>  # energy_gain_from_grass <dbl>, energy_gain_from_sheep <dbl>,
  #>  # step <dbl>, count_wolves <dbl>, count_sheep <dbl>
  #>  # Use `print(n = ...)` to see more rows
} # }

# Using an Experiment Defined in the NetLogo Model File -----

if (FALSE) { # \dontrun{
  run_experiment(
    model_path = model_path,
    experiment = "Wolf Sheep Simple model analysis"
  )
  ## Expected output:
  #> # A tibble: 110 × 11
  #>    run_number energy_gain_from_grass number_of_wolves movement_cost
  #>         <dbl>                  <dbl>            <dbl>         <dbl>
  #>  1          4                      2                5           0.5
  #>  2          8                      2                5           0.5
  #>  3          2                      2                5           0.5
  #>  4          9                      2                5           0.5
  #>  5          1                      2                5           0.5
  #>  6          5                      2                5           0.5
  #>  7          7                      2                5           0.5
  #>  8          3                      2                5           0.5
  #>  9          6                      2                5           0.5
  #> 10         12                      2                6           0.5
  #> # 100 more rows
  #> # 7 more variables: energy_gain_from_sheep <dbl>,
  #> # number_of_sheep <dbl>, grass_regrowth_rate <dbl>, step <dbl>,
  #> # count_wolves <dbl>, count_sheep <dbl>,
  #> # sum_grass_amount_of_patches <dbl>
  #> # Use `print(n = ...)` to see more rows
} # }
```
