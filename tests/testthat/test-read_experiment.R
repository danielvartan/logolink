testthat::test_that("`read_experiment()` | Table test", {
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

  read_experiment(
    file = test_file,
    tidy_output = TRUE
  ) |>
    checkmate::expect_list(len = 2)

  read_experiment(
    file = test_file,
    tidy_output = FALSE
  ) |>
    checkmate::expect_list(len = 2)
})

testthat::test_that("`read_experiment()` | Spreadsheet test", {
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

  read_experiment(
    file = test_file,
    tidy_output = TRUE
  ) |>
    checkmate::expect_list(len = 2)

  read_experiment(
    file = test_file,
    tidy_output = FALSE
  ) |>
    checkmate::expect_list(len = 2)
})

testthat::test_that("`read_experiment()` | Lists test", {
  test_file <- tempfile()

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Lists version 2.0"',
    paste0(
      '"/opt/NetLogo 7-0-3/models/',
      'IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
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

  read_experiment(
    file = test_file,
    tidy_output = TRUE
  ) |>
    checkmate::expect_list(len = 2)

  read_experiment(
    file = test_file,
    tidy_output = FALSE
  ) |>
    checkmate::expect_list(len = 2)
})

testthat::test_that("`read_experiment()` | Statistics test", {
  test_file <- tempfile()

  c(
    'BehaviorSpace results (NetLogo 7.0.3), "Stats version 2.0"',
    paste0(
      '"/opt/NetLogo 7-0-3/models/',
      'IABM Textbook/chapter 4/Wolf Sheep Simple 5.nlogox"'
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

  read_experiment(
    file = test_file,
    tidy_output = FALSE
  ) |>
    checkmate::expect_list(len = 2)
})

testthat::test_that("`read_experiment()` | Error test", {
  # checkmate::assert_string(file)

  read_experiment(
    file = 1,
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_file_exists()

  read_experiment(
    file = tempfile(),
    tidy_output = TRUE
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(tidy_output)

  test_file <- tempfile()
  test_file |> file.create()

  read_experiment(
    file = test_file,
    tidy_output = 1
  ) |>
    testthat::expect_error()

  # } else {

  test_file <- tempfile()

  'BehaviorSpace results (NetLogo 7.0.3), "Raster version 2.0"' |>
    readr::write_lines(test_file)

  testthat::local_mocked_bindings(
    assert_behaviorspace_file = function(...) NULL,
    assert_behaviorspace_file_output = function(...) NULL,
    read_experiment_metadata = function(...) character()
  )

  read_experiment(
    file = test_file
  ) |>
    testthat::expect_error()
})
