read_experiment_metadata <- function(file) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file)

  assert_behaviorspace_file(file)
  assert_behaviorspace_file_output(file)

  file_header <-
    file |>
    readr::read_lines(
      n_max = 6,
      skip_empty_rows = TRUE
    ) |>
    stringr::str_remove_all('\"')

  time_zone <-
    file_header |>
    magrittr::extract2(4) |>
    stringr::str_extract(".\\d{4}$") |>
    stringr::str_sub(1, 3) |>
    as.integer() |>
    magrittr::multiply_by(-1) %>%
    (\(x) ifelse(x >= 0, paste0("+", x), paste0("-", x)))() |>
    paste0("Etc/GMT", x = _)

  timestamp <-
    file_header |>
    magrittr::extract2(4) |>
    stringr::str_replace(":(\\d{3}) ", ".\\1 ") |>
    strptime(format = "%m/%d/%Y %H:%M:%OS %z") |>
    as.POSIXct(tz = time_zone)

  netlogo_version <-
    file_header |>
    magrittr::extract2(1) |>
    stringr::str_extract("(?<=NetLogo )\\d+\\.\\d+(\\.\\d+)?")

  output_version <-
    file_header |>
    magrittr::extract2(1) |>
    stringr::str_extract("\\d+\\.\\d+(\\.\\d+)?$")

  model_file <-
    file_header |>
    magrittr::extract2(2) |>
    basename()

  experiment_name <-
    file_header |>
    magrittr::extract2(3)

  world_dimensions <-
    file_header |>
    magrittr::extract2(6) |>
    stringr::str_split(",") |>
    unlist() |>
    as.integer() |>
    magrittr::set_names(
      c("min-pxcor", "max-pxcor", "min-pycor", "max-pycor")
    )

  list(
    timestamp = timestamp,
    netlogo_version = netlogo_version,
    output_version = output_version,
    model_file = model_file,
    experiment_name = experiment_name,
    world_dimensions = world_dimensions
  )
}
