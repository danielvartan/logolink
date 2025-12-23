#' Find NetLogo version
#'
#' @description
#'
#' `find_netlogo_version()` attempts to determine the NetLogo version installed
#' on the user's system.
#'
#' @details
#'
#' The function uses the following detection methods in order:
#'
#' 1. **Console execution**: If the NetLogo console executable is found, it
#'    runs `NetLogo_Console --version` to retrieve the version information.
#'    This is the most reliable method.
#' 2. **Directory name extraction**: If the executable is not found, it
#'    attempts to extract the version number from the installation directory
#'    name (e.g., `netlogo-7.0.2` yields `"7.0.2"`).
#'
#' Note that the directory name fallback may produce slightly different
#' results if the directory was renamed or uses a non-standard naming
#' convention.
#'
#' @template params-netlogo-home
#'
#' @return A [`character`][base::character()] string specifying the NetLogo
#'   version (e.g., `"7.0.2"`). Returns an empty string (`""`) if the version
#'   cannot be determined.
#'
#' @family utility functions
#' @export
#'
#' @examples
#' \dontrun{
#'   find_netlogo_version()
#' }
find_netlogo_version <- function(
  netlogo_home = find_netlogo_home()
) {
  checkmate::assert_string(netlogo_home)

  netlogo_home <- fs::path_expand(netlogo_home)
  executable_path <- find_netlogo_console(netlogo_home)

  if (executable_path == "") {
    out <-
      netlogo_home |>
      basename() |>
      stringr::str_extract("\\d+.\\d+(.\\d+)?") |>
      stringr::str_replace_all("\\D", ".")

    if (is.na(out)) out <- ""
  } else {
    out <-
      executable_path |>
      system2(
        args = c("--headless --version"),
        stdout = TRUE,
        stderr = TRUE
      ) |>
      stringr::str_remove_all("NetLogo") |>
      stringr::str_squish()
  }

  out
}
