# Create a NetLogo BehaviorSpace experiment XML file

`create_experiment()` creates a NetLogo BehaviorSpace experiment XML in
a temporary file that can be used to run headless experiments with the
[`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)
function.

Please refer to the [BehaviorSpace
Guide](https://docs.netlogo.org/behaviorspace.html) for complete
guidance on how to set and run experiments in NetLogo.

## Usage

``` r
create_experiment(
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
  metrics = c("count turtles", "count patches"),
  run_metrics_condition = NULL,
  constants = NULL
)
```

## Arguments

- name:

  (optional) A string specifying the name of the experiment (default:
  `""`).

- repetitions:

  (optional) An integer number specifying the number of times to repeat
  the experiment (default: `1`).

- sequential_run_order:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to run the experiments in sequential order
  (default: `TRUE`).

- run_metrics_every_step:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to record metrics at every step (default: `FALSE`).

- pre_experiment:

  (optional) A string specifying the NetLogo command to run before the
  experiment starts (default: `NULL`).

- setup:

  A string specifying the NetLogo command to set up the model (default:
  `"setup"`).

- go:

  A string specifying the NetLogo command to run the model (default:
  `"go"`).

- post_run:

  (optional) A string specifying the NetLogo command to run after each
  run (default: `NULL`).

- post_experiment:

  (optional) A string specifying the NetLogo command to run after the
  experiment ends (default: `NULL`).

- time_limit:

  (optional) An integer number specifying the maximum number of steps to
  run for each repetition (default: `1`).

- exit_condition:

  (optional) A string specifying the NetLogo command that defines the
  exit condition for the experiment (default: `NULL`).

- metrics:

  A [`character`](https://rdrr.io/r/base/character.html) vector
  specifying the NetLogo commands to record as metrics (default:
  `c('count turtles', 'count patches')`).

- run_metrics_condition:

  (optional) A string specifying the NetLogo command that defines the
  condition to record metrics (default: `NULL`).

- constants:

  (optional) A named [`list`](https://rdrr.io/r/base/list.html)
  specifying the constants to vary in the experiment. Each element can
  be either a single value (for enumerated values) or a
  [`list`](https://rdrr.io/r/base/list.html) with `first`, `step`, and
  `last` elements (for stepped values). See the *Details* and *Examples*
  sections to learn more (default: `NULL`).

## Value

A string with the path to the created XML file.

## Details

### Constants

The `constants` argument allows you to specify the parameters to vary in
the experiment. It should be a named
[`list`](https://rdrr.io/r/base/list.html) where each name corresponds
to a NetLogo variable. The value for each name can be either:

- A single value (for enumerated values). For example, to set the
  variable `initial-number-of-turtles` to `10`, you would use
  `list("initial-number-of-turtles" = 10)`.

- A [`list`](https://rdrr.io/r/base/list.html) with `first`, `step`, and
  `last` elements (for stepped values). For example, to vary the
  variable `initial-number-of-turtles` from `10` to `50` in steps of
  `10`, you would use
  `list("initial-number-of-turtles" = list(first = 10, step = 10, last = 50))`.

Please note that any mistake in the constants names will cause the
experiment to return an empty result set. Be careful when changing them.

Also, enclose commands with single quotes (e.g.,
`'n-values 10 ["N/A"]'`), since NetLogo only accepts double quotes for
strings.

## See also

Other NetLogo functions:
[`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)

## Examples

``` r
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

setup_file
#> [1] "/tmp/RtmpeEWO0y/experiment-19214a9dca6a.xml"

setup_file |> inspect_experiment_file()
#> <experiments>
#>   <experiment name="Wolf Sheep Simple Model Analysis" repetitions="10" sequentialRunOrder="true" runMetricsEveryStep="true" timeLimit="1000">
#>     <setup>setup</setup>
#>     <go>go</go>
#>     <metrics>
#>       <metric>count wolves</metric>
#>       <metric>count sheep</metric>
#>     </metrics>
#>     <constants>
#>       <enumeratedValueSet variable="number-of-sheep">
#>         <value value="500"></value>
#>       </enumeratedValueSet>
#>       <steppedValueSet variable="number-of-wolves" first="5" step="1" last="15"></steppedValueSet>
#>       <enumeratedValueSet variable="movement-cost">
#>         <value value="0.5"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="grass-regrowth-rate">
#>         <value value="0.3"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="energy-gain-from-grass">
#>         <value value="2"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="energy-gain-from-sheep">
#>         <value value="5"></value>
#>       </enumeratedValueSet>
#>     </constants>
#>   </experiment>
#> </experiments>
```
