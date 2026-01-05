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
#' 1. **Console execution**: If the NetLogo console executable is found
#'    by [`find_netlogo_console()`][find_netlogo_console()], it
#'    runs `NetLogo_Console --headless --version` to retrieve the version
#'    information. This is the most reliable method.
#' 2. **Directory name extraction**: If the executable is not found, it
#'    attempts to extract the version number from the installation directory
#'    name returned by [`find_netlogo_home()`][find_netlogo_home()]
#'    (e.g., `NetLogo 7.0.2` yields `"7.0.2"`).
#'
#' Note that the directory name fallback may produce slightly different
#' results if the directory was renamed or uses a non-standard naming
#' convention.
#'
#' @return A [`character`][base::character()] string specifying the NetLogo
#'   version (e.g., `"7.0.3"`). Returns an empty string (`""`) if the version
#'   cannot be determined.
#'
#' @family system functions
#' @export
#'
#' @examples
#' \dontrun{
#'   find_netlogo_version()
#' }
find_netlogo_version <- function() {
  # R CMD Check variable bindings fix.
  # nolint start
  . <- NULL
  # nolint end

  netlogo_console <- find_netlogo_console()

  if (netlogo_console != "" && file.exists(netlogo_console)) {
    netlogo_console |>
      system_2(
        args = c("--headless --version"),
        stdout = TRUE,
        stderr = TRUE
      ) |>
      stringr::str_remove_all("NetLogo") |>
      stringr::str_squish()
  } else {
    netlogo_home <- find_netlogo_home()

    out <-
      netlogo_home |>
      basename() |>
      stringr::str_extract("\\d+.\\d+(.\\d+)?") |>
      stringr::str_replace_all("\\D", ".") %>%
      ifelse(is.na(.), "", .)
  }
}
