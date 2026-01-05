# Run a NetLogo BehaviorSpace experiment

`run_experiment()` runs a NetLogo
[BehaviorSpace](https://docs.netlogo.org/behaviorspace.html) experiment
in headless mode and returns a
[`list`](https://rdrr.io/r/base/list.html) with results as [tidy data
frames](https://r4ds.hadley.nz/data-tidy.html). It can be used with
[`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)
to create the experiment [XML](https://en.wikipedia.org/wiki/XML) file
on the fly, or with an existing experiment stored in the NetLogo model
file.

To avoid issues with list parsing, `run_experiment()` includes support
for the special
[lists](https://docs.netlogo.org/behaviorspace.html#lists-output) output
format. If your experiment includes metrics that return NetLogo lists,
include `"lists"` in the `output` argument to capture this output.
Columns containing NetLogo lists are returned as
[`character`](https://rdrr.io/r/base/character.html) vectors.

The function tries to locate the NetLogo installation automatically.
This is usually successful, but if it fails, you will need to set it
manually. See the *Details* section for more information.

For complete guidance on setting up and running experiments in NetLogo,
please refer to the [BehaviorSpace
Guide](https://docs.netlogo.org/behaviorspace.html).

## Usage

``` r
run_experiment(
  model_path,
  setup_file = NULL,
  experiment = NULL,
  output = "table",
  other_arguments = NULL,
  timeout = Inf,
  tidy_output = TRUE
)
```

## Arguments

- model_path:

  A [`character`](https://rdrr.io/r/base/character.html) string
  specifying the path to the NetLogo model file (with extension
  `.nlogo`, `.nlogo3d`, `.nlogox`, or `.nlogox3d`).

- setup_file:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the path to an
  [XML](https://en.wikipedia.org/wiki/XML) file containing the
  experiment definition. This file can be created using
  [`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)
  or exported from the NetLogo BehaviorSpace interface (default:
  `NULL`).

- experiment:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the name of the experiment defined in the NetLogo
  model file (default: `NULL`).

- output:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector specifying which output types to generate from the experiment.
  Valid options are: `"table"`, `"spreadsheet"`, `"lists"`, and
  `"statistics"`. At least one of `"table"` or `"spreadsheet"` must be
  included. See the BehaviorSpace documentation on
  [formats](https://docs.netlogo.org/behaviorspace.html#run-options-formats)
  for details about each output type (default: `c("table", "lists")`).

- other_arguments:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector specifying any additional command-line arguments to pass to the
  NetLogo executable. For example, you can use `c("--threads 4")` to
  specify the number of threads. See the *Details* section for more
  information (default: `NULL`).

- timeout:

  (optional) A [`numeric`](https://rdrr.io/r/base/numeric.html) value
  specifying the maximum time (in seconds) to wait for the NetLogo
  process to complete. If the process exceeds this time limit, it will
  be terminated, and the function will return the available output up to
  that point. Use `Inf` for no time limit (default: `Inf`).

- tidy_output:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to tidy the output data frames. If `TRUE`, output
  data frames are arranged according to [tidy data
  principles](https://r4ds.hadley.nz/data-tidy.html). If `FALSE`, only
  the default transformations from
  [`read_delim()`](https://readr.tidyverse.org/reference/read_delim.html)
  and
  [`clean_names()`](https://sfirke.github.io/janitor/reference/clean_names.html)
  are applied to the output data (default: `TRUE`).

## Value

A [`list`](https://rdrr.io/r/base/list.html) containing the experiment
results. The list includes the following elements, depending on the
specified `output`:

- `metadata`: A [`list`](https://rdrr.io/r/base/list.html) with metadata
  about the experiment run.

- `table`: A
  [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
  the results of the
  [`table`](https://docs.netlogo.org/behaviorspace.html#table-output)
  output (if requested).

- `spreadsheet`: A
  [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
  the results of the
  [`spreadsheet`](https://docs.netlogo.org/behaviorspace.html#spreadsheet-output)
  output (if requested).

- `lists`: A
  [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
  the results of the
  [`lists`](https://docs.netlogo.org/behaviorspace.html#lists-output)
  output (if requested).

- `statistics`: A
  [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
  the results of the
  [`statistics`](https://docs.netlogo.org/behaviorspace.html#statistics-output)
  output (if requested). See the [BehaviorSpace
  Guide](https://docs.netlogo.org/behaviorspace.html) for details about
  each output type.

## Details

### Setting the NetLogo Installation Path

If `run_experiment()` cannot find the NetLogo installation, you will
need to set the path manually using the `NETLOGO_HOME` environment
variable. On Windows, a typical path is something like
`C:\Program Files\NetLogo 7.0.3`. You can set this variable temporarily
in your R session with:

    Sys.setenv(NETLOGO_HOME = "PATH/TO/NETLOGO/INSTALLATION")

or permanently by adding it to your
[`.Renviron`](https://rstats.wtf/r-startup.html#renviron) file.

If even after setting the `NETLOGO_HOME` variable you still encounter
issues, try setting a `NETLOGO_CONSOLE` environment variable with the
path to the NetLogo executable or binary. On Windows, a typical path is
something like `C:\Program Files\NetLogo 7.0.3\NetLogo.exe`.

### Handling NetLogo Lists

NetLogo uses a specific syntax for lists (e.g., `"[1 2 3]"`) that is
incompatible with standard
[CSV](https://en.wikipedia.org/wiki/Comma-separated_values) formats. To
address this, NetLogo provides a special output format called
[lists](https://docs.netlogo.org/behaviorspace.html#lists-output) that
exports list metrics in a tabular structure. If your experiment includes
metrics that return NetLogo lists, include `"lists"` in the `output`
argument to capture this output. Columns containing NetLogo lists are
returned as [`character`](https://rdrr.io/r/base/character.html)
vectors.

The
[`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md)
function is available for parsing list values embedded in other outputs.
However, we recommend using it only when necessary, as it can be
computationally intensive for large datasets and may not handle all edge
cases.

### Additional Command-Line Arguments

You can pass additional command-line arguments to the NetLogo executable
using the `other_arguments` parameter. This can be useful for specifying
options such as the number of threads to use or other NetLogo-specific
flags.

For example, to specify the number of threads, you can use:

    run_experiment(
      model_path = "path/to/model.nlogox",
      setup_file = "path/to/experiment.xml",
      other_arguments = c("--threads 4")
    )

There are a variety of command-line options available, but some are
reserved for internal use by `run_experiment()` and cannot be modified.
These are:

- `--headless`: Ensures NetLogo runs in headless mode.

- `--3D`: Specifies if the model is a 3D model (automatically set based
  on the model file extension).

- `--model`: Specifies the path to the NetLogo model file.

- `--setup-file`: Specifies the path to the experiment XML file.

- `--experiment`: Specifies the name of the experiment defined in the
  model.

- `--table`: Specifies the output file for the results table.

- `--spreadsheet`: Specifies the output file for the spreadsheet
  results.

- `--lists`: Specifies the output file for the lists results.

- `--stats`: Specifies the output file for the statistics results.

For a complete list of available options, please refer to the
[BehaviorSpace
Guide](https://docs.netlogo.org/behaviorspace.html#running-from-the-command-line).

### NetLogo 3D

The function automatically detects whether the provided model is a 3D
model (based on the file extension) and adjusts the command-line
arguments accordingly. You do not need to set the `--3D` flag manually.

### Non-Tabular Output

If the experiment generates any non-tabular output (e.g., prints, error
messages, warnings), it will be captured and displayed as an
informational message after the results data frame is returned. This
allows you to see any important messages generated during the experiment
run. Keep in mind that excessive non-tabular output may clutter your R
console.

## See also

Other NetLogo functions:
[`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)

## Examples

``` r
# Defining the Model -----

# \dontrun{
  model_path <- # This model is included with NetLogo installations.
    find_netlogo_home() |>
    file.path(
      "models",
      "IABM Textbook",
      "chapter 4",
      "Wolf Sheep Simple 5.nlogox"
    )
# }

# Creating an Experiment -----

# \dontrun{
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
# }

# Running the Experiment -----

# \dontrun{
  model_path |>
    run_experiment(
      setup_file = setup_file
    )
#> ℹ Running model
#> ✔ Running model [21s]
#> 
#> ℹ Gathering metadata
#> ✔ Gathering metadata [10ms]
#> 
#> ℹ Processing table output
#> ✔ Processing table output [14ms]
#> 
#> ℹ The experiment run produced the following messages:
#> 
#> Jan 05, 2026 4:59:43 PM java.util.prefs.FileSystemPreferences$1 run
#> INFO: Created user preferences directory.
#> $metadata
#> $metadata$timestamp
#> [1] "2026-01-05 16:59:44 GMT"
#> 
#> $metadata$netlogo_version
#> [1] "7.0.3"
#> 
#> $metadata$model_file
#> [1] "Wolf Sheep Simple 5.nlogox"
#> 
#> $metadata$experiment_name
#> [1] "Wolf Sheep Simple Model Analysis"
#> 
#> $metadata$world_dimensions
#> min-pxcor max-pxcor min-pycor max-pycor 
#>       -17        17       -17        17 
#> 
#> 
#> $table
#> # A tibble: 110,110 × 10
#>    run_number number_of_sheep number_of_wolves movement_cost grass_regrowth_rate
#>         <dbl>           <dbl>            <dbl>         <dbl>               <dbl>
#>  1          1             500                5           0.5                 0.3
#>  2          1             500                5           0.5                 0.3
#>  3          1             500                5           0.5                 0.3
#>  4          1             500                5           0.5                 0.3
#>  5          1             500                5           0.5                 0.3
#>  6          1             500                5           0.5                 0.3
#>  7          1             500                5           0.5                 0.3
#>  8          1             500                5           0.5                 0.3
#>  9          1             500                5           0.5                 0.3
#> 10          1             500                5           0.5                 0.3
#> # ℹ 110,100 more rows
#> # ℹ 5 more variables: energy_gain_from_grass <dbl>,
#> #   energy_gain_from_sheep <dbl>, step <dbl>, count_wolves <dbl>,
#> #   count_sheep <dbl>
#> 
# }

# Running an Experiment Defined in the NetLogo Model File -----

# \dontrun{
  model_path |>
    run_experiment(
      experiment = "Wolf Sheep Simple model analysis"
    )
#> ℹ Running model
#> ✔ Running model [18s]
#> 
#> ℹ Gathering metadata
#> ✔ Gathering metadata [9ms]
#> 
#> ℹ Processing table output
#> ✔ Processing table output [8ms]
#> 
#> $metadata
#> $metadata$timestamp
#> [1] "2026-01-05 17:00:06 GMT"
#> 
#> $metadata$netlogo_version
#> [1] "7.0.3"
#> 
#> $metadata$model_file
#> [1] "Wolf Sheep Simple 5.nlogox"
#> 
#> $metadata$experiment_name
#> [1] "Wolf Sheep Simple model analysis"
#> 
#> $metadata$world_dimensions
#> min-pxcor max-pxcor min-pycor max-pycor 
#>       -17        17       -17        17 
#> 
#> 
#> $table
#> # A tibble: 110 × 11
#>    run_number energy_gain_from_grass number_of_wolves movement_cost
#>         <dbl>                  <dbl>            <dbl>         <dbl>
#>  1          1                      2                5           0.5
#>  2          2                      2                5           0.5
#>  3          3                      2                5           0.5
#>  4          4                      2                5           0.5
#>  5          5                      2                5           0.5
#>  6          6                      2                5           0.5
#>  7          7                      2                5           0.5
#>  8          8                      2                5           0.5
#>  9          9                      2                5           0.5
#> 10         10                      2                5           0.5
#> # ℹ 100 more rows
#> # ℹ 7 more variables: energy_gain_from_sheep <dbl>, number_of_sheep <dbl>,
#> #   grass_regrowth_rate <dbl>, step <dbl>, count_wolves <dbl>,
#> #   count_sheep <dbl>, sum_grass_amount_of_patches <dbl>
#> 
# }
```
