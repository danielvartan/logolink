#' Parse NetLogo colors
#'
#' @description
#'
#' `parse_netlogo_color()` parses NetLogo color codes into their approximate
#' [hexadecimal color](https://en.wikipedia.org/wiki/Web_colors)
#' representations.
#'
#' **Note**: This function requires the
#' [`colorspace`](https://colorspace.r-forge.r-project.org/),
#' and
#' [`scales`](https://scales.r-lib.org/) packages.
#'
#' @details
#'
#' NetLogo color codes are based on `14` hues, which can be visualized by
#' running
#' [`base-colors`](https://docs.netlogo.org/dictionary.html#base-colors)
#' in the NetLogo console. Each hue can be adjusted using shades from `0` to
#' `9`, where `0` represents the darkest shade and `5` represents the base
#' shade. Shades `6` through `9` represent progressively lighter variations.
#'
#' Note that NetLogo also supports extracting
#' [RGB](https://en.wikipedia.org/wiki/RGB_color_model)
#' components directly with
#' [`extract-rgb`](https://docs.netlogo.org/dictionary.html#extract-rgb).
#' This function provides an alternative approach for obtaining color
#' representations from NetLogo color codes.
#'
#' @param x A [`numeric`][base::numeric()] vector containing NetLogo color
#'   codes (ranging from `0` to `140`) to be parsed into
#'   [hexadecimal](https://en.wikipedia.org/wiki/Web_colors)
#'   color representations.
#' @param bias (optional) A [`numeric`][base::numeric()] value between `-1` and
#'   `1` that adjusts the lightness or darkness of the resulting colors.
#'   Positive values lighten colors, while negative values darken them. This
#'   only affects shaded colors (those with shades other than 5)
#'   (default: `0.1`).
#'
#' @return A [`character`][base::character()] vector containing the
#'   approximate
#'   [hexadecimal](https://en.wikipedia.org/wiki/Web_colors)
#'   color representations corresponding to the input NetLogo color codes.
#'
#' @family parsing functions
#' @export
#'
#' @examples
#' # Simple Parsing Examples -----
#'
#' netlogo_base_colors <- c(
#'   "gray" = 5,
#'   "red" = 15,
#'   "orange" = 25,
#'   "brown" = 35,
#'   "yellow" = 45,
#'   "green" = 55,
#'   "lime" = 65,
#'   "turquoise" = 75,
#'   "cyan" = 85,
#'   "sky" = 95,
#'   "blue" = 105,
#'   "violet" = 115,
#'   "magenta" = 125,
#'   "pink" = 135
#' )
#'
#' parse_netlogo_color(netlogo_base_colors)
#'
#' parse_netlogo_color(seq(10, 20, by = 1))
#'
#' parse_netlogo_color(seq(10, 20, by = 0.5))
#'
#' # Bias Adjustment Examples -----
#'
#' parse_netlogo_color(17.5, bias = 0)
#'
#' parse_netlogo_color(17.5, bias = -0.5)
#'
#' parse_netlogo_color(17.5, bias = 0.5)
parse_netlogo_color <- function(x, bias = 0.1) {
  require_package("colorspace", "grDevices", "scales")

  checkmate::assert_numeric(x, lower = 0, upper = 140)
  checkmate::assert_number(bias, lower = -1, upper = 1)

  # R CMD Check variable bindings fix
  # nolint start
  base_color <- NULL
  # nolint end

  x |>
    dplyr::as_tibble() |>
    dplyr::mutate(
      base_color = dplyr::case_when(
        dplyr::between(value, 0, 10) ~ "gray",
        dplyr::between(value, 10, 20) ~ "red",
        dplyr::between(value, 20, 30) ~ "orange",
        dplyr::between(value, 30, 40) ~ "brown",
        dplyr::between(value, 40, 50) ~ "yellow",
        dplyr::between(value, 50, 60) ~ "green",
        dplyr::between(value, 60, 70) ~ "lime",
        dplyr::between(value, 70, 80) ~ "turquoise",
        dplyr::between(value, 80, 90) ~ "cyan",
        dplyr::between(value, 90, 100) ~ "sky",
        dplyr::between(value, 100, 110) ~ "blue",
        dplyr::between(value, 110, 120) ~ "violet",
        dplyr::between(value, 120, 130) ~ "magenta",
        dplyr::between(value, 130, 140) ~ "pink"
      ),
      netlogo_color = dplyr::case_match(
        base_color,
        "gray" ~ "#8D8D8D",
        "red" ~ "#D73229",
        "orange" ~ "#F16A15",
        "brown" ~ "#9D6E48",
        "yellow" ~ "#ECEC29",
        "green" ~ "#59B03C",
        "lime" ~ "#2CD13B",
        "turquoise" ~ "#1D9F78",
        "cyan" ~ "#54C4C4",
        "sky" ~ "#2D8DBE",
        "blue" ~ "#345DA9",
        "violet" ~ "#7C50A4",
        "magenta" ~ "#A71B6A",
        "pink" ~ "#D9637F"
      ),
      shade = dplyr::case_when(
        value %% 10 == 0 ~ "normal",
        value %% 10 <= 5 ~ "darker",
        value %% 10 > 5 ~ "lighter"
      ),
      color = dplyr::case_when(
        shade == "normal" ~ netlogo_color,
        shade == "lighter" ~ {
          amount <-
            value |>
            magrittr::mod(10) %>%
            magrittr::subtract(5, .) |>
            abs() |>
            magrittr::multiply_by(1 + bias) |>
            scales::rescale(to = c(0, 1), from = c(0, 5))

          rep(NA_character_, length(netlogo_color)) |>
            magrittr::inset(
              !is.na(netlogo_color),
              colorspace::lighten(
                netlogo_color[!is.na(netlogo_color)],
                amount = amount[!is.na(netlogo_color)]
              )
            )
        },
        shade == "darker" ~ {
          amount <-
            value |>
            magrittr::mod(10) %>%
            magrittr::subtract(5) |>
            abs() |>
            magrittr::multiply_by(1 + (-bias)) |>
            scales::rescale(to = c(0, 1), from = c(0, 5))

          rep(NA_character_, length(netlogo_color)) |>
            magrittr::inset(
              !is.na(netlogo_color),
              colorspace::darken(
                netlogo_color[!is.na(netlogo_color)],
                amount = amount[!is.na(netlogo_color)]
              )
            )
        }
      )
    ) |>
    dplyr::pull("color")
}

