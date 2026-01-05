# Create a NetLogo BehaviorSpace experiment

`create_experiment()` creates a NetLogo
[BehaviorSpace](https://docs.netlogo.org/behaviorspace.html) experiment
XML in a temporary file that can be used to run headless experiments
with the
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
  time_limit = 1,
  pre_experiment = NULL,
  setup = "setup",
  go = "go",
  post_run = NULL,
  post_experiment = NULL,
  exit_condition = NULL,
  run_metrics_condition = NULL,
  metrics = c("count turtles", "count patches"),
  constants = NULL,
  sub_experiments = NULL,
  file = tempfile(pattern = "experiment-", fileext = ".xml")
)
```

## Arguments

- name:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the name of the experiment (default: `""`).

- repetitions:

  (optional) An integer number specifying the number of times to run the
  experiment (default: `1`).

- sequential_run_order:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to run the experiments in sequential order
  (default: `TRUE`).

- run_metrics_every_step:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to record metrics at every step (default: `FALSE`).

- time_limit:

  (optional) An integer number specifying the maximum number of steps to
  run for each repetition. Set to `0` or `NULL` to have no time limit
  (default: `1`).

- pre_experiment:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector specifying the NetLogo command(s) to run before the experiment
  starts. This can be a single command or multiple commands provided as
  a [`character`](https://rdrr.io/r/base/character.html) vector; see the
  *Details \> Multiple Commands* section for usage (default: `NULL`).

- setup:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector specifying the NetLogo command(s) to set up the model. This can
  be a single command or multiple commands provided as a
  [`character`](https://rdrr.io/r/base/character.html) vector (default:
  `'setup'`).

- go:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector specifying the NetLogo command(s) to run the model. This can be
  a single command or multiple commands provided as a
  [`character`](https://rdrr.io/r/base/character.html) vector (default:
  `'go'`).

- post_run:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector specifying the NetLogo command(s) to run after each run. This
  can be a single command or multiple commands provided as a
  [`character`](https://rdrr.io/r/base/character.html) vector (default:
  `NULL`).

- post_experiment:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector specifying the NetLogo command(s) to run after the experiment
  ends. This can be a single command or multiple commands provided as a
  [`character`](https://rdrr.io/r/base/character.html) vector (default:
  `NULL`).

- exit_condition:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector specifying the NetLogo command that defines the exit condition
  for the experiment (default: `NULL`).

- run_metrics_condition:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector specifying the NetLogo command that defines the condition to
  record metrics (default: `NULL`).

- metrics:

  A [`character`](https://rdrr.io/r/base/character.html) vector
  specifying the NetLogo commands to record as metrics (default:
  `c('count turtles', 'count patches')`).

- constants:

  (optional) A named [`list`](https://rdrr.io/r/base/list.html)
  specifying the parameters for the experiment. Each element can be
  either a scalar, vector (for fixed/enumerated values), or a
  [`list`](https://rdrr.io/r/base/list.html) with `first`, `step`, and
  `last` elements (for stepped/varying values). See the *Details* and
  *Examples* sections to learn more (default: `NULL`).

- sub_experiments:

  (optional) A [`list`](https://rdrr.io/r/base/list.html) where each
  element is a [`list`](https://rdrr.io/r/base/list.html) specifying the
  constants for a sub-experiment. Each sub-experiment uses the same
  structure as the `constants` argument. See the `constants` argument
  documentation for details on how to specify parameter values (default:
  `NULL`).

- file:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the path to save the created XML file (default:
  `tempfile(pattern = "experiment-", fileext = ".xml")`).

## Value

A [`character`](https://rdrr.io/r/base/character.html) string with the
path to the created XML file.

## Details

### Enclosing

Since NetLogo only accepts double quotes for strings inside commands, we
recommend always using single quotes when writing NetLogo commands in R
to avoid mistakes. For example, to run the `[1 "a" true]` command, use
`'[1 "a" true]'`, not `"[1 \"a\" true]"`.

### Constants and `character` strings

When passing single values to constants,
[`character`](https://rdrr.io/r/base/character.html) strings should be
passed as is, without adding quotes to them. For example, to set the
variable `scenario` to `"SSP-585"`, you should use
`list("scenario" = "SSP-585")`, not `list("scenario" = '"SSP-585"')`.

Insert quotes only if the command requires them. For example:
`'n-values 10 ["N/A"]'`.

### Multiple Commands

Some arguments accept multiple NetLogo commands to be run in sequence.
In such cases, you can provide a
[`character`](https://rdrr.io/r/base/character.html) vector with each
command as a separate element.

For example, to run two commands in sequence for the `go` argument, you
can provide:

    go = c("command-1", "command-2")

### `constants` Argument

The `constants` argument allows you to specify the parameters to vary in
the experiment. It should be a named
[`list`](https://rdrr.io/r/base/list.html) where each name corresponds
to a NetLogo global variable. The value for each name can be either:

- A scalar or vector (for enumerated values). For example, to set the
  variable `initial-number-of-turtles` to `10`, you would use
  `list("initial-number-of-turtles" = 10)`.

- A [`list`](https://rdrr.io/r/base/list.html) with `first`, `step`, and
  `last` elements (for stepped values). For example, to vary the
  variable `initial-number-of-turtles` from `10` to `50` in steps of
  `10`, you would use
  `list("initial-number-of-turtles" = list(first = 10, step = 10, last = 50))`.

## See also

Other NetLogo functions:
[`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)

