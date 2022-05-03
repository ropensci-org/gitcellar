
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gitcellar

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/ropensci-org/gitcellar/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci-org/gitcellar/actions)
<!-- badges: end -->

The goal of gitcellar is to help you download archives of all
repositories in an organization.

## Installation

You can install the development version of gitcellar from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("ropensci-org/gitcellar")
```

## Example

This is a basic example which shows you how to download archives of all
repositories in an organization:

``` r
library(gitcellar)
download_organization_repos(organization = "maelle-test")
```

The archives (.tar.gz) will be saved in distinct folders under the
current directory (or the directory you input via the argument
`dest_folder`). It might seem wasteful to create one archive per
repository as opposed to one archive of all repositories but in our
experience it prevents failures.
