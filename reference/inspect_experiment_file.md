# Inspect a BehaviorSpace experiment XML file

`inspect_experiment_file()` reads and prints the content of a
BehaviorSpace experiment XML file to the console. This is useful for
debugging and verifying the structure of experiment files created by
[`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md).

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
function is called for its side effect of printing the XML content to
the console.

## See also

Other utility functions:
[`find_netlogo_console()`](https://danielvartan.github.io/logolink/reference/find_netlogo_console.md),
[`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md),
[`find_netlogo_version()`](https://danielvartan.github.io/logolink/reference/find_netlogo_version.md),
[`parse_netlogo_color()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_color.md),
[`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md)

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
#>   </experiment>
#> </experiments>
```
