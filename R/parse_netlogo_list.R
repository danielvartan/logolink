#' Parse NetLogo lists
#'
#' @description
#'
#' `parse_netlogo_list()` parses NetLogo-style lists represented as strings
#' (e.g., `"[1 2 3]"`) into R lists. It automatically detects
#' [`numeric`][numeric()], [`integer`][integer()], [`logical`][logical()],
#' and [`character`][character()] types within the lists and converts them
#' accordingly.
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
#' '[1]' |> parse_netlogo_list()
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
#'
#' # Combined Examples -----
#'
#' c('["a" "b" "c"]', '[4 5 6]') |> parse_netlogo_list()
#'
#' c('[1.1 2.1 3.1]', '[true false true]') |> parse_netlogo_list()
#'
#' c('[1.1 "a" true]') |> parse_netlogo_list()
#'
#' # Nested Examples -----
#'
#' c('["a" "b" "c" [1 2]]', '[4 5 6]') |> parse_netlogo_list()
#'
#' c('["a" "b" "c" [1 2] true ["d" "c"]]') |> parse_netlogo_list()
parse_netlogo_list <- function(x) {
  checkmate::assert_atomic(x)

  if (is.character(x)) {
    if (
    test_unitary_list(x) &&
      !any(stringr::str_detect(x, "^\\[.*\\]$"), na.rm = TRUE)
    ) {
      x
    } else {
      x |> purrr::map(parse_netlogo_list.scalar)
    }
  } else {
    x
  }
}

parse_netlogo_list.scalar <- function(x) { #nolint
  checkmate::assert_atomic(x)

  # R CMD Check variable bindings fix.
  # nolint start
  . <- NULL
  # nolint end

  if (all(stringr::str_detect(x, "^\\[.*\\]$"), na.rm = TRUE)) {
    out <-
      x |>
      stringr::str_replace_all("\\[", "list(") |>
      stringr::str_replace_all("\\]", ")") |>
      stringr::str_replace_all(" ", ", ") %>%
      stringr::str_replace_all("(?<=\\b)true(?=\\b)", "TRUE") |>
      stringr::str_replace_all("(?<=\\b)false(?=\\b)", "FALSE") |>
      stringr::str_replace_all("(?<=\\b)NaN(?=\\b)", "'NaN'") %>%
      paste0("list(", ., ")") |>
      parse(text = _) |>
      eval()

    while (length(out) == 1 && !test_one_depth(out)) {
      out <- purrr::flatten(out)
    }

    if (test_one_depth(out) && test_same_class(out)) {
      out <- unlist(out)

      if (checkmate::test_integerish(out)) {
        as.integer(out)
      } else {
        out
      }
    } else if (test_one_depth(out) && !test_same_class(out)) {
      out
    } else {
      out <-
        out |>
        purrr::map(\(x) if (!test_nested(x)) x |> unlist() else x)

      data <- out
      ref_index <- 1
      aggregator <- list()
      aggregator_index <- 1
      out <- list()

      for (i in seq_along(data)) {
        if (
          purrr::pluck_depth(data[[i]]) == 1 &&
            identical(class(data[[i]]), class(data[[ref_index]]))
        ) {
          aggregator <- append(aggregator, data[[i]])
        } else {
          out[[aggregator_index]] <- unlist(aggregator)
          ref_index <- i
          aggregator <- list(data[[i]])
          aggregator_index <- aggregator_index + 1
        }

        if (dplyr::last(seq_along(data))) {
          out[[aggregator_index]] <- unlist(aggregator)
        }
      }

      out
    }
  } else {
    x
  }
}