parse_netlogo_color.base_colors <- c(
  "black" = 0,
  "white" = 10,
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

parse_netlogo_color.hex_colors <- c(
  "black" = "#000000",
  "white" = "#FFFFFF",
  "gray" = "#8D8D8D",
  "red" = "#D73229",
  "orange" = "#F16A15",
  "brown" = "#9D6E48",
  "yellow" = "#ECEC29",
  "green" = "#59B03C",
  "lime" = "#2CD13B",
  "turquoise" = "#1D9F78",
  "cyan" = "#54C4C4",
  "sky" = "#2D8DBE",
  "blue" = "#345DA9",
  "violet" = "#7C50A4",
  "magenta" = "#A71B6A",
  "pink" = "#D9637F"
)

parse_netlogo_color.xml_colors <- c(
  "black" = "255",
  "white" = "-1",
  "gray" = "-1920102913",
  "red" = "-684578305",
  "orange" = "-244705793",
  "brown" = "-1653716737",
  "yellow" = "-303222273",
  "green" = "1504722175",
  "lime" = "751909887",
  "turquoise" = "496990463",
  "cyan" = "1422181631",
  "sky" = "764264191",
  "blue" = "878553599",
  "violet" = "2085659903",
  "magenta" = "-1491375361",
  "pink" = "-528509185"
)
