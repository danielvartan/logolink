#' Find NetLogo Installation Directory
#'
#' @description
#'
#' `find_netlogo_home()` attempts to locate the installation directory of
#' NetLogo on the user's system.
#'
#' It first checks the `NETLOGO_HOME` environment variable. If this variable is
#' not set or the directory does not exist, it searches through a list of common
#' installation paths for NetLogo.
#'
#' @return A [`character`][base::character] string specifying the path to the
#'   NetLogo installation directory. If the directory cannot be found,
#'   an empty string is returned.
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

      if (!length(possible_path) == 0) {
        if (dir.exists(possible_path)) {
          out <- possible_path
        }
      }
    }

    fs::path_expand(out)
  }
}
