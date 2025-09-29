#' Parse NetLogo Lists
#'
#' @description
#'
#' `parse_netlogo_list()` parses NetLogo-style lists represented as strings
#' (e.g., `"[1 2 3]"`) into R lists. It automatically detects
#' [`numeric`][numeric()], [`integer`][integer()], [`logical`][logical()],
#' and [`character`][character()] types within the lists and converts them
#' accordingly.
#'
#' If the input does not contain NetLogo-style lists, it returns the original
#' vector unchanged.
#'
#' @param x An [`atomic`][checkmate::assert_atomic()] object potentially
#'   containing NetLogo-style lists.
#'
#' @return A [`list`][list()] of parsed elements if the input contains
#'   NetLogo-style lists; otherwise, returns the original vector.
#'
#' @family Utility functions
#' @export
#'
#' @examples
#' # Scalar Examples -----
#'
#' '["a" "b" "c"]' |> parse_netlogo_list()
#'
#' '[1 2 3]' |> parse_netlogo_list()
#'
#' '[1.1 2.1 3.1]' |> parse_netlogo_list()
#'
#' '[true false true]' |> parse_netlogo_list()
#'
#' # Vector Examples -----
#'
#' c('["a" "b" "c"]', '["d" "e" "f"]') |> parse_netlogo_list()
#'
#' c('[1 2 3]', '[4 5 6]') |> parse_netlogo_list()
#'
#' c('[1.1 2.1 3.1]', '[4.1 5.1 6.1]') |> parse_netlogo_list()
#'
#' c('[true false true]', '[false true false]') |> parse_netlogo_list()
parse_netlogo_list <- function(x) {
  checkmate::assert_atomic(x)

  pattern <- "^\\[.*\\]$"

  if (all(stringr::str_detect(x, pattern), na.rm = TRUE)) {
    x |>
      stringr::str_remove_all("^\\[|\\]$") |>
      stringr::str_split(" ") |>
      purrr::map(
        function(x) {
          if (!anyNA(as.numeric(x) |> suppressWarnings())) {
            if (all(
              suppressWarnings(as.numeric(x)) ==
                suppressWarnings(as.integer(x))
            )) {
              x |> as.integer()
            } else {
              x |> as.numeric()
            }
          } else if (!anyNA(as.logical(x) |> suppressWarnings())) {
            x |> as.logical()
          } else if (stringr::str_detect(x[1], '^".*"$')) {
            x |> stringr::str_remove_all('^"|"$')
          } else {
            x
          }
        }
      )
  } else {
    x
  }
}
