multiline
=========

multiline is an R package for reading data from multiline fixed-width-formatted (FWF) files. This format is like that of typical FWF files, except that data for a given observation wraps after some number of columns.

Background
----------

Consider the following multiline FWF (MFWF) data. As with FWF data, parsing requires the column positions of each field. But furthermore, we need the line position of each field.

    123456789
    789
    123456789
    789

If `field1` appears in columns 1-9 of line 1 and `field2` is in columns 1-3 of line 2, then the data give two observations with identical values for each field.

Thus another way to see MFWF data is as a "long" table (i.e., with observations spanning rows) whose unique identifiers are implicit. The updated example below shows these observation identifiers in parentheses.

    123456789  (1)
    789        (1)
    123456789  (2)
    789        (2)

Because line numbers in MFWF data are inferred (just as column numbers in FWF data), lines must appear whether or not they contain data. The updated example below shows how the data would look if `field2` were missing for observation 1. The parentheses give line numbers.

    123456789  (1)
               (2)
    123456789  (1)
    789        (2)

Usage
-----

We can represent MFWF field positions in a list that contains for each line a table with its fields' names and start and end positions. The `fwf_positions` function from `readr` makes this makes this easy. For example, if `field1` is in line 1, columns 1-9, and `field2` is in line 2, columns 1-3, then:

``` r
positions = list(
  readr::fwf_positions(start = 1, end = 9, col_names = 'field1'),
  readr::fwf_positions(start = 1, end = 3, col_names = 'field2'))
positions
#> [[1]]
#> # A tibble: 1 × 3
#>   begin   end col_names
#>   <dbl> <dbl>     <chr>
#> 1     0     9    field1
#> 
#> [[2]]
#> # A tibble: 1 × 3
#>   begin   end col_names
#>   <dbl> <dbl>     <chr>
#> 1     0     3    field2
```

Given the data:

``` r
d <- "123456789\n789\n123456789\n789"
```

`read_multiline()` returns a tidy table with observations in rows and fields in columns.

``` r
tidy <- read_multiline(d, lines=2, positions)
tidy
#> # A tibble: 2 × 2
#>      field1 field2
#>       <int>  <int>
#> 1 123456789    789
#> 2 123456789    789
```

Installation
------------

Install from GitHub with devtools:

``` r
# install.packages("devtools")
devtools::install_github("jamesdunham/multiline")
```