# Inspect a BehaviorSpace experiment XML file

`inspect_experiment_file()` reads and prints the content of a
BehaviorSpace experiment XML file. This is useful for debugging and
understanding the structure of the experiment file.

## Usage

``` r
inspect_experiment_file(file)
```

## Arguments

- file:

  A [`character`](https://rdrr.io/r/base/character.html) string
  specifying the path to the BehaviorSpace experiment XML file.

## Value

An [invisible](https://rdrr.io/r/base/invisible.html) `NULL`. This
function is used for its side effect.

## Examples

``` r
file <- create_experiment(name = "My Experiment")

file |> inspect_experiment_file()
#> <experiments>
#>   <experiment name="My Experiment" repetitions="1" sequentialRunOrder="true" runMetricsEveryStep="false" timeLimit="1">
#>     <setup>setup</setup>
#>     <go>go</go>
#>     <metrics>
#>       <metric>count turtles</metric>
#>       <metric>count patches</metric>
#>     </metrics>
#>     <constants/>
#>   </experiment>
#> </experiments>
```
