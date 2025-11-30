#' Find NetLogo Version
#'
#' @description
#'
#' `find_netlogo_version()` attempts to locate the NetLogo version installed on
#' the user's system.
#'
#' It first tries to execute the NetLogo console with the `--version` argument
#' to retrieve the version information. If the executable is not found, it
#' attempts to extract the version number from the installation directory name.
#'
#' @return A [`character`][base::character] string specifying the NetLogo
#'   version installed on the user's system. If the version cannot be
#'   determined, an empty string is returned.
#'
#' @template params-netlogo-home
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
      system2(args = c("--version"), stdout = TRUE, stderr = TRUE) |>
      stringr::str_remove_all("NetLogo") |>
      stringr::str_squish()
  }

  out
}
