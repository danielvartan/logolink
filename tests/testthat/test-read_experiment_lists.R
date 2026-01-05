testthat::test_that("`read_experiment_lists()` | General test", {
  test_file <- tempfile(fileext = ".csv")

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Lists version 2.0"',
    paste0(
      '"/home/danielvartan/.opt/netlogo-7-0-3/',
      'models/IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
    ),
    '"Wolf Sheep Simple Model Analysis"',
    '"01/05/2026 07:33:45:117 -0300"',
    '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
    '"-17","17","-17","17"',
    paste0(
      '"[reporter]","[run number]","number-of-sheep","number-of-wolves",',
      '"movement-cost","grass-regrowth-rate","energy-gain-from-grass",',
      '"energy-gain-from-sheep","[step]","[0]","[1]","[2]","[3]","[4]","[5]"'
    ),
    paste0(
      '"[xcor] of sheep","1","100","15","0.5","0.3","2","5","0",',
      '"17.449784867527043","16.926345533399427","-11.797250663319353",',
      '"-3.1896974182627513","3.3356833706769002","4.598718018380566",'
    )
  ) |>
    readr::write_lines(test_file)

  read_experiment_lists(
    file = test_file,
    tidy_output = TRUE
  ) |>
    checkmate::expect_tibble(nrows = 6, ncols = 10)

  read_experiment_lists(
    file = test_file,
    tidy_output = FALSE
  ) |>
    checkmate::expect_tibble(nrows = 1, ncols = 15)
})

testthat::test_that("`read_experiment_lists()` | Message test", {
  test_file <- tempfile(fileext = ".csv")

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Lists version 2.0"',
    paste0(
      '"/home/danielvartan/.opt/netlogo-7-0-3/',
      'models/IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
    ),
    '"Wolf Sheep Simple Model Analysis"',
    '"01/05/2026 07:33:45:117 -0300"',
    '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
    '"-17","17","-17","17"',
    paste0(
      '"[reporter]","[run number]","number-of-sheep","number-of-wolves",',
      '"movement-cost","grass-regrowth-rate","energy-gain-from-grass",',
      '"energy-gain-from-sheep","[step]","[0]","[1]","[2]","[3]","[4]","[5]"'
    )
  ) |>
    readr::write_lines(test_file)

  # if (nrow(out) == 0) {

  read_experiment_lists(
    file = test_file,
    tidy_output = TRUE
  ) |>
    testthat::expect_message()
})

testthat::test_that("`read_experiment_lists()` | Error test", {
  # checkmate::assert_string(file)

  read_experiment_lists(
    file = 1,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_file_exists(file, extension = "csv")

  test_file <- tempfile(fileext = ".txt")
  test_file |> file.create()

  read_experiment_lists(
    file = tempfile(),
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  read_experiment_lists(
    file = test_file,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(tidy_output)

  test_file <- tempfile(fileext = ".csv")
  test_file |> file.create()

  read_experiment_lists(
    file = test_file,
    tidy_output = 1
  ) |>
    testthat::expect_error()
})
