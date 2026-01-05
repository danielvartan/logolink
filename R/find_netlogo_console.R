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
#'    constructs the path based on the output of
#'    [`find_netlogo_home()`][find_netlogo_home()] (e.g.,
#'    `<NETLOGO_HOME>/NetLogo_Console` on Linux/macOS or
#'    `<NETLOGO_HOME>/NetLogo_Console.exe` on Windows).
#'
#' @return A [`character`][base::character()] string specifying the path to the
#'   NetLogo executable file. Returns an empty string (`""`) if the executable
#'   cannot be found at any location.
#'
#' @family system functions
#' @export
#'
#' @examples
#' \dontrun{
#'   find_netlogo_console()
#' }
find_netlogo_console <- function() {
  netlogo_console <- Sys.getenv("NETLOGO_CONSOLE")

  if (netlogo_console != "" && file.exists(netlogo_console)) {
    netlogo_console |>
      normalizePath() |>
      path_expand()
  } else {
    netlogo_home <- find_netlogo_home()

    system_name <-
      sys_info() |> # Sys.info() mock
      magrittr::extract("sysname") |>
      unname() |>
      tolower()

    if (system_name == "windows") {
      out <- netlogo_home |> path("NetLogo_Console.exe")
    } else {
      out <- netlogo_home |> path("NetLogo_Console")
    }

    if (file.exists(out)) {
      out |>
        normalizePath() |>
        path_expand()
    } else {
      ""
    }
  }
}
