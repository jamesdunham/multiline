assert_that <- assertthat::assert_that
is.count <- assertthat::is.count
is.scalar <- assertthat::is.scalar
is.string <- assertthat::is.string
on_failure <- assertthat::on_failure

is_even_split <- function(split_ds) {
  n_records = unique(vapply(split_ds, nrow, integer(1)))
  length(n_records) == 1
}

on_failure(is_even_split) <- function(call, env) {
  paste("could not split the datasource evenly; please report this bug")
}

length_is_row_multiple <- function(ds_len, rows) {
  ds_len %% rows == 0
}

on_failure(length_is_row_multiple) <- function(call, env) {
  paste("the datasource's line count is not a multiple of the 'lines' argument")
}

is_min_length <- function(ds_len, rows) {
  ds_len >= rows 
}

on_failure(is_min_length) <- function(call, env) {
  stop("there are fewer lines in the datasource than implied by the 'lines' argument")
}

# # move this to col_positions_valid and col_types_valid:
#   if (rows > 1) {
#     stopifnot(length(col_positions) == rows)
#     if (!is.null(col_types)) {
#       stopifnot(length(col_types) == rows)
#     }
#   } else {
#     col_positions = list(col_positions)
#     col_types = list(col_types)
#   }
#
