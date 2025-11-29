# Parse NetLogo lists

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
  object potentially containing NetLogo-style lists.

## Value

A [`list`](https://rdrr.io/r/base/list.html) of parsed elements if the
input contains NetLogo-style lists; otherwise, returns the original
vector.

## See also

Other utility functions:
[`inspect_experiment_file()`](https://danielvartan.github.io/logolink/reference/inspect_experiment_file.md)

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
