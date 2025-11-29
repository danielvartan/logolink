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

find_netlogo_executable <- function(
  netlogo_home = find_netlogo_home(),
  remove_exe_ext = TRUE
) {
  checkmate::assert_string(netlogo_home)
  checkmate::assert_flag(remove_exe_ext)

  netlogo_home <- fs::path_expand(netlogo_home)

  out <- ""

  if (!Sys.getenv("NETLOGO_EXE") == "") {
    out <-
      Sys.getenv("NETLOGO_EXE") |>
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

find_netlogo_version <- function(
  netlogo_home = find_netlogo_home()
) {
  checkmate::assert_string(netlogo_home)

  netlogo_home <- fs::path_expand(netlogo_home)
  executable_path <- find_netlogo_executable(netlogo_home)

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
