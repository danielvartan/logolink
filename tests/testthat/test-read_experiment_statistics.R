testthat::test_that("`read_experiment_statistics()` | General test", {
  test_file <- tempfile(fileext = ".csv")

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Stats version 2.0"',
    paste0(
      '"/home/danielvartan/.opt/netlogo-7-0-3/',
      'models/IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
    ),
    '"Wolf Sheep Simple Model Analysis"',
    '"01/05/2026 08:27:36:594 -0300"',
    '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
    '"-17","17","-17","17"',
    paste0(
      '"number-of-sheep","number-of-wolves","movement-cost",',
      '"grass-regrowth-rate","energy-gain-from-grass",',
      '"energy-gain-from-sheep","[step]","(mean) count wolves",',
      '"(std) count wolves","(mean) count sheep","(std) count sheep"'
    ),
    '"500","5","0.5","0.3","2","5","0","5","0","500","0"',
    '"500","5","0.5","0.3","2","5","1","5","0","497.9","1.1357816691600549"',
    '"500","5","0.5","0.3","2","5","2","5","0","496","1.5491933384829668"',
    '"500","5","0.5","0.3","2","5","3","5","0","494.6","1.685229954635272"',
    '"500","5","0.5","0.3","2","5","4","5","0","492.7","2.2825424421026654"',
    '"500","5","0.5","0.3","2","5","5","5","0","491.9","2.4677925358506134"',
    '"500","5","0.5","0.3","2","5","6","5","0","490","3.03315017762062"',
    '"500","5","0.5","0.3","2","5","7","5","0","488.4","3.52703841770968"'
  ) |>
    readr::write_lines(test_file)

  read_experiment_statistics(
    file = test_file
  ) |>
    checkmate::expect_tibble(nrows = 8, ncols = 11)
})

testthat::test_that("`read_experiment_statistics()` | Message test", {
  test_file <- tempfile(fileext = ".csv")

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Stats version 2.0"',
    paste0(
      '"/home/danielvartan/.opt/netlogo-7-0-3/',
      'models/IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
    ),
    '"Wolf Sheep Simple Model Analysis"',
    '"01/05/2026 08:27:36:594 -0300"',
    '"min-pxcor","max-pxcor","min-pycor","max-pycor"',
    '"-17","17","-17","17"',
    paste0(
      '"number-of-sheep","number-of-wolves","movement-cost",',
      '"grass-regrowth-rate","energy-gain-from-grass",',
      '"energy-gain-from-sheep","[step]","(mean) count wolves",',
      '"(std) count wolves","(mean) count sheep","(std) count sheep"'
    )
  ) |>
    readr::write_lines(test_file)

  # if (nrow(out) == 0) {

  read_experiment_statistics(
    file = test_file
  ) |>
    testthat::expect_message()
})

testthat::test_that("`read_experiment_statistics()` | Error test", {
  # checkmate::assert_string(file)

  read_experiment_statistics(
    file = 1,
  ) |>
    testthat::expect_error()

  # checkmate::assert_file_exists(file, extension = "csv")

  test_file <- tempfile(fileext = ".txt")
  test_file |> file.create()

  read_experiment_statistics(
    file = tempfile()
  ) |>
    testthat::expect_error()

  read_experiment_statistics(
    file = test_file,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()
})
