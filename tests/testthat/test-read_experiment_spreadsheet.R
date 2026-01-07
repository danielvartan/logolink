testthat::test_that("`read_experiment_spreadsheet()` | General test", {
  test_file <- tempfile()

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Spreadsheet version 2.0"',
    paste0(
      '"/opt/NetLogo 7-0-3/models/',
      'IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
    ),
    '"Wolf Sheep Simple Model Analysis"',
    '"01/05/2026 09:00:05:327 -0300"',
    '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
    '"-17","17","-17","17"',
    '"[run number]","1","1","1"',
    '"number-of-sheep","500",,',
    '"number-of-wolves","5",,',
    '"movement-cost","0.5",,',
    '"grass-regrowth-rate","0.3",,',
    '"energy-gain-from-grass","2",,',
    '"energy-gain-from-sheep","5",,',
    '"[reporter]","[step]","count wolves","count sheep"',
    '"[final]","1000","14","111"',
    '"[min]","0","5","79"',
    '"[max]","1000","17","500"',
    '"[mean]","500","14.07092907092907","198.1978021978022"',
    '"[total steps]","1000","1000","1000"',
    '',
    '"[all run data]","[step]","count wolves","count sheep"',
    ',"0","5","500"',
    ',"1","5","496"',
    ',"2","5","494"',
    ',"3","5","493"',
    ',"4","5","492"',
    ',"5","5","492"'
  ) |>
    readr::write_lines(test_file)

  read_experiment_spreadsheet(
    file = test_file,
    tidy_output = TRUE
  ) |>
    checkmate::expect_list(len = 2)

  read_experiment_spreadsheet(
    file = test_file,
    tidy_output = FALSE
  ) |>
    checkmate::expect_list(len = 2)
})

testthat::test_that("`read_experiment_spreadsheet()` | Message test", {
  test_file <- tempfile()

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Spreadsheet version 2.0"',
    paste0(
      '"/opt/NetLogo 7-0-3/models/',
      'IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
    ),
    '"Wolf Sheep Simple Model Analysis"',
    '"01/05/2026 09:00:05:327 -0300"',
    '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
    '"-17","17","-17","17"',
    '"[run number]","1","1","1"',
    '"number-of-sheep","500",,',
    '"number-of-wolves","5",,',
    '"movement-cost","0.5",,',
    '"grass-regrowth-rate","0.3",,',
    '"energy-gain-from-grass","2",,',
    '"energy-gain-from-sheep","5",,',
    '"[reporter]","[step]","count wolves","count sheep"',
    '"[final]","1000","14","111"',
    '"[min]","0","5","79"',
    '"[max]","1000","17","500"',
    '"[mean]","500","14.07092907092907","198.1978021978022"',
    '"[total steps]","1000","1000","1000"',
    '',
    '"[all run data]","[step]","count wolves","count sheep"'
  ) |>
    readr::write_lines(test_file)

  # if (nrow(out) == 0) {

  read_experiment_spreadsheet(
    file = test_file,
    tidy_output = TRUE
  ) |>
    testthat::expect_message()
})

testthat::test_that("`read_experiment_spreadsheet()` | Error test", {
  # checkmate::assert_string(file)

  read_experiment_spreadsheet(
    file = 1
  ) |>
    testthat::expect_error()

  # checkmate::assert_file_exists()

  read_experiment_spreadsheet(
    file = tempfile()
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(tidy_output)

  test_file <- tempfile()
  test_file |> file.create()

  read_experiment_spreadsheet(
    file = test_file,
    tidy_output = 1
  ) |>
    testthat::expect_error()

  # checkmate::assert_tibble(data)

  read_experiment_spreadsheet.tidy_statistics(
    data = 1
  ) |>
    testthat::expect_error()

  # checkmate::assert_tibble(data)

  read_experiment_spreadsheet.tidy_data(
    data = 1
  ) |>
    testthat::expect_error()
})
