# Read NetLogo BehaviorSpace Experiment output

`read_experiment()` reads NetLogo
[BehaviorSpace](https://docs.netlogo.org/behaviorspace.html) experiment
output files as [tidy data
frames](https://r4ds.hadley.nz/data-tidy.html). It automatically detects
the output format
([Table](https://docs.netlogo.org/behaviorspace.html#table-output),
[Spreadsheet](https://docs.netlogo.org/behaviorspace.html#spreadsheet-output),
[Lists](https://docs.netlogo.org/behaviorspace.html#lists-output), or
[Stats](https://docs.netlogo.org/behaviorspace.html#statistics-output))
and parses the data accordingly. The function also extracts metadata
from the files.

Only version 2.0 (NetLogo 6.4 and later) of BehaviorSpace output files
is supported.

## Usage

``` r
read_experiment(file, tidy_output = TRUE)
```

## Arguments

- file:

  A [`character`](https://rdrr.io/r/base/character.html) string
  specifying the path to the
  [BehaviorSpace](https://docs.netlogo.org/behaviorspace.html) output
  [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) file.

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
output file provided:

- `metadata`: A [`list`](https://rdrr.io/r/base/list.html) with metadata
  about the experiment run (present in all cases).

- `table`: A
  [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
  the results of the
  [`table`](https://docs.netlogo.org/behaviorspace.html#table-output)
  output.

- `spreadsheet`: A [`list`](https://rdrr.io/r/base/list.html) with the
  results of the
  [`spreadsheet`](https://docs.netlogo.org/behaviorspace.html#spreadsheet-output)
  output containing two elements:

  - `statistics`: A
    [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
    data from the output first section.

  - `data`: A
    [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
    data from the output second section.

- `lists`: A
  [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
  the results of the
  [`lists`](https://docs.netlogo.org/behaviorspace.html#lists-output)
  output.

- `statistics`: A
  [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
  the results of the
  [`statistics`](https://docs.netlogo.org/behaviorspace.html#statistics-output)
  output.

## See also

Other BehaviorSpace functions:
[`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md),
[`inspect_experiment()`](https://danielvartan.github.io/logolink/reference/inspect_experiment.md),
[`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)

## Examples

``` r
file <- tempfile()

c(
  'BehaviorSpace results (NetLogo 7.0.3), "Table version 2.0"',
  paste0(
    '"/opt/NetLogo 7-0-3/models/',
    'IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
  ),
  '"Wolf Sheep Simple Model Analysis"',
  '"01/05/2026 06:37:48:683 -0300"',
  '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
  '"-17","17","-17","17"',
  paste0(
    '"[run number]","number-of-sheep","number-of-wolves",',
    '"movement-cost","grass-regrowth-rate","energy-gain-from-grass",',
    '"energy-gain-from-sheep","[step]","count wolves","count sheep"'
  ),
  '"3","500","5","0.5","0.3","2","5","0","5","500"',
  '"5","500","5","0.5","0.3","2","5","0","5","500"',
  '"4","500","5","0.5","0.3","2","5","0","5","500"',
  '"6","500","5","0.5","0.3","2","5","0","5","500"',
  '"1","500","5","0.5","0.3","2","5","0","5","500"',
  '"8","500","5","0.5","0.3","2","5","0","5","500"',
  '"9","500","5","0.5","0.3","2","5","0","5","500"',
  '"2","500","5","0.5","0.3","2","5","0","5","500"'
) |>
  writeLines(file)

read_experiment(file)
#> $metadata
#> $metadata$timestamp
#> [1] "2026-01-05 09:37:48 -03"
#> 
#> $metadata$netlogo_version
#> [1] "7.0.3"
#> 
#> $metadata$output_version
#> [1] "2.0"
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
#> # A tibble: 8 × 10
#>   run_number number_of_sheep number_of_wolves movement_cost grass_regrowth_rate
#>        <dbl>           <dbl>            <dbl>         <dbl>               <dbl>
#> 1          1             500                5           0.5                 0.3
#> 2          2             500                5           0.5                 0.3
#> 3          3             500                5           0.5                 0.3
#> 4          4             500                5           0.5                 0.3
#> 5          5             500                5           0.5                 0.3
#> 6          6             500                5           0.5                 0.3
#> 7          8             500                5           0.5                 0.3
#> 8          9             500                5           0.5                 0.3
#> # ℹ 5 more variables: energy_gain_from_grass <dbl>,
#> #   energy_gain_from_sheep <dbl>, step <dbl>, count_wolves <dbl>,
#> #   count_sheep <dbl>
#> 
```
