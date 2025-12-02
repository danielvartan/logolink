#' Find NetLogo installation directory
#'
#' @description
#'
#' `find_netlogo_home()` attempts to locate the installation directory of
#' NetLogo on the user's system.
#'
#' @details
#'
#' The function uses the following search order:
#'
#' 1. Checks the `NETLOGO_HOME` environment variable. If set and the directory
#'    exists, returns that path.
#' 2. If the environment variable is not set or the directory does not exist,
#'    searches through common installation paths for directories containing
#'    "NetLogo" (case-insensitive) in their name.
#'
#' If multiple NetLogo installations are found in the same directory, the
#' last one (alphabetically) is returned.
#'
#' @return A [`character`][base::character()] string specifying the path to the
#'   NetLogo installation directory. Returns an empty string (`""`) if no
#'   installation can be found.
#'
#' @family utility functions
#' @export
#'
#' @examples
#' \dontrun{
#'   find_netlogo_home()
#' }
find_netlogo_home <- function() {
  netlogo_home <- Sys.getenv("NETLOGO_HOME")

  if ((!netlogo_home == "") && dir.exists(netlogo_home)) {
    normalizePath(netlogo_home)
  } else {
    common_paths <- c(
      "~/",
      "~/.opt/",
      "/opt/",
      "/Applications",
      "C:/Program Files",
      "C:/Program Files (x86)"
    ) |>
      normalizePath(mustWork = FALSE)

    out <- ""

    for (i in common_paths) {
      netlogo_dir <-
        i |>
        list.dirs(full.names = FALSE, recursive = FALSE) |>
        basename() |>
        stringr::str_subset("(?i)NetLogo") |>
        dplyr::last()

      possible_path <- fs::path(i, netlogo_dir)

      if (length(possible_path) > 0) {
        if (dir.exists(possible_path)) {
          out <- possible_path
        }
      }
    }

    fs::path_expand(out)
  }
}
