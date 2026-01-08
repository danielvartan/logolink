# Parse NetLogo colors

`parse_netlogo_color()` parses NetLogo color codes into their
approximate [hexadecimal
color](https://en.wikipedia.org/wiki/Web_colors) representations.

**Note**: This function requires the
[`colorspace`](https://colorspace.r-forge.r-project.org/), and
[`scales`](https://scales.r-lib.org/) packages.

## Usage

``` r
parse_netlogo_color(x, bias = 0.1)
```

## Arguments

- x:

  A [`numeric`](https://rdrr.io/r/base/numeric.html) vector containing
  NetLogo color codes (ranging from `0` to `140`) to be parsed into
  [hexadecimal color](https://en.wikipedia.org/wiki/Web_colors)
  representations.

- bias:

  (optional) A [`numeric`](https://rdrr.io/r/base/numeric.html) value
  between `-1` and `1` that adjusts the lightness or darkness of the
  resulting colors. Positive values lighten colors, while negative
  values darken them. This only affects shaded colors (those with shades
  other than `5`) (default: `0.1`).

## Value

A [`character`](https://rdrr.io/r/base/character.html) vector containing
the approximate [hexadecimal
color](https://en.wikipedia.org/wiki/Web_colors) representations
corresponding to the input NetLogo color codes.

## Details

NetLogo color codes are based on `14` hues, which can be visualized by
running
[`base-colors`](https://docs.netlogo.org/dictionary.html#base-colors) in
the NetLogo console. Each hue can be adjusted using shades from `0` to
`9`, where `0` represents the darkest shade and `5` represents the base
shade. Shades `6` through `9` represent progressively lighter
variations.

Note that NetLogo also supports extracting
[RGB](https://en.wikipedia.org/wiki/RGB_color_model) components directly
with
[`extract-rgb`](https://docs.netlogo.org/dictionary.html#extract-rgb).
This function provides an alternative approach for obtaining color
representations from NetLogo color codes.

## See also

Other parsing functions:
[`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md)

## Examples

``` r
# Simple Parsing Examples -----

netlogo_base_colors <- c(
  "gray" = 5,
  "red" = 15,
  "orange" = 25,
  "brown" = 35,
  "yellow" = 45,
  "green" = 55,
  "lime" = 65,
  "turquoise" = 75,
  "cyan" = 85,
  "sky" = 95,
  "blue" = 105,
  "violet" = 115,
  "magenta" = 125,
  "pink" = 135
)

parse_netlogo_color(netlogo_base_colors)
#>  [1] "#8D8D8D" "#D73229" "#F16A15" "#9D6E48" "#ECEC29" "#59B03C" "#2CD13B"
#>  [8] "#1D9F78" "#54C4C4" "#2D8DBE" "#345DA9" "#7C50A4" "#A71B6A" "#D9637F"

parse_netlogo_color(seq(10, 20, by = 1))
#>  [1] "#FFFFFF" "#4D0200" "#6B110B" "#872521" "#A33935" "#D73229" "#FB554F"
#>  [8] "#FF8D8A" "#FFBCBB" "#FFE8E8" "#D73229"

parse_netlogo_color(seq(10, 20, by = 0.5))
#>  [1] "#FFFFFF" "#3D0100" "#4D0200" "#5E0500" "#6B110B" "#791B17" "#872521"
#>  [8] "#952F2B" "#A33935" "#B1433F" "#D73229" "#E9443D" "#FB554F" "#FF716D"
#> [15] "#FF8D8A" "#FFA5A4" "#FFBCBB" "#FFD2D2" "#FFE8E8" "#FFFDFD" "#D73229"

# Bias Adjustment Examples -----

parse_netlogo_color(17.5, bias = 0)
#> [1] "#FF9B98"

parse_netlogo_color(17.5, bias = -0.5)
#> [1] "#FF5B55"

parse_netlogo_color(17.5, bias = 0.5)
#> [1] "#FFCECE"
```
