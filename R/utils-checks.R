assert_netlogo_works <- function(
  netlogo_home = find_netlogo_home()
) {
  executable <- find_netlogo_executable(netlogo_home)

  if (executable == "") {
    cli::cli_abort(
      paste0(
        "Could not find the NetLogo executable. ",
        "Please make sure NetLogo is installed and ",
        "the {.strong {cli::col_red('NETLOGO_HOME')}} ",
        "environment variable is correctly set. ",
        "You can set it using ",
        '`Sys.setenv(NETLOGO_HOME = "[PATH]")`).'
      )
    )
  }

  test <-
    executable |>
    system2(args = c("--version"), stdout = TRUE, stderr = TRUE) |>
    try(silent = TRUE) |>
    suppressMessages() |>
    suppressWarnings()

  if (inherits(test, "try-error")) {
    cli::cli_abort(
      paste0(
        "Failed to run the NetLogo executable at ",
        "{.strong {cli::col_yellow(executable)}}. ",
        "Please make sure NetLogo is installed and ",
        "the {.strong {cli::col_red('NETLOGO_HOME')}} ",
        "environment variable is correctly set. ",
        "You can set it using ",
        '`Sys.setenv(NETLOGO_HOME = "[PATH]")`).'
      )
    )
  } else {
    TRUE
  }
}

test_nested_list <- function(x) {
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

test_one_depth_list <- function(x) {
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
