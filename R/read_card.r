#' Read multiline FWF data
#'
#'
#' @export
read_multiline = function(file, col_positions, rows = 1, col_types = NULL, skip = 0, ...) {

  assertthat::assert_that(assertthat::is.count(rows))
  assertthat::assert_that(assertthat::is.scalar(skip))

  if (rows > 1) {
    stopifnot(length(col_positions) == rows)
    if (!is.null(col_types)) {
      stopifnot(length(col_types) == rows)
    }
  } else {
    col_positions = list(col_positions)
    col_types = list(col_types)
  }

  ds = readr::datasource(file, skip = skip)
  ds_lines = readr::read_lines(ds, skip = skip) # , ...)
  line_index = index_lines(ds_lines, rows)

  split_ds = lapply(seq.int(rows), function(r, positions, types) {
    r_lines = ds_lines[line_index == r]
    r_lines = paste0(r_lines, collapse = "\n")
    readr::read_fwf(r_lines, positions[[r]], types[[r]]) # , ...)
  }, col_positions, col_types)

  n_records = unique(vapply(split_ds, nrow, integer(1)))
  if (length(n_records) > 1) {
    stop("splitting source by 'rows' argument leads to inconsistent number of records")
  }
  dplyr::bind_cols(split_ds)
}

index_lines = function(ds_lines, rows) {

  assertthat::assert_that(is.character(ds_lines))
  assertthat::assert_that(assertthat::is.count(rows))

  ds_len = length(ds_lines)
  if (ds_len < rows) {
    stop("found fewer rows in source than given in 'rows' argument")
  }
  if (ds_len %% rows != 0) {
    stop("rows in source are not a multiple of 'rows' argument")
  }

  row_seq = seq.int(1, rows)
  row_index = rep_len(row_seq, ds_len)
  return(row_index)
}
