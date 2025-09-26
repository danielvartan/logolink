test_that("`parse_netlogo_list()` | General test", {
  '["a" "b" "c"]' |>
    parse_netlogo_list() |>
    expect_equal(list(c("a", "b", "c")))

  '[1 2 3]' |>
    parse_netlogo_list() |>
    expect_equal(list(c(1L, 2L, 3L)))

  '[1.1 2.1 3.1]' |>
    parse_netlogo_list() |>
    expect_equal(list(c(1.1, 2.1, 3.1)))

  '[true false true]' |>
    parse_netlogo_list() |>
    expect_equal(list(c(TRUE, FALSE, TRUE)))

  c('["a" "b" "c"]', '["d" "e" "f"]') |>
    parse_netlogo_list() |>
    expect_equal(list(c("a", "b", "c"), c("d", "e", "f")))

  c('[1 2 3]', '[4 5 6]') |>
    parse_netlogo_list() |>
    expect_equal(list(c(1L, 2L, 3L), c(4L, 5L, 6L)))

  c('[1.1 2.1 3.1]', '[4.1 5.1 6.1]') |>
    parse_netlogo_list() |>
    expect_equal(list(c(1.1, 2.1, 3.1), c(4.1, 5.1, 6.1)))

  c('[true false true]', '[false true false]') |>
    parse_netlogo_list() |>
    expect_equal(list(c(TRUE, FALSE, TRUE), c(FALSE, TRUE, FALSE)))

  "[NaN]" |>
    parse_netlogo_list() |>
    expect_equal(list(c("NaN")))
})

test_that("`parse_netlogo_list()` | Error test", {
  # checkmate::assert_atomic(x)

  list(a = 1, b = 2) |>
    parse_netlogo_list() |>
    expect_error()
})
