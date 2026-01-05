assert_internet <- function() {
  require_package("httr2")

  if (!is_online()) {
    cli::cli_abort(
      paste0(
        "An active internet connection is required to run this function. ",
        "Please check your connection and try again."
      )
    )
  } else {
    invisible(TRUE)
  }
}

assert_netlogo_console <- function(
  netlogo_console = find_netlogo_console()
) {
  checkmate::assert_string(netlogo_console)

  netlogo_console <- path_expand(netlogo_console)

  if ((netlogo_console == "") || !file.exists(netlogo_console)) {
    cli::cli_abort(
      paste0(
        "Could not find the NetLogo console. ",
        "See the ",
        "{.strong {cli::col_red('run_experiment()')}} ",
        "documentation ({.code ?run_experiment}) for more information ",
        "on setting the NetLogo installation path."
      )
    )
  }

  test <-
    netlogo_console |>
    stringr::str_remove("\\.exe$") |>
    system_2(args = c("--help"), stdout = TRUE, stderr = TRUE) |>
    try(silent = TRUE) |>
    suppressMessages() |>
    suppressWarnings()

  if (inherits(test, "try-error")) {
    cli::cli_abort(
      paste0(
        "Failed to run the NetLogo console at ",
        "{.strong {cli::col_yellow(netlogo_console)}}. ",
        "See the ",
        "{.strong {cli::col_red('run_experiment()')}} ",
        "documentation ({.code ?run_experiment}) for more information ",
        "on setting the NetLogo installation path."
      )
    )
  } else {
    invisible(TRUE)
  }
}

assert_other_arguments <- function(
  other_arguments,
  reserved_arguments,
  null_ok = FALSE
) {
  checkmate::assert_character(other_arguments, null.ok = TRUE)
  checkmate::assert_character(reserved_arguments)
  checkmate::assert_flag(null_ok)

  # R CMD Check variable bindings fix.
  # nolint start
  . <- NULL
  # nolint end

  if (isTRUE(null_ok) && is.null(other_arguments)) {
    invisible(TRUE)
  } else {
    checkmate::assert_character(other_arguments)

    conflict <-
      other_arguments |>
      magrittr::extract(other_arguments %in% reserved_arguments)

    if (length(conflict) > 0) {
      cli::cli_abort(
        c(
          paste0(
            "The following command-line arguments are reserved ",
            "and cannot be modified via the ",
            "{.strong {cli::col_red('other_arguments')}} ",
            "parameter:"
          ),
          "",
          paste0(
            "{.strong {cli::col_blue('",
            conflict,
            "')}}"
          ) %>%
            magrittr::set_names(rep(" ", length(.)))
        )
      )
    } else {
      invisible(TRUE)
    }
  }
}

assert_pick_one <- function(x, y) {
  name_x <- deparse(substitute(x)) #nolint
  name_y <- deparse(substitute(y)) #nolint

  if (is.null(x) && is.null(y)) {
    cli::cli_abort(
      paste0(
        "One of {.strong {cli::col_blue(name_x)}} or ",
        "{.strong {cli::col_red(name_y)}} must be provided."
      )
    )
  } else if (!is.null(x) && !is.null(y)) {
    cli::cli_abort(
      paste0(
        "Only one of {.strong {cli::col_blue(name_x)}} or ",
        "{.strong {cli::col_red(name_y)}} can be provided."
      )
    )
  } else {
    invisible(TRUE)
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
    length() ==
    1
}

test_unitary_list <- function(x) {
  x |>
    purrr::map_lgl(\(x) length(x) == 1) |>
    all()
}
