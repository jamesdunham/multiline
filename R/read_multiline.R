#' Read multiline FWF files
#' 
#' @inheritParams readr::read_fwf
#' @param ... Further arguments, passed to \code{\link[readr]{read_lines()}}.
#' @return A data.frame.
#' @import readr
#' @export
#' @examples
#' NULL
read_multiline = function(file, lines, col_positions, col_types = NULL, skip
  = 0, ...) {
  assert_that(is.count(lines))
  assert_that(is.scalar(skip))
  assert_that(is.list(col_positions))
  assert_that(length(col_positions) == lines)
  line_vector <- read_lines(file, skip)
  split_ds <- split_lines(line_vector = line_vector, lines = lines, positions =
    col_positions, types = col_types)
  join_lines(split_ds)
}

read_lines <- function(file, skip, ...) {
  # Read lines from file
  ds = readr::datasource(file, skip = skip)
  readr::read_lines(ds, ...)
}

split_lines <- function(line_vector, lines, positions, types) {
  index = index_lines(line_vector, lines)
  split_ds = lapply(seq.int(lines), read_subset, line_vector = line_vector,
    positions = positions,
    types = types, index = index)
  assert_that(is_even_split(split_ds))
  split_ds
}

read_subset <- function(i, line_vector, positions, types, index) {
  line_subset = paste0(line_vector[index == i], collapse = "\n")
  if (is.null(types)) {
    types_i = NULL
  } else {
    types_i = types[[i]]
  }
  readr::read_fwf(line_subset, positions[[i]], types_i)
}

join_lines <- function(split_ds) {
  # TODO: checks
  dplyr::bind_cols(split_ds)
}

index_lines = function(ds_lines, lines) {
  assert_that(is.character(ds_lines))
  assert_that(is.count(lines))

  ds_len = length(ds_lines)
  assert_that(is_min_length(ds_len, lines))
  assert_that(length_is_row_multiple(ds_len, lines))

  row_seq = seq.int(1, lines)
  row_index = rep_len(row_seq, ds_len)
  return(row_index)
}
