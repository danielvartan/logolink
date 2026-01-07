testthat::test_that("`read_experiment_metadata()` | General test", {
  test_file <- tempfile()

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Table version 2.0"',
    paste0(
      '"/opt/NetLogo 7-0-3/models/',
      'IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
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

  test_file |>
    read_experiment_metadata() |>
    checkmate::expect_list(len = 6)
})

testthat::test_that("`read_experiment_metadata()` | Error test", {
  # checkmate::assert_string(file)

  read_experiment_metadata(
    file = 1
  ) |>
    testthat::expect_error()

  # checkmate::assert_file_exists()

  read_experiment_metadata(
    file = tempfile()
  ) |>
    testthat::expect_error()
})
