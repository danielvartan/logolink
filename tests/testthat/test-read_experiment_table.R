testthat::test_that("`read_experiment_table()` | General test", {
  test_file <- tempfile(fileext = ".csv")

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Table version 2.0"',
    paste0(
      '"/home/danielvartan/.opt/netlogo-7-0-3/',
      'models/IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
    ),
    '"Wolf Sheep Simple Model Analysis"',
    '"01/05/2026 06:37:48:683 -0300"',
    '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
    '"-17","17","-17","17"',
    paste0(
      '"[run number]","number-of-sheep","number-of-wolves",',
      '"movement-cost","grass-regrowth-rate","energy-gain-from-grass",',
      '"energy-gain-from-sheep","[step]","count wolves","count sheep"'
    ),
    '"3","500","5","0.5","0.3","2","5","0","5","500"',
    '"5","500","5","0.5","0.3","2","5","0","5","500"',
    '"4","500","5","0.5","0.3","2","5","0","5","500"',
    '"6","500","5","0.5","0.3","2","5","0","5","500"',
    '"1","500","5","0.5","0.3","2","5","0","5","500"',
    '"8","500","5","0.5","0.3","2","5","0","5","500"',
    '"9","500","5","0.5","0.3","2","5","0","5","500"',
    '"2","500","5","0.5","0.3","2","5","0","5","500"'
  ) |>
    readr::write_lines(test_file)

  read_experiment_table(
    file = test_file
  ) |>
    checkmate::expect_tibble(nrows = 8, ncols = 10)

  read_experiment_table(
    file = test_file
  ) |>
    checkmate::expect_tibble(nrows = 8, ncols = 10)
})

testthat::test_that("`read_experiment_table()` | Message test", {
  test_file <- tempfile(fileext = ".csv")

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Table version 2.0"',
    paste0(
      '"/home/danielvartan/.opt/netlogo-7-0-3/',
      'models/IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
    ),
    '"Wolf Sheep Simple Model Analysis"',
    '"01/05/2026 06:37:48:683 -0300"',
    '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
    '"-17","17","-17","17"',
    paste0(
      '"[run number]","number-of-sheep","number-of-wolves",',
      '"movement-cost","grass-regrowth-rate","energy-gain-from-grass",',
      '"energy-gain-from-sheep","[step]","count wolves","count sheep"'
    )
  ) |>
    readr::write_lines(test_file)

  # if (nrow(out) == 0) {

  read_experiment_table(
    file = test_file
  ) |>
    testthat::expect_message()
})

testthat::test_that("`read_experiment_table()` | Error test", {
  # checkmate::assert_string(file)

  read_experiment_table(
    file = 1
  ) |>
    testthat::expect_error()

  # checkmate::assert_file_exists(file, extension = "csv")

  test_file <- tempfile(fileext = ".txt")
  test_file |> file.create()

  read_experiment_table(
    file = tempfile()
  ) |>
    testthat::expect_error()

  read_experiment_table(
    file = test_file
  ) |>
    testthat::expect_error()
})
