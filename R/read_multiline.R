#' Read multiline FWF files
#' 
#' @param file
#' @param lines
#' @param col_positions
#' @param col_types
#' @param skip
#' @param ...
#' @return ...
#' @seealso ...
#' @import readr
#' @export
#' @examples
#' NULL
read_multiline = function(file, lines, col_positions, col_types = NULL, skip
  = 0) {
  assert_that(is.count(lines))
  assert_that(is.scalar(skip))
  assert_that(is.list(col_positions))
  assert_that(length(col_positions) == lines)
  ds_lines <- read_lines(file, skip)
  split_ds <- split_lines(ds = ds_lines, lines = lines, positions =
    col_positions, types = col_types)
  join_lines(split_ds)
}

read_lines <- function(file, skip) {
  ds = readr::datasource(file, skip = skip)
  readr::read_lines(ds, skip = skip)
}

split_lines <- function(ds, lines, positions, types) {
  index = index_lines(ds, lines)
  split_ds = lapply(seq.int(lines), read_subset, ds = ds, positions = positions,
    types = types, index = index)
  assert_that(is_even_split(split_ds))
  split_ds
}

read_subset <- function(i, ds, positions, types, index) {
  r_lines = paste0(ds[index == i], collapse = "\n")
  readr::read_fwf(r_lines, positions[[i]], types[[i]])
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
