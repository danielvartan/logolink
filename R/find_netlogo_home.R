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
#' @family system functions
#' @export
#'
#' @examples
#' \dontrun{
#'   find_netlogo_home()
#' }
find_netlogo_home <- function() {
  netlogo_home <- Sys.getenv("NETLOGO_HOME")

  if ((netlogo_home != "") && dir.exists(netlogo_home)) {
    netlogo_home |>
      normalizePath() |>
      path_expand()
  } else {
    common_paths <- list(
      windows = c(
        "~/",
        "C:/Program Files",
        "C:/Program Files (x86)"
      ),
      macos = c(
        "~/",
        "/Applications/"
      ),
      linux = c(
        "~/",
        "~/.opt/",
        "~/Applications/",
        "/opt/"
      )
    ) |>
      purrr::map(fs::path_expand) |>
      purrr::map(normalizePath, mustWork = FALSE)

    system_name <-
      sys_info() |> # Sys.info() mock
      magrittr::extract("sysname") |>
      unname() |>
      tolower()

    if (system_name == "windows") {
      paths_to_search <- common_paths |> magrittr::extract2("windows")
    } else if (system_name %in% c("darwin", "macos")) {
      paths_to_search <- common_paths |> magrittr::extract2("macos")
    } else if (system_name == "linux") {
      paths_to_search <- common_paths |> magrittr::extract2("linux")
    } else {
      paths_to_search <-
        common_paths |>
        unlist() |>
        unname()
    }

    out <- ""

    for (i in paths_to_search) {
      netlogo_dir <-
        i |>
        list.dirs(full.names = FALSE, recursive = FALSE) |>
        basename() |>
        stringr::str_subset("(?i)NetLogo") |>
        dplyr::last()

      possible_path <- path(i, netlogo_dir)

      if (length(possible_path) > 0) {
        if (dir.exists(possible_path)) {
          out <-
            possible_path |>
            normalizePath() |>
            path_expand()
        }
      }
    }

    out
  }
}
