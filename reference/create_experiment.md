# Create a NetLogo BehaviorSpace experiment

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
  constants = NULL,
  file = tempfile(pattern = "experiment-", fileext = ".xml")
)
```

## Arguments

- name:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the name of the experiment (default: `""`).

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

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the NetLogo command to run before the experiment
  starts (default: `NULL`).

- setup:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the NetLogo command to set up the model (default:
  `"setup"`).

- go:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the NetLogo command to run the model (default:
  `"go"`).

- post_run:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the NetLogo command to run after each run (default:
  `NULL`).

- post_experiment:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the NetLogo command to run after the experiment ends
  (default: `NULL`).

- time_limit:

  (optional) An integer number specifying the maximum number of steps to
  run for each repetition (default: `1`).

- exit_condition:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the NetLogo command that defines the exit condition
  for the experiment (default: `NULL`).

- metrics:

  A [`character`](https://rdrr.io/r/base/character.html) vector
  specifying the NetLogo commands to record as metrics (default:
  `c('count turtles', 'count patches')`).

- run_metrics_condition:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the NetLogo command that defines the condition to
  record metrics (default: `NULL`).

- constants:

  (optional) A named [`list`](https://rdrr.io/r/base/list.html)
  specifying the parameters for the experiment. Each element can be
  either a single value (for fixed/enumerated values) or a
  [`list`](https://rdrr.io/r/base/list.html) with `first`, `step`, and
  `last` elements (for stepped/varying values). See the *Details* and
  *Examples* sections to learn more (default: `NULL`).

- file:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the path to save the created XML file (default:
  `tempfile(pattern = "experiment-", fileext = ".xml")`).

## Value

A [`character`](https://rdrr.io/r/base/character.html) string with the
path to the created XML file.

## Details

### `constants` Argument

The `constants` argument allows you to specify the parameters to vary in
the experiment. It should be a named
[`list`](https://rdrr.io/r/base/list.html) where each name corresponds
to a NetLogo global variable. The value for each name can be either:

- A single value (for enumerated values). For example, to set the
  variable `initial-number-of-turtles` to `10`, you would use
  `list("initial-number-of-turtles" = 10)`.

- A [`list`](https://rdrr.io/r/base/list.html) with `first`, `step`, and
  `last` elements (for stepped values). For example, to vary the
  variable `initial-number-of-turtles` from `10` to `50` in steps of
  `10`, you would use
  `list("initial-number-of-turtles" = list(first = 10, step = 10, last = 50))`.

Note that [`character`](https://rdrr.io/r/base/character.html) strings
should be passed as is, without adding quotes to them. For example, to
set the variable `scenario` to `"SSP-585"`, you should use
`list("scenario" = "SSP-585")`, not `list("scenario" = '"SSP-585"')`.

Insert quotes only if the command requires them. For example:
`'n-values 10 ["N/A"]'`. Since NetLogo only accepts double quotes for
strings inside commands, single quotes are used here to define the R
string.

## See also

Other NetLogo functions:
[`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)

## Examples

``` r
## Example for the *Wolf Sheep Predation* Model ----

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
#> [1] "/tmp/RtmpYOmpZn/experiment-19562a45c453.xml"

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

## Example for the *Spread of Disease* Model ----

setup_file <- create_experiment(
  name = "Population Density",
  repetitions = 1,
  sequential_run_order = TRUE,
  run_metrics_every_step = TRUE,
  setup = "setup",
  go = "go",
  post_run = NULL,
  post_experiment = NULL,
  time_limit = 1000,
  exit_condition = NULL,
  metrics = c(
    'count turtles with [infected?]'
  ),
  run_metrics_condition = NULL,
  constants = list(
    "variant" = "mobile",
    "num-people" = list(
      first = 50,
      step = 50,
      last = 200
    ),
    "connections-per-node" = 4.1,
    "num-infected" = 1,
    "disease-decay" = 0
  )
)

setup_file
#> [1] "/tmp/RtmpYOmpZn/experiment-195654178861.xml"

setup_file |> inspect_experiment_file()
#> <experiments>
#>   <experiment name="Population Density" repetitions="1" sequentialRunOrder="true" runMetricsEveryStep="true" timeLimit="1000">
#>     <setup>setup</setup>
#>     <go>go</go>
#>     <metrics>
#>       <metric>count turtles with [infected?]</metric>
#>     </metrics>
#>     <constants>
#>       <enumeratedValueSet variable="variant">
#>         <value value="&quot;mobile&quot;"></value>
#>       </enumeratedValueSet>
#>       <steppedValueSet variable="num-people" first="50" step="50" last="200"></steppedValueSet>
#>       <enumeratedValueSet variable="connections-per-node">
#>         <value value="4.1"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="num-infected">
#>         <value value="1"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="disease-decay">
#>         <value value="0"></value>
#>       </enumeratedValueSet>
#>     </constants>
#>   </experiment>
#> </experiments>
```
