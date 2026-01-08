# Parse NetLogo lists

`parse_netlogo_list()` parses NetLogo-style lists represented as strings
(e.g., `"[1 2 3]"`) into R lists. It automatically detects
[`numeric`](https://rdrr.io/r/base/numeric.html),
[`integer`](https://rdrr.io/r/base/integer.html),
[`logical`](https://rdrr.io/r/base/logical.html), and
[`character`](https://rdrr.io/r/base/character.html) types within the
lists and converts them accordingly.

**Note**: We recommend using this function **only when necessary**, as
it can be computationally intensive for large datasets and may not
handle all edge cases. NetLogo provides a special output format called
[lists](https://docs.netlogo.org/behaviorspace.html#lists-output) that
exports list metrics in a tabular structure. If your experiment includes
metrics that return NetLogo lists, include `"lists"` in the `outputs`
argument of
[`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)
to capture this output.

## Usage

``` r
parse_netlogo_list(x)
```

## Arguments

- x:

  An
  [`atomic`](https://mllg.github.io/checkmate/reference/checkAtomic.html)
  vector potentially containing NetLogo-style lists.

## Value

A [`list`](https://rdrr.io/r/base/list.html) where each element is the
parsed result of the corresponding input element. Parsed elements may be
atomic vectors (for homogeneous lists) or nested lists (for mixed-type
or nested lists). If a NetLogo list is not detected in an input element,
that element is returned as a single-element
[`list`](https://rdrr.io/r/base/list.html) containing the original
string.

## Details

The function handles the following cases:

- **Homogeneous lists**: Lists containing elements of the same type are
  returned as atomic vectors (e.g., `"[1 2 3]"` becomes
  `c(1L, 2L, 3L)`).

- **Mixed-type lists**: Lists containing elements of different types are
  returned as R lists (e.g., `'[1.1 "a" true]'` becomes
  `list(1.1, "a", TRUE)`).

- **Nested lists**: Lists containing other lists are fused with the main
  list (e.g., `'["a" "b" [1 2]]'` becomes
  `list(c("a", "b"), c(1L, 2L))`).

NetLogo boolean values (`true`/`false`) are converted to R
[`logical`](https://rdrr.io/r/base/logical.html) values
(`TRUE`/`FALSE`). NetLogo `NaN` values are parsed as R
[`NaN`](https://rdrr.io/r/base/is.finite.html) .

## See also

Other parsing functions:
[`parse_netlogo_color()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_color.md)

## Examples

``` r
# Scalar Examples -----

'test' |> parse_netlogo_list() # Not a NetLogo list.
#> [[1]]
#> [1] "test"
#> 

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

c(1, 2, 3) |> parse_netlogo_list() # Not a NetLogo list.
#> [[1]]
#> [1] 1 2 3
#> 

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

# Mixed-Type Examples -----

'["a" "b" 1 2]' |> parse_netlogo_list()
#> [[1]]
#> [[1]][[1]]
#> [1] "a"
#> 
#> [[1]][[2]]
#> [1] "b"
#> 
#> [[1]][[3]]
#> [1] 1
#> 
#> [[1]][[4]]
#> [1] 2
#> 
#> 

'[1.1 2.1 3.1 true false]' |> parse_netlogo_list()
#> [[1]]
#> [[1]][[1]]
#> [1] 1.1
#> 
#> [[1]][[2]]
#> [1] 2.1
#> 
#> [[1]][[3]]
#> [1] 3.1
#> 
#> [[1]][[4]]
#> [1] TRUE
#> 
#> [[1]][[5]]
#> [1] FALSE
#> 
#> 

'[1.1 "a" true]' |> parse_netlogo_list()
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

'["a" "b" "c" [1 2]]' |> parse_netlogo_list()
#> [[1]]
#> [[1]][[1]]
#> [1] "a" "b" "c"
#> 
#> [[1]][[2]]
#> [1] 1 2
#> 
#> 

'["a" "b" "c" [1 2] true ["d" "c"]]' |> parse_netlogo_list()
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

'[[1 2] [3 4] [5 6]]' |> parse_netlogo_list()
#> [[1]]
#> [[1]][[1]]
#> [1] 1 2 3 4 5 6
#> 
#> 
```
