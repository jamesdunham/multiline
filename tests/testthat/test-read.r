library(testthat)

test_data = c("12\n34\n12\n34\n")
test_pos = readr::fwf_positions(
  start = c(1, 2),
  end = c(1, 2),
  col_names = letters[1:2])

test_that("read_fwf and read_multiline give the same output when rows=1", {
  readr_res = readr::read_fwf(test_data, test_pos)
  multiline_res = read_multiline(test_data, lines = 1, list(test_pos))
  expect_equal(readr_res$a, rep(c(1, 3), 2))
  expect_equal(readr_res$b, rep(c(2, 4), 2))
  expect_equal(readr_res, multiline_res)
})

test_that("read_multiline concatenates row pairs when rows=2", {
  test_pos = list(test_pos, test_pos)
  test_pos[[2]]$col_names = c("c", "d")
  res = read_multiline(test_data, lines = 2, test_pos)
  expect_equal(dim(res), c(2, 4))
  expect_equal(res[1, ], res[2, ])
  expect_equal(names(res), letters[1:4])
})

test_that("read_multiline stops on missing positions", {
  expect_error(read_multiline(test_data, lines = 2, test_pos),
    "length\\(col_positions\\) not equal to lines")
})

test_that("column width can vary over lines", {
  test_data = c("12\n34\n12\n34")
  test_pos = list(
    readr::fwf_positions(
      start = 1:2,
      end = 1:2,
      col_names = letters[1:2]),
    readr::fwf_positions(
      start = 1,
      end = 2,
      col_names = "c")
  )
  res = read_multiline(test_data, lines = 2, test_pos)
  expect_equal(res$a, c(1, 1))
  expect_equal(res$b, c(2, 2))
  expect_equal(res$c, c(34, 34))
})


