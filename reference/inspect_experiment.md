# Inspect NetLogo BehaviorSpace experiment file

`inspect_experiment()` reads and prints the content of a NetLogo
[BehaviorSpace](https://docs.netlogo.org/behaviorspace.html) experiment
[XML](https://en.wikipedia.org/wiki/XML) file to the R console. This is
useful for debugging and verifying the structure of experiment files
created by
[`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md).

For complete guidance on setting up and running experiments in NetLogo,
please refer to the [BehaviorSpace
Guide](https://docs.netlogo.org/behaviorspace.html#creating-an-experiment-setup).

## Usage

``` r
inspect_experiment(file)
```

## Arguments

- file:

  A [`character`](https://rdrr.io/r/base/character.html) string
  specifying the path to the
  [BehaviorSpace](https://docs.netlogo.org/behaviorspace.html)
  experiment [XML](https://en.wikipedia.org/wiki/XML) file.

## Value

An [invisible](https://rdrr.io/r/base/invisible.html) `NULL`. This
function is called for its side effect of printing the
[XML](https://en.wikipedia.org/wiki/XML) content to the R console.

## See also

Other BehaviorSpace functions:
[`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md),
[`read_experiment()`](https://danielvartan.github.io/logolink/reference/read_experiment.md),
[`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)

## Examples

``` r
file <- create_experiment(name = "My Experiment")

file |> inspect_experiment()
#> <experiments>
#>   <experiment name="My Experiment" repetitions="1" sequentialRunOrder="true" runMetricsEveryStep="false" timeLimit="1">
#>     <setup>setup</setup>
#>     <go>go</go>
#>     <metrics>
#>       <metric>count turtles</metric>
#>     </metrics>
#>   </experiment>
#> </experiments>
```
