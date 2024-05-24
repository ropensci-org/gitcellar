
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gitcellar

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/ropensci-org/gitcellar/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci-org/gitcellar/actions)
[![R-CMD-check](https://github.com/ropensci-org/gitcellar/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci-org/gitcellar/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of gitcellar is to help you download
[archives](https://docs.github.com/en/repositories/archiving-a-github-repository/backing-up-a-repository)
of all repositories in an organization. For context see the blog post
[Safeguards and Backups for GitHub
Organizations](https://ropensci.org/blog/2022/03/22/safeguards-and-backups-for-github-organizations/).

## Installation & setup

You can install the development version of gitcellar from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("ropensci-org/gitcellar")
```

You will need a GitHub Personal Access Token (PAT). See [gh docs on the
topic](https://gh.r-lib.org/articles/managing-personal-access-tokens.html).
You need to be an owner of the organisation you’re trying to back up.
[Scopes
needed](https://docs.github.com/en/migrations/using-ghe-migrator/exporting-migration-data-from-githubcom):
`repo` and `admin:org`.

## Example

This is a basic example which shows you how to download archives of all
repositories in an organization (of which you are an owner):

``` r
library(gitcellar)
download_organization_repos(organizations = "maelle-test")
```

The archives (`<org-name>_<repo-name>_migration_archive.tar.gz`) will be
saved in distinct folders (`archive-<org-name>_<repo-name>`) under the
current directory (or the directory you input via the argument
`dest_folder`). It might seem wasteful to create one archive per
repository as opposed to one archive of all repositories but in our
experience it prevents failures. Then, the reason to store one archive
per *folder* is due to the fact that it worked better with the tool we
used for uploading the archive to a cloud service.

After this step, you can use the tool of your choice to upload the
backups to a cloud service like Digital Ocean, AWS, etc. You could run
the code once a week and keep 8 weeks of backups on a rolling basis.

### Where is the code?

In the archive .tar.gz, you will find JSON files of metadata about the
organizations (members for instance) and repositories (issues, pull
requests) but also *bare git repositories*. A [bare git
repository](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/What-is-a-bare-git-repository)
is a git repository as it exists on a remote. All the code is in there
but you cannot see it **until you clone the bare git repository to
another folder** where you will be able to see the files because by
default the clone is not bare. Or you can use
[`gert::git_ls(<path-to-bare-repo>, ref = "<default-branch>")`](https://docs.ropensci.org/gert/reference/git_commit.html)
to list files tracked in the bare git repository.

You could think of the bare git repositories as a compressed version of
the code in the sense that it contains all the information, and that you
just need a few steps (cloning to another folder) to get to the actual
repository content (including all its git history).
