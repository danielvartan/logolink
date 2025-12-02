#' Parse NetLogo lists
#'
#' @description
#'
#' `parse_netlogo_list()` parses NetLogo-style lists represented as strings
#' (e.g., `"[1 2 3]"`) into R lists. It automatically detects
#' [`numeric`][base::numeric()], [`integer`][base::integer()],
#' [`logical`][base::logical()], and [`character`][base::character()] types
#' within the lists and converts them accordingly.
#'
#' @details
#'
#' The function handles the following cases:
#'
#' - **Homogeneous lists**: Lists containing elements of the same type are
#'   returned as atomic vectors (e.g., `"[1 2 3]"` becomes `c(1L, 2L, 3L)`).
#' - **Mixed-type lists**: Lists containing elements of different types are
#'   returned as R lists (e.g., `'[1.1 "a" true]'` becomes
#'   `list(1.1, "a", TRUE)`).
#' - **Nested lists**: Lists containing other lists are returned as nested R
#'   lists (e.g., `'["a" "b" [1 2]]'` becomes
#'   `list(c("a", "b"), c(1L, 2L))`).
#'
#' NetLogo boolean values (`true`/`false`) are converted to R
#' [`logical`][base::logical()] values (`TRUE`/`FALSE`). NetLogo
#' [`NaN`][base::is.nan()] values are preserved as character strings.
#'
#' @param x An [`atomic`][checkmate::assert_atomic] vector potentially
#'   containing NetLogo-style list strings.
#'
#' @return The return value will depend on the input:
#'   - If `x` does not contain NetLogo-style lists, returns the original vector
#'     unchanged.
#'   - If `x` contains NetLogo-style lists, returns a [`list`][base::list()]
#'     where each element is the parsed result of the corresponding input
#'     element. Parsed elements may be atomic vectors (for homogeneous lists) or
#'     nested lists (for mixed-type or nested lists).
#'
#' @family utility functions
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

# fmt: skip
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

    while (length(out) == 1 && !test_one_depth_list(out)) {
      out <- purrr::flatten(out)
    }

    if (test_one_depth_list(out) && test_same_class(out)) {
      out <- unlist(out)

      if (checkmate::test_integerish(out)) {
        as.integer(out)
      } else {
        out
      }
    } else if (test_one_depth_list(out) && !test_same_class(out)) {
      out
    } else {
      out <-
        out |>
        purrr::map(\(x) if (!test_nested_list(x)) x |> unlist() else x)

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
