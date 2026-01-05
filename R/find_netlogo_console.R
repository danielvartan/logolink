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
#' @family system functions
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
  netlogo_console <- Sys.getenv("NETLOGO_CONSOLE")

  if (netlogo_console != "" && file.exists(netlogo_console)) {
    netlogo_console |>
      normalizePath() |>
      path_expand()
  } else {
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