## Examples

``` r
# The examples below reproduce experiments from the NetLogo Models Library.
# Try exporting these experiments from NetLogo and compare the XML files.

## Examples from the *Wolf Sheep Predation* Model (Sample Models) ----

### BehaviorSpace Combinatorial

setup_file <- create_experiment(
  name = "BehaviorSpace Combinatorial",
  repetitions = 1,
  sequential_run_order = TRUE,
  run_metrics_every_step = FALSE,
  time_limit = 1500,
  setup = 'setup',
  go = 'go',
  post_run = 'wait .5',
  run_metrics_condition = 'ticks mod 10 = 0',
  metrics = c(
    'count sheep',
    'count wolves',
    'count grass'
  ),
  constants = list(
    "model-version" = "sheep-wolves-grass",
    "wolf-reproduce" = c(3, 5, 10, 15),
    "wolf-gain-from-food" = c(10, 15, 30, 40)
  )
)

setup_file
#> [1] "/tmp/Rtmp47kcfm/experiment-1e6afc636e1.xml"

setup_file |> inspect_experiment_file()
#> <experiments>
#>   <experiment name="BehaviorSpace Combinatorial" repetitions="1" sequentialRunOrder="true" runMetricsEveryStep="false" timeLimit="1500">
#>     <setup>setup</setup>
#>     <go>go</go>
#>     <postRun>wait .5</postRun>
#>     <runMetricsCondition>ticks mod 10 = 0</runMetricsCondition>
#>     <metrics>
#>       <metric>count sheep</metric>
#>       <metric>count wolves</metric>
#>       <metric>count grass</metric>
#>     </metrics>
#>     <constants>
#>       <enumeratedValueSet variable="model-version">
#>         <value value="&quot;sheep-wolves-grass&quot;"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="wolf-reproduce">
#>         <value value="3"></value>
#>         <value value="5"></value>
#>         <value value="10"></value>
#>         <value value="15"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="wolf-gain-from-food">
#>         <value value="10"></value>
#>         <value value="15"></value>
#>         <value value="30"></value>
#>         <value value="40"></value>
#>       </enumeratedValueSet>
#>     </constants>
#>   </experiment>
#> </experiments>

### Behaviorspace Run 3 Experiments

setup_file <- create_experiment(
  name = "Behaviorspace Run 3 Experiments",
  repetitions = 1,
  sequential_run_order = TRUE,
  run_metrics_every_step = FALSE,
  time_limit = 1500,
  setup = c(
    'setup',
    paste0(
      'print (word "sheep-reproduce: " sheep-reproduce ", wolf-reproduce: ',
      '" wolf-reproduce)'
    ),
    paste0(
      'print (word "sheep-gain-from-food: " sheep-gain-from-food ", ',
      'wolf-gain-from-food: " wolf-gain-from-food)'
    )
  ),
  go = 'go',
  post_run = c(
    'print (word "sheep: " count sheep ", wolves: " count wolves)',
    'print ""',
    'wait 1'
  ),
  run_metrics_condition = 'ticks mod 10 = 0',
  metrics = c(
    'count sheep',
    'count wolves',
    'count grass'
  ),
  constants = list(
    "model-version" = "sheep-wolves-grass"
  ),
  sub_experiments = list(
    list(
      "sheep-reproduce" = 1,
      "sheep-gain-from-food" = 1,
      "wolf-reproduce" = 2,
      "wolf-gain-from-food" = 10
    ),
    list(
      "sheep-reproduce" = 6,
      "sheep-gain-from-food" = 8,
      "wolf-reproduce" = 5,
      "wolf-gain-from-food" = 20
    ),
    list(
      "sheep-reproduce" = 20,
      "sheep-gain-from-food" = 15,
      "wolf-reproduce" = 15,
      "wolf-gain-from-food" = 30
    )
  )
)

setup_file
#> [1] "/tmp/Rtmp47kcfm/experiment-1e6a215b8ff6.xml"

setup_file |> inspect_experiment_file()
#> <experiments>
#>   <experiment name="Behaviorspace Run 3 Experiments" repetitions="1" sequentialRunOrder="true" runMetricsEveryStep="false" timeLimit="1500">
#>     <setup>setup
#> print (word "sheep-reproduce: " sheep-reproduce ", wolf-reproduce: " wolf-reproduce)
#> print (word "sheep-gain-from-food: " sheep-gain-from-food ", wolf-gain-from-food: " wolf-gain-from-food)</setup>
#>     <go>go</go>
#>     <postRun>print (word "sheep: " count sheep ", wolves: " count wolves)
#> print ""
#> wait 1</postRun>
#>     <runMetricsCondition>ticks mod 10 = 0</runMetricsCondition>
#>     <metrics>
#>       <metric>count sheep</metric>
#>       <metric>count wolves</metric>
#>       <metric>count grass</metric>
#>     </metrics>
#>     <constants>
#>       <enumeratedValueSet variable="model-version">
#>         <value value="&quot;sheep-wolves-grass&quot;"></value>
#>       </enumeratedValueSet>
#>     </constants>
#>     <subExperiments>
#>       <subExperiment>
#>         <enumeratedValueSet variable="sheep-reproduce">
#>           <value value="1"></value>
#>         </enumeratedValueSet>
#>         <enumeratedValueSet variable="sheep-gain-from-food">
#>           <value value="1"></value>
#>         </enumeratedValueSet>
#>         <enumeratedValueSet variable="wolf-reproduce">
#>           <value value="2"></value>
#>         </enumeratedValueSet>
#>         <enumeratedValueSet variable="wolf-gain-from-food">
#>           <value value="10"></value>
#>         </enumeratedValueSet>
#>       </subExperiment>
#>       <subExperiment>
#>         <enumeratedValueSet variable="sheep-reproduce">
#>           <value value="6"></value>
#>         </enumeratedValueSet>
#>         <enumeratedValueSet variable="sheep-gain-from-food">
#>           <value value="8"></value>
#>         </enumeratedValueSet>
#>         <enumeratedValueSet variable="wolf-reproduce">
#>           <value value="5"></value>
#>         </enumeratedValueSet>
#>         <enumeratedValueSet variable="wolf-gain-from-food">
#>           <value value="20"></value>
#>         </enumeratedValueSet>
#>       </subExperiment>
#>       <subExperiment>
#>         <enumeratedValueSet variable="sheep-reproduce">
#>           <value value="20"></value>
#>         </enumeratedValueSet>
#>         <enumeratedValueSet variable="sheep-gain-from-food">
#>           <value value="15"></value>
#>         </enumeratedValueSet>
#>         <enumeratedValueSet variable="wolf-reproduce">
#>           <value value="15"></value>
#>         </enumeratedValueSet>
#>         <enumeratedValueSet variable="wolf-gain-from-food">
#>           <value value="30"></value>
#>         </enumeratedValueSet>
#>       </subExperiment>
#>     </subExperiments>
#>   </experiment>
#> </experiments>

### BehaviorSpace Run 3 Variable Values Per Experiments

setup_file <- create_experiment(
  name = "BehaviorSpace Run 3 Variable Values Per Experiments",
  repetitions = 1,
  sequential_run_order = TRUE,
  run_metrics_every_step = FALSE,
  time_limit = 1500,
  setup = c(
    'setup',
    paste0(
      'print (word "sheep-reproduce: " sheep-reproduce ", ',
      'wolf-reproduce: " wolf-reproduce)'
    ),
    paste0(
      'print (word "sheep-gain-from-food: " sheep-gain-from-food ", ',
      'wolf-gain-from-food: " wolf-gain-from-food)'
    )
  ),
  go = 'go',
  post_run = c(
    'print (word "sheep: " count sheep ", wolves: " count wolves)',
    'print ""',
    'wait 1'
  ),
  run_metrics_condition = 'ticks mod 10 = 0',
  metrics = c(
    'count sheep',
    'count wolves',
    'count grass'
  ),
  constants = list(
    "model-version" = "sheep-wolves-grass",
    "sheep-reproduce" = 4,
    "wolf-reproduce" = 2,
    "sheep-gain-from-food" = 4,
    "wolf-gain-from-food" = 20
  ),
  sub_experiments = list(
    list(
      "sheep-reproduce" = c(1, 6, 20)
    ),
    list(
      "wolf-reproduce" = c(2, 7, 15)
    ),
    list(
      "sheep-gain-from-food" = c(1, 8, 15)
    ),
    list(
      "wolf-gain-from-food" = c(10, 20, 30)
    )
  )
)

setup_file
#> [1] "/tmp/Rtmp47kcfm/experiment-1e6a3cc1e892.xml"

setup_file |> inspect_experiment_file()
#> <experiments>
#>   <experiment name="BehaviorSpace Run 3 Variable Values Per Experiments" repetitions="1" sequentialRunOrder="true" runMetricsEveryStep="false" timeLimit="1500">
#>     <setup>setup
#> print (word "sheep-reproduce: " sheep-reproduce ", wolf-reproduce: " wolf-reproduce)
#> print (word "sheep-gain-from-food: " sheep-gain-from-food ", wolf-gain-from-food: " wolf-gain-from-food)</setup>
#>     <go>go</go>
#>     <postRun>print (word "sheep: " count sheep ", wolves: " count wolves)
#> print ""
#> wait 1</postRun>
#>     <runMetricsCondition>ticks mod 10 = 0</runMetricsCondition>
#>     <metrics>
#>       <metric>count sheep</metric>
#>       <metric>count wolves</metric>
#>       <metric>count grass</metric>
#>     </metrics>
#>     <constants>
#>       <enumeratedValueSet variable="model-version">
#>         <value value="&quot;sheep-wolves-grass&quot;"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="sheep-reproduce">
#>         <value value="4"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="wolf-reproduce">
#>         <value value="2"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="sheep-gain-from-food">
#>         <value value="4"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="wolf-gain-from-food">
#>         <value value="20"></value>
#>       </enumeratedValueSet>
#>     </constants>
#>     <subExperiments>
#>       <subExperiment>
#>         <enumeratedValueSet variable="sheep-reproduce">
#>           <value value="1"></value>
#>           <value value="6"></value>
#>           <value value="20"></value>
#>         </enumeratedValueSet>
#>       </subExperiment>
#>       <subExperiment>
#>         <enumeratedValueSet variable="wolf-reproduce">
#>           <value value="2"></value>
#>           <value value="7"></value>
#>           <value value="15"></value>
#>         </enumeratedValueSet>
#>       </subExperiment>
#>       <subExperiment>
#>         <enumeratedValueSet variable="sheep-gain-from-food">
#>           <value value="1"></value>
#>           <value value="8"></value>
#>           <value value="15"></value>
#>         </enumeratedValueSet>
#>       </subExperiment>
#>       <subExperiment>
#>         <enumeratedValueSet variable="wolf-gain-from-food">
#>           <value value="10"></value>
#>           <value value="20"></value>
#>           <value value="30"></value>
#>         </enumeratedValueSet>
#>       </subExperiment>
#>     </subExperiments>
#>   </experiment>
#> </experiments>

## Examples from the *Spread of Disease* Model (IABM Textbook) ----

### Population Density

setup_file <- create_experiment(
  name = "Population Density",
  repetitions = 10,
  sequential_run_order = TRUE,
  run_metrics_every_step = FALSE,
  time_limit = NULL,
  setup = 'setup',
  go = 'go',
  metrics = 'ticks',
  constants = list(
    "variant" = "mobile",
    "connections-per-node" = 4.1,
    "num-people" = list(
      first = 50,
      step = 50,
      last = 200
    ),
    "num-infected" = 1,
    "disease-decay" = 0
  )
)

setup_file
#> [1] "/tmp/Rtmp47kcfm/experiment-1e6a420fc276.xml"

setup_file |> inspect_experiment_file()
#> <experiments>
#>   <experiment name="Population Density" repetitions="10" sequentialRunOrder="true" runMetricsEveryStep="false">
#>     <setup>setup</setup>
#>     <go>go</go>
#>     <metrics>
#>       <metric>ticks</metric>
#>     </metrics>
#>     <constants>
#>       <enumeratedValueSet variable="variant">
#>         <value value="&quot;mobile&quot;"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="connections-per-node">
#>         <value value="4.1"></value>
#>       </enumeratedValueSet>
#>       <steppedValueSet variable="num-people" first="50" step="50" last="200"></steppedValueSet>
#>       <enumeratedValueSet variable="num-infected">
#>         <value value="1"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="disease-decay">
#>         <value value="0"></value>
#>       </enumeratedValueSet>
#>     </constants>
#>   </experiment>
#> </experiments>

### Degree

setup_file <- create_experiment(
  name = "Degree",
  repetitions = 10,
  sequential_run_order = TRUE,
  run_metrics_every_step = FALSE,
  time_limit = 50,
  setup = 'setup',
  go = 'go',
  metrics = 'count turtles with [infected?]',
  constants = list(
    "num-people" = 200,
    "connections-per-node" = list(
      first = 0.5,
      step = 0.5,
      last = 4
    ),
    "disease-decay" = 10,
    "variant" = "network",
    "num-infected" = 1
  )
)

setup_file
#> [1] "/tmp/Rtmp47kcfm/experiment-1e6a7fbf1ed.xml"

setup_file |> inspect_experiment_file()
#> <experiments>
#>   <experiment name="Degree" repetitions="10" sequentialRunOrder="true" runMetricsEveryStep="false" timeLimit="50">
#>     <setup>setup</setup>
#>     <go>go</go>
#>     <metrics>
#>       <metric>count turtles with [infected?]</metric>
#>     </metrics>
#>     <constants>
#>       <enumeratedValueSet variable="num-people">
#>         <value value="200"></value>
#>       </enumeratedValueSet>
#>       <steppedValueSet variable="connections-per-node" first="0.5" step="0.5" last="4"></steppedValueSet>
#>       <enumeratedValueSet variable="disease-decay">
#>         <value value="10"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="variant">
#>         <value value="&quot;network&quot;"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="num-infected">
#>         <value value="1"></value>
#>       </enumeratedValueSet>
#>     </constants>
#>   </experiment>
#> </experiments>

### Environmental

setup_file <- create_experiment(
  name = "Environmental",
  repetitions = 10,
  sequential_run_order = TRUE,
  run_metrics_every_step = FALSE,
  time_limit = NULL,
  setup = 'setup',
  go = 'go',
  metrics = 'ticks',
  constants = list(
    "num-people" = 200,
    "connections-per-node" = 4,
    "disease-decay" = list(
      first = 0,
      step = 1,
      last = 10
    ),
    "variant" = "environmental",
    "num-infected" = 1
  )
)

setup_file
#> [1] "/tmp/Rtmp47kcfm/experiment-1e6a28347984.xml"

setup_file |> inspect_experiment_file()
#> <experiments>
#>   <experiment name="Environmental" repetitions="10" sequentialRunOrder="true" runMetricsEveryStep="false">
#>     <setup>setup</setup>
#>     <go>go</go>
#>     <metrics>
#>       <metric>ticks</metric>
#>     </metrics>
#>     <constants>
#>       <enumeratedValueSet variable="num-people">
#>         <value value="200"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="connections-per-node">
#>         <value value="4"></value>
#>       </enumeratedValueSet>
#>       <steppedValueSet variable="disease-decay" first="0" step="1" last="10"></steppedValueSet>
#>       <enumeratedValueSet variable="variant">
#>         <value value="&quot;environmental&quot;"></value>
#>       </enumeratedValueSet>
#>       <enumeratedValueSet variable="num-infected">
#>         <value value="1"></value>
#>       </enumeratedValueSet>
#>     </constants>
#>   </experiment>
#> </experiments>
```
