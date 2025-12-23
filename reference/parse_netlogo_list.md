# Parse NetLogo lists

**Note**: We recommend using this function **only when necessary**, as
it can be computationally intensive for large datasets and may not
handle all edge cases. NetLogo provides a special output format called
*lists* that exports list metrics in a tabular structure. If your
experiment includes metrics that return NetLogo lists, include `"lists"`
in the `outputs` argument of
[`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)
to capture this output.

`parse_netlogo_list()` parses NetLogo-style lists represented as strings
(e.g., `"[1 2 3]"`) into R lists. It automatically detects
[`numeric`](https://rdrr.io/r/base/numeric.html),
[`integer`](https://rdrr.io/r/base/integer.html),
[`logical`](https://rdrr.io/r/base/logical.html), and
[`character`](https://rdrr.io/r/base/character.html) types within the
lists and converts them accordingly.

## Usage

``` r
parse_netlogo_list(x)
```

## Arguments

- x:

  An
  [`atomic`](https://mllg.github.io/checkmate/reference/checkAtomic.html)
  vector potentially containing NetLogo-style list strings.

## Value

The return value will depend on the input:

- If `x` does not contain NetLogo-style lists, returns the original
  vector unchanged.

- If `x` contains NetLogo-style lists, returns a
  [`list`](https://rdrr.io/r/base/list.html) where each element is the
  parsed result of the corresponding input element. Parsed elements may
  be atomic vectors (for homogeneous lists) or nested lists (for
  mixed-type or nested lists).

## Details

The function handles the following cases:

- **Homogeneous lists**: Lists containing elements of the same type are
  returned as atomic vectors (e.g., `"[1 2 3]"` becomes
  `c(1L, 2L, 3L)`).

- **Mixed-type lists**: Lists containing elements of different types are
  returned as R lists (e.g., `'[1.1 "a" true]'` becomes
  `list(1.1, "a", TRUE)`).

- **Nested lists**: Lists containing other lists are returned as nested
  R lists (e.g., `'["a" "b" [1 2]]'` becomes
  `list(c("a", "b"), c(1L, 2L))`).

NetLogo boolean values (`true`/`false`) are converted to R
[`logical`](https://rdrr.io/r/base/logical.html) values
(`TRUE`/`FALSE`). NetLogo [`NaN`](https://rdrr.io/r/base/is.finite.html)
values are preserved as character strings.

## See also

Other utility functions:
[`find_netlogo_console()`](https://danielvartan.github.io/logolink/reference/find_netlogo_console.md),
[`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md),
[`find_netlogo_version()`](https://danielvartan.github.io/logolink/reference/find_netlogo_version.md),
[`inspect_experiment_file()`](https://danielvartan.github.io/logolink/reference/inspect_experiment_file.md),
[`parse_netlogo_color()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_color.md)

## Examples

``` r
# Scalar Examples -----

'[1]' |> parse_netlogo_list()
#> [[1]]
#> [1] 1
#> 

'["a" "b" "c"]' |> parse_netlogo_list()
#> [[1]]
#> [1] "a" "b" "c"
#> 

'[1 2 3]' |> parse_netlogo_list()
#> [[1]]
#> [1] 1 2 3
#> 

'[1.1 2.1 3.1]' |> parse_netlogo_list()
#> [[1]]
#> [1] 1.1 2.1 3.1
#> 

'[true false true]' |> parse_netlogo_list()
#> [[1]]
#> [1]  TRUE FALSE  TRUE
#> 

# Vector Examples -----

c('["a" "b" "c"]', '["d" "e" "f"]') |> parse_netlogo_list()
#> [[1]]
#> [1] "a" "b" "c"
#> 
#> [[2]]
#> [1] "d" "e" "f"
#> 

c('[1 2 3]', '[4 5 6]') |> parse_netlogo_list()
#> [[1]]
#> [1] 1 2 3
#> 
#> [[2]]
#> [1] 4 5 6
#> 

c('[1.1 2.1 3.1]', '[4.1 5.1 6.1]') |> parse_netlogo_list()
#> [[1]]
#> [1] 1.1 2.1 3.1
#> 
#> [[2]]
#> [1] 4.1 5.1 6.1
#> 

c('[true false true]', '[false true false]') |> parse_netlogo_list()
#> [[1]]
#> [1]  TRUE FALSE  TRUE
#> 
#> [[2]]
#> [1] FALSE  TRUE FALSE
#> 

# Combined Examples -----

c('["a" "b" "c"]', '[4 5 6]') |> parse_netlogo_list()
#> [[1]]
#> [1] "a" "b" "c"
#> 
#> [[2]]
#> [1] 4 5 6
#> 

c('[1.1 2.1 3.1]', '[true false true]') |> parse_netlogo_list()
#> [[1]]
#> [1] 1.1 2.1 3.1
#> 
#> [[2]]
#> [1]  TRUE FALSE  TRUE
#> 

c('[1.1 "a" true]') |> parse_netlogo_list()
#> [[1]]
#> [[1]][[1]]
#> [1] 1.1
#> 
#> [[1]][[2]]
#> [1] "a"
#> 
#> [[1]][[3]]
#> [1] TRUE
#> 
#> 

# Nested Examples -----

c('["a" "b" "c" [1 2]]', '[4 5 6]') |> parse_netlogo_list()
#> [[1]]
#> [[1]][[1]]
#> [1] "a" "b" "c"
#> 
#> [[1]][[2]]
#> [1] 1 2
#> 
#> 
#> [[2]]
#> [1] 4 5 6
#> 

c('["a" "b" "c" [1 2] true ["d" "c"]]') |> parse_netlogo_list()
#> [[1]]
#> [[1]][[1]]
#> [1] "a" "b" "c"
#> 
#> [[1]][[2]]
#> [1] 1 2
#> 
#> [[1]][[3]]
#> [1] TRUE
#> 
#> [[1]][[4]]
#> [1] "d" "c"
#> 
#> 
```
