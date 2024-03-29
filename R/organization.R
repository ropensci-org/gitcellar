#' Download archives of GitHub repositories within an account
#'
#' @param organizations Account username(s) (vector)
#' @param extra_repos Named vector of extra repository names where names are account names.
#' @param keep a character vector of repository names to explicitly archive and download.
#' If this vector is length zero, all account repositories are archived and downloaded.
#' @param dest_folder Where to save the folders with the archives.
#'
#' @details
#'
#' You will need a [GitHub Personal Access Token](https://usethis.r-lib.org/articles/git-credentials.html).
#'
#' If `organizations` is a personal account username, the PAT needs to be from that account.
#'
#' As long as you're an owner of the organisation you're trying to back up, absolutely no permissions are required for your PAT.
#' You will only need to add the `repos` scope if you wish to automatically include private repositories in the list of repos to back up.
#' Note however that there is a workaround using the `extra_repos` argument, as documented below.
#'
#' The reason why you might need `extra_repos` is if you want to download archives
#' of private repositories, while using a GitHub Personal Access Token with no scope.
#'
#' [GitHub documentation on archives](https://docs.github.com/en/repositories/archiving-a-github-repository/backing-up-a-repository).
#'
#' @export
#'
#' @examples
#' \dontrun{
#' download_organization_repos(c("maelle-test", "maelle-test"))
#' download_organization_repos("maelle-test", keep = "testy2") # only keep the testy2 repo
#' }
download_organization_repos <- function(organizations = NULL,
                                        extra_repos = NULL,
                                        keep = character(0),
                                        dest_folder = getwd()) {

  user_types <- check_users(organizations)

  if (!dir.exists(dest_folder)) dir.create(dest_folder)
  withr::local_dir(dest_folder)

  external_repos <- extra_repos[!names(extra_repos) %in% organizations]

  if (length(external_repos) > 0) {
    stop(
      "The following repos belong to accounts you haven't listed: ",
      toString(external_repos)
    )
  }

  repos <- purrr::map2(organizations, user_types, launch_org_migrations, keep = keep, extra_repos = extra_repos) |>
    unlist(recursive = FALSE)

  repo_names <- purrr::map_chr(repos, function(x) x$name)

  message("Waiting one minute for things to kick off properly before downloads...")
  Sys.sleep(60)

  start_time <- Sys.time()

  time_spent <- function(start_time) {
    ts <- difftime(Sys.time(), start_time, units = "mins")
    message(sprintf("Spent %s minutes", ts))
    ts
  }

  message(sprintf("%s archives to be saved.", length(repos)))

  while (length(repos) > 0 && time_spent(start_time = start_time) < 70) {
    Sys.sleep(600)
    status <- purrr::map_chr(repos, function(repo) repo$migration_state)
    ready_repos <- repos[status == "exported"]
    purrr::walk(ready_repos, function(repo) repo$launch_download())
    repos <- repos[status != "exported"]
    if (length(repos) > 0) message(sprintf("Still not saved: %s.", toString(purrr::map_chr(repos, ~.x[["name"]]))))
  }

  if (length(repos) > 0) {
    leftover <- toString(purrr::map_chr(repos, ~.x[["name"]]))
    message(sprintf("Left-over: %s.", leftover))
  } else {
    leftover <- NULL
  }

  tibble::tibble(
    repos = repo_names,
    exported = !(repo_names %in% leftover)
  )
}

launch_org_migrations <- function(username, user_type, extra_repos, keep = character(0)) {
  repo_names <- if (user_type == "organization") {
    gh::gh(
      "/orgs/{org}/repos",
      org = username,
      type = "all",
      per_page = 100,
      .limit = Inf
    ) |>
      purrr::map_chr("name")
  } else {
    gh::gh(
      "/users/{user}/repos",
      user = username,
      type = "all",
      per_page = 100,
      .limit = Inf
    ) |>
      purrr::map_chr("name")
  }

  repo_names <- c(
    repo_names,
    extra_repos[names(extra_repos) == username]
  ) |>
    unique()

  if (length(keep)) {
    bad_repos <- setdiff(keep, repo_names)
    if (length(bad_repos)) {
      msg <- "The following repositories were not present in %s: %s"
      stop(sprintf(msg, username, toString(bad_repos)))
    }
    repo_names <- repo_names[repo_names %in% keep]
  }

  message(sprintf("Launching archive creation for username %s", username))
  purrr::map(repo_names, repo$new, organization = username, user_type = user_type)

}

check_user <- function(username) {
  org <- try(
    gh::gh("/orgs/{org}", org = username),
    silent = TRUE
  )
  if (!inherits(org, "try-error")) {
    return("organization")
  }

  user <- try(
    gh::gh("/users/{user}", user = username),
    silent = TRUE
  )
  if (!inherits(user, "try-error")) {
    return("user")
  }

  rlang::abort(
    sprintf("Could not find organization or user '%s'.", username)
  )

}

check_users <- function(usernames) {
  purrr::map_chr(usernames, check_user)
}
