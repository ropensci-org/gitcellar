
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gitcellar

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/ropensci-org/gitcellar/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci-org/gitcellar/actions)
<!-- badges: end -->

The goal of gitcellar is to help you download archives of all
repositories in an organization. For context see the blog post
[Safeguards and Backups for GitHub
Organizations](https://ropensci.org/blog/2022/03/22/safeguards-and-backups-for-github-organizations/).

## Installation

You can install the development version of gitcellar from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("ropensci-org/gitcellar")
```

## Example

This is a basic example which shows you how to download archives of all
repositories in an organization (of which you are an owner):

``` r
library(gitcellar)
download_organization_repos(organization = "maelle-test")
```

The archives (`<org-name>_<repo-name>_migration_archive.tar.gz`) will be
saved in distinct folders (`archive-<org-name>_<repo-name>`) under the
current directory (or the directory you input via the argument
`dest_folder` \<- DOES NOT WORK YET). It might seem wasteful to create
one archive per repository as opposed to one archive of all repositories
but in our experience it prevents failures. Then, the reason to store
one archive per *folder* is due to the fact that it worked better with
the tool we used for uploading the archive to a cloud service.

After this step, you can use the tool of your choice to upload the
backups to a cloud service like Digital Ocean, AWS, etc. You could run
the code once a week and keep 8 weeks of backups on a rolling basis.
