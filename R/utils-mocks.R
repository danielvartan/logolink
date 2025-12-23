# See `?testthat::local_mocked_bindings` to learn more.

require_namespace <- function(x, ..., quietly = TRUE) {
  requireNamespace(x, ..., quietly = quietly)
}

system_2 <- function(...) system2(...)
temp_file <- function(...) tempfile(...)
