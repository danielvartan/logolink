# Borrowed from `rutils`: github.com/danielvartan/rutils
require_pkg <- function(...) {
  out <- list(...)

  lapply(
    out,
    checkmate::assert_string,
    pattern = "^[A-Za-z][A-Za-z0-9.]+[A-Za-z0-9]*$"
  )

  if (!identical(unique(unlist(out)), unlist(out))) {
    cli::cli_abort("'...' cannot have duplicated values.")
  }

  pkg <- unlist(out)
  namespace <- vapply(
    pkg,
    require_namespace,
    logical(1),
    quietly = TRUE,
    USE.NAMES = FALSE
  )
  pkg <- pkg[!namespace]

  if (length(pkg) == 0) {
    invisible(NULL)
  } else {
    cli::cli_abort(
      paste0(
        "This function requires the ",
        "{.strong {cli::col_red(pkg)}} package{?s} ",
        "to run. You can install {?it/them} by running:",
        "\n\n",
        "install.packages(c({paste(glue::double_quote(pkg), collapse = ', ')}))"
      )
    )
  }
}
