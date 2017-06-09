Introduction
------------

multiline is an R package for reading data from multiline fixed-width-formatted (FWF) files. This format is like that of typical FWF files, except that data for a given observation wraps after some number of columns to span a fixed number of rows.

Digitized punch card data are often found in multiline FWF format. If data for each observation exceeded the horizontal space on a card (conventionally 80 columns), additional decks of cards were used. When digitized, their rows were were often interleaved so that data for each observation would appear in consecutive rows, one for each card.

Installation
------------

Install from GitHub with devtools:

``` r
if (!require(devtools, quietly = TRUE)) install.packages("devtools")
devtools::install_github("jamesdunham/multiline")
```

Background
----------

Consider the following multiline FWF (MFWF) data. As with FWF data, parsing requires the column positions of each field (ie, variable). But furthermore, we need the line position of each field.

    123456789
    789      
    987654321
    987      

Parsing requires:

-   The column positions of each field, as with FWF data;
-   The number of lines per observation; and
-   The line position of each field.

Suppose there are 2 lines per observation in the data; `field1` occupies columns 1-4 of line 1; `field2` columns 5-9 of line 1; and `field3` columns 1-3 of line 2.

    123456789  [line 1, obs. 1]
    789        [line 2, obs. 1]
    987654321  [line 1, obs. 2]
    987        [line 2, obs. 2]

The purpose of multiline is reading this data into a tidy table:

    obs field 1  field 2  field 3
      1    1234    56789      789
      2    9876    54321      987

Usage
-----

Specify the column and line positions of each field in a table or list of tables. multiline imports the [`fwf_` functions](http://readr.tidyverse.org/reference/read_fwf.html) from [`readr`](http://readr.tidyverse.org/index.html) to help with this task.

<!--
TODO: package example data
https://www.ropercenter.cornell.edu/CFIDE/cf/action/catalog/abstract.cfm?type=&start=&id=&archno=USRCOM1940-012&abstract=
-->
As a list:

``` r
positions <- list(
  fwf_positions(start = c(1, 5), end = c(4, 9), col_names = c('field1', 'field2')),
  fwf_positions(start = 1, end = 3, col_names = 'field3'))
positions
#> [[1]]
#> # A tibble: 2 x 3
#>   begin   end col_names
#>   <dbl> <dbl>     <chr>
#> 1     0     4    field1
#> 2     4     9    field2
#> 
#> [[2]]
#> # A tibble: 1 x 3
#>   begin   end col_names
#>   <dbl> <dbl>     <chr>
#> 1     0     3    field3
```

The line position of each field is implicit in the list order. Here, `field1` and `field2` are in line 1 and `field2` is in line 2.

<!-- Alternatively, as a table:


```r
# TODO: not yet implemented
# positions <- bind_positions(
#   fwf_positions(start = c(1, 5), end = c(4, 9), col_names = c('field1', 'field2')),
#   fwf_positions(start = 1, end = 3, col_names = 'field3'))
# positions
#
# Basically this:
# library(dplyr)
# positions = list(
#     fwf_positions(start = 1, end = 9, col_names = 'field1'),
#     fwf_positions(start = 1, end = 3, col_names = 'field2')) %>%
#   bind_rows(.id = 'line') # %>%
#   mutate(line = as.integer(line))
```

The table should give `start` and `end` column positions, `line` positions, and
the name of each field in `col_names`. -->
Given the data:

``` r
d <- "123456789\n789\n987654321\n9871"
d
#> [1] "123456789\n789\n987654321\n9871"
```

`read_multiline()` returns a tidy table with observations in rows and fields in columns. Note that `read_multiline()` requires that the number of items in the list of positions exactly match the number of lines in the MFWF.

``` r
tidy <- read_multiline(d, lines = 2, positions)
tidy
#> # A tibble: 2 x 3
#>   field1 field2 field3
#>    <int>  <int>  <int>
#> 1   1234  56789    789
#> 2   9876  54321    987
```
