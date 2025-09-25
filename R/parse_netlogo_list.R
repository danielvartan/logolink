parse_netlogo_list <- function(x) {
  pattern <- "^\\[.*\\]$"

  if (stringr::str_detect(x, pattern)) {
    x |>
      stringr::str_remove_all("^\\[|\\]$") |>
      stringr::str_split(" ") |>
      purrr::map(
        function(x) {
          if (!anyNA(as.numeric(x))) {
            if (all(as.numeric(x) == as.integer(x))) {
              x |> as.integer()
            } else {
              x |> as.numeric()
            }
          } else if (!anyNA(as.logical(x))) {
            x |> as.logical()
          } else {
            x
          }
        }
      )
  } else {
    x
  }
}
