#' Find NetLogo Executable File
#'
#' @description
#'
#' `find_netlogo_console()` attempts to locate the NetLogo executable file on
#' the user's system.
#'
#' It first checks the `NETLOGO_CONSOLE` environment variable. If this variable
#' is not set or the file does not exist, it constructs the path to the
#' executable based on the provided `netlogo_home` directory.
#'
#' @param remove_exe_ext (optional) A [`logical`][base::logical] flag indicating
#'   whether to remove the `.exe` extension from the returned path on Windows
#'   systems (default: `TRUE`).
#'
#' @return A [`character`][base::character] string specifying the path to the
#'   NetLogo executable file. If the file cannot be found, an empty string is
#'   returned.
#'
#' @template params-netlogo-home
#' @family utility functions
#' @export
#'
#' @examples
#' \dontrun{
#'   find_netlogo_console()
#' }
find_netlogo_console <- function(
  netlogo_home = find_netlogo_home(),
  remove_exe_ext = TRUE
) {
  checkmate::assert_string(netlogo_home)
  checkmate::assert_flag(remove_exe_ext)

  netlogo_home <- fs::path_expand(netlogo_home)

  out <- ""

  if (!Sys.getenv("NETLOGO_CONSOLE") == "") {
    out <-
      Sys.getenv("NETLOGO_CONSOLE") |>
      normalizePath(mustWork = FALSE)
  }

  if (!netlogo_home == "" && !file.exists(out)) {
    if (.Platform$OS.type == "windows") {
      out <- fs::path(netlogo_home, "NetLogo_Console.exe")
    } else if (Sys.info()["sysname"] == "Darwin") {
      out <- fs::path(netlogo_home, "NetLogo_Console")
    } else {
      out <- fs::path(netlogo_home, "NetLogo_Console")
    }
  }

  if (file.exists(out)) {
    if (
      isTRUE(remove_exe_ext) &&
        stringr::str_detect(out, "\\.exe$")
    ) {
      out <- stringr::str_remove(out, "\\.exe$")
    }

    out |>
      normalizePath(mustWork = FALSE) |>
      fs::path_expand()
  } else {
    ""
  }
}
