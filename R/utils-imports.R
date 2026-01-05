# `rutils` -> github.com/danielvartan/rutils

require_package <- function(...) {
  out <- list(...)

  lapply(
    out,
    checkmate::assert_string,
    pattern = "^[A-Za-z][A-Za-z0-9.]+[A-Za-z0-9]*$"
  )

  if (!identical(unique(unlist(out)), unlist(out))) {
    cli::cli_abort(
      "{.strong {cli::col_red('...')}} cannot have duplicated values."
    )
  }

  package <- unlist(out)

  namespace <- vapply(
    package,
    require_namespace,
    logical(1),
    quietly = TRUE,
    USE.NAMES = FALSE
  )

  package <- package[!namespace]

  if (length(package) == 0) {
    invisible()
  } else {
    cli::cli_abort(
      paste0(
        "This function requires the ",
        "{.strong {cli::col_red(package)}} package{?s} ",
        "to run. You can install {?it/them} by running:",
        "\n\n",
        "install.packages(",
        "c({paste(glue::double_quote(package), collapse = ', ')})",
        ")"
      )
    )
  }
}
