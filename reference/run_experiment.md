# Run a NetLogo BehaviorSpace experiment

`run_experiment()` runs a NetLogo BehaviorSpace experiment in headless
mode and returns the results as a tidy data frame. It can be used with
[`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)
to create the experiment XML file on the fly, or with an existing
experiment stored in the NetLogo model file.

The function tries to locate the NetLogo installation automatically.
This is usually successful, but **if it fails**, you will need to set it
manually. In the latter case, see *Details* section for more
information.

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
  netlogo_3d = FALSE,
  parse = TRUE,
  timeout = Inf,
  netlogo_home = find_netlogo_home(),
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

- netlogo_3d:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether the model is a 3D model. This is necessary for
  models with extensions `.nlogo3d` or `.nlogox3d` (default: `FALSE`).

- parse:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to parse NetLogo lists in the output data frame. If
  `TRUE`, columns containing NetLogo lists (e.g., `[1 2 3]`) will be
  converted to R lists. If `FALSE`, the columns will remain as
  [`character`](https://rdrr.io/r/base/character.html) strings (default:
  `TRUE`).

- timeout:

  (optional) A [`numeric`](https://rdrr.io/r/base/numeric.html) value
  specifying the maximum time (in seconds) to wait for the NetLogo
  process to complete. If the process exceeds this time limit, it will
  be terminated, and the function will return the available output up to
  that point. Use `Inf` for no time limit (default: `Inf`).

- netlogo_home:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the path to the NetLogo installation directory. If
  not provided, the function will try to find it automatically using
  [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md).
  (default:
  [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md)).

- netlogo_path:

  **\[deprecated\]** This argument is no longer supported. See the
  *Details* section for more information.

## Value

A [`tibble`](https://dplyr.tidyverse.org/reference/reexports.html)
containing the results of the experiment.

## Details

### Setting the NetLogo Installation Path

If `run_experiment()` cannot find the NetLogo installation, you will
need to set the path manually using the `NETLOGO_HOME` environment
variable. On Windows, a typical path is something like
`C:\Program Files\NetLogo 7.0.2`. You can set this variable temporarily
in your R session with:

    Sys.setenv("NETLOGO_HOME" = "PATH/TO/NETLOGO/INSTALLATION")

or permanently by adding it to your
[`.Renviron`](https://rstats.wtf/r-startup.html#renviron) file.

If even after setting the `NETLOGO_HOME` variable you still encounter
issues, please try to set a `NETLOGO_CONSOLE` environment variable with
the path of the NetLogo executable or binary. On Windows, a typical path
is something like `C:\Program Files\NetLogo 7.0.2\NetLogo.exe`.

### Non-Tabular Output

If the experiment generates any non-tabular output (e.g., prints, error
messages, warnings), this output will be captured and displayed as an
informational message after the results data frame is returned. This
allows you to see any important messages generated during the experiment
run. Keep in mind that excessive non-tabular output may clutter your R
console.

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
