# See `?testthat::local_mocked_bindings` to learn more.

# `base`

require_namespace <- function(x, ..., quietly = TRUE) {
  requireNamespace(x, ..., quietly = quietly)
}

sys_info <- function(...) Sys.info(...)
system_2 <- function(...) system2(...)
temp_file <- function(...) tempfile(...)

## `fs`

path <- function(...) fs::path(...)

## `httr2`

resp_body_json <- function(...) httr2::resp_body_json(...)
resp_body_string <- function(...) httr2::resp_body_string(...)
req_perform <- function(...) httr2::req_perform(...)
