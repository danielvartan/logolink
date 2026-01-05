read_experiment_metadata <- function(
  file,
  output_version = FALSE
) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file, extension = "csv")
  checkmate::assert_flag(output_version)

  metadata <-
    file |>
    readr::read_lines(n_max = 6) |>
    stringr::str_remove_all('\"')

  time_zone <-
    metadata |>
    magrittr::extract2(4) |>
    stringr::str_extract(".\\d{4}$") |>
    stringr::str_sub(1, 3) |>
    as.integer() |>
    magrittr::multiply_by(-1) %>%
    (\(x) ifelse(x >= 0, paste0("+", x), paste0("-", x)))() |>
    paste0("Etc/GMT", x = _)

  timestamp <-
    metadata |>
    magrittr::extract2(4) |>
    stringr::str_replace(":(\\d{3}) ", ".\\1 ") |>
    strptime(format = "%m/%d/%Y %H:%M:%OS %z") |>
    as.POSIXct(tz = time_zone)

  netlogo_version <-
    metadata |>
    magrittr::extract2(1) |>
    stringr::str_extract("(?<=NetLogo )\\d+\\.\\d+(\\.\\d+)?")

  model_file <-
    metadata |>
    magrittr::extract2(2) |>
    basename()

  experiment_name <-
    metadata |>
    magrittr::extract2(3)

  world_dimensions <-
    metadata |>
    magrittr::extract2(6) |>
    stringr::str_split(",") |>
    unlist() |>
    as.integer() |>
    magrittr::set_names(
      c("min-pxcor", "max-pxcor", "min-pycor", "max-pycor")
    )

  out <- list(
    timestamp = timestamp,
    netlogo_version = netlogo_version,
    model_file = model_file,
    experiment_name = experiment_name,
    world_dimensions = world_dimensions
  )

  if (isTRUE(output_version)) {
    output_version <-
      metadata |>
      magrittr::extract2(1) |>
      stringr::str_extract("\\d+\\.\\d+(\\.\\d+)?$")

    out <-
      out |>
      append(
        values = list(output_version = output_version),
        after = 2
      )
  }

  out
}
