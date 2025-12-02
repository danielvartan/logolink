#' Find NetLogo executable file
#'
#' @description
#'
#' `find_netlogo_console()` attempts to locate the NetLogo executable file on
#' the user's system.
#'
#' @details
#'
#' The function uses the following search order:
#'
#' 1. Checks the `NETLOGO_CONSOLE` environment variable. If set and the file
#'    exists, returns that path.
#' 2. If the environment variable is not set or the file does not exist,
#'    constructs the path based on `netlogo_home` (e.g.,
#'    `<netlogo_home>/NetLogo_Console` on Linux/macOS or
#'    `<netlogo_home>/NetLogo_Console.exe` on Windows).
#'
#' @template params-netlogo-home
#'
#' @return A [`character`][base::character()] string specifying the path to the
#'   NetLogo executable file. Returns an empty string (`""`) if the executable
#'   cannot be found at any location.
#'
#' @family utility functions
#' @export
#'
#' @examples
#' \dontrun{
#'   find_netlogo_console()
#' }
find_netlogo_console <- function(
  netlogo_home = find_netlogo_home()
) {
  checkmate::assert_string(netlogo_home)

  netlogo_home <- fs::path_expand(netlogo_home)

  out <- ""

  if (!Sys.getenv("NETLOGO_CONSOLE") == "") {
    out <-
      Sys.getenv("NETLOGO_CONSOLE") |>
      normalizePath(mustWork = FALSE)
  }

  if ((!netlogo_home == "") && !file.exists(out)) {
    if (.Platform$OS.type == "windows") {
      out <- fs::path(netlogo_home, "NetLogo_Console.exe")
    } else if (Sys.info()["sysname"] == "Darwin") {
      out <- fs::path(netlogo_home, "NetLogo_Console")
    } else {
      out <- fs::path(netlogo_home, "NetLogo_Console")
    }
  }

  if (file.exists(out)) {
    out |>
      normalizePath(mustWork = TRUE) |>
      fs::path_expand()
  } else {
    ""
  }
}
