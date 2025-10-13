test_nested <- function(x) {
  if (is.list(x)) {
    if (length(x) == length(unlist(x))) {
      FALSE
    } else {
      TRUE
    }
  } else {
    FALSE
  }
}

test_one_depth <- function(x) {
  x |>
    purrr::map_lgl(\(x) purrr::pluck_depth(x) == 1) |>
    all()
}

test_same_class <- function(x) {
  x |>
    purrr::map_chr(\(x) class(x)[1]) |>
    unique() |>
    length() == 1
}

test_unitary_list <- function(x) {
  x |>
    purrr::map_lgl(\(x) length(x) == 1) |>
    all()
}
