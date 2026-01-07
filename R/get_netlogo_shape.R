#' Download NetLogo shapes from LogoShapes
#'
#' @description
#'
#' `get_netlogo_shape()` downloads NetLogo shapes from the
#' [LogoShapes](https://github.com/danielvartan/logoshapes) project on GitHub.
#'
#' The collections and shapes available for download can be found in the
#' [LogoShapes](https://github.com/danielvartan/logoshapes) project
#' [`svg`](https://github.com/danielvartan/logoshapes/tree/main/svg)
#' directory. Refer to the
#' [LogoShapes](https://github.com/danielvartan/logoshapes) documentation for
#' more information about the different collections.
#'
#' **Note**: This function requires an active internet connection and the
#' [`httr2`](https://httr2.r-lib.org/) package.
#'
#' @param shape A [`character`][base::character()] vector indicating the names
#'   of the shapes to download.
#' @param collection (optional) A [`character`][base::character()] string
#'   indicating the collection of shapes to download from
#'   (default: `"netlogo-refined"`).
#' @param dir (optional) A [`character`][base::character()] string indicating
#'   the directory where the shapes will be saved (default: `tempdir()`).
#' @param user_agent (optional) A [`character`][base::character()] string
#'   indicating the user agent to use for the GitHub API requests.
#'   (default: `"logolink <https://CRAN.R-project.org/package=logolink>"`).
#' @param auth_token (optional) A [`character`][base::character()] string
#'   indicating a GitHub Personal Access Token (PAT) for authentication
#'   with the GitHub API. This is useful when dealing with rate limits.
#'   (default: `Sys.getenv("GITHUB_PAT")`).
#'
#' @return A named [`character`][base::character()] vector with the file paths
#'   to the downloaded NetLogo shapes as
#' [SVG](https://en.wikipedia.org/wiki/SVG) files.
#'
#' @family utility functions
#' @export
#'
#' @examples
#' \dontrun{
#'   library(fs)
#'   library(magick)
#' }
#'
#' \dontrun{
#'   shape <- get_netlogo_shape("turtle")
#'
#'   file_size(shape)
#'
#'   shape |> image_read_svg() |> image_ggplot()
#' }
#'
#' \dontrun{
#'   shape <- get_netlogo_shape("turtle", collection = "netlogo-simplified")
#'
#'   file_size(shape)
#'
#'   shape |> image_read_svg() |> image_ggplot()
#' }
#'
#' \dontrun{
#'   shape <- get_netlogo_shape("turtle", collection = "netlogo-7-0-3")
#'
#'   file_size(shape)
#'
#'   shape |> image_read_svg() |> image_ggplot()
#' }
get_netlogo_shape <- function(
  shape,
  collection = "netlogo-refined",
  dir = tempdir(),
  user_agent = "logolink <https://CRAN.R-project.org/package=logolink>",
  auth_token = Sys.getenv("GH_TOKEN")
) {
  require_package("httr2")

  assert_internet()
  checkmate::assert_character(shape, min.len = 1)
  checkmate::assert_string(collection)
  checkmate::assert_directory_exists(dir)
  checkmate::assert_string(user_agent)
  checkmate::assert_string(auth_token)

  api_response <-
    httr2::request("https://api.github.com") |>
    httr2::req_url_path_append("repos") |>
    httr2::req_url_path_append("danielvartan") |>
    httr2::req_url_path_append("logoshapes") |>
    httr2::req_url_path_append("contents") |>
    httr2::req_url_path_append("svg") |>
    httr2::req_user_agent(user_agent)

  if (auth_token != "") {
    api_response <-
      api_response |>
      httr2::req_auth_bearer_token(auth_token)
  }

  collection_choices <-
    api_response |>
    req_perform() |>
    resp_body_json() |>
    purrr::map_chr("name")

  checkmate::assert_choice(collection, collection_choices)

  shape_response <-
    api_response |>
    httr2::req_url_path_append(collection) |>
    req_perform() |>
    resp_body_json()

  shape_choices <-
    shape_response |>
    purrr::map_chr("name") |>
    stringr::str_subset("^\\.", negate = TRUE) |>
    stringr::str_remove("\\.svg$")

  checkmate::assert_subset(shape, shape_choices)

  cli::cli_progress_bar(
    "Downloading NetLogo shapes",
    total = length(shape)
  )

  out <- character()

  for (i in shape) {
    i_url <-
      shape_response |>
      purrr::keep(\(x) x$name == paste0(i, ".svg")) |>
      purrr::pluck(1, "download_url")

    i_content <-
      httr2::request(i_url) |>
      req_perform() |>
      resp_body_string()

    i_file <-
      dir |>
      file.path(paste0(collection, "-", i, ".svg"))

    writeLines(i_content, i_file)

    out <- c(out, i_file |> magrittr::set_names(i))

    cli::cli_progress_update()
  }

  cli::cli_progress_done()

  out
}
