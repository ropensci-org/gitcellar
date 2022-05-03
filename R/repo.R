repo <- R6::R6Class("repo",
  public = list(
    organization = NULL,
    name = NULL,
    migration_url = NULL,
    downloaded = FALSE,
    initialize = function(name = NA, organization = NA) {
      self$organization <- organization
      self$name <- name
      self$launch_migration()
    },
    launch_migration = function() {
      message(sprintf("Launching backup of %s/%s at %s", self$organization, self$name, Sys.time()))
      Sys.sleep(3)
      migration <- gh::gh(
        "POST /orgs/{org}/migrations",
        org = self$organization,
        repositories = as.list(self$name)
      )
      self$migration_url <- migration[["url"]]
    },
    launch_download = function() {
      message(sprintf("Saving archive of %s/%s at %s", self$organization, self$name, Sys.time()))
      Sys.sleep(3)
      handle <- curl::handle_setheaders(
        curl::new_handle(followlocation = FALSE),
        "Authorization" = paste("token", Sys.getenv("GITHUB_PAT")),
        "Accept" = "application/vnd.github.v3+json"
      )

      url <- sprintf("%s/archive", self$migration_url)
      req <- curl::curl_fetch_memory(url, handle = handle)
      headers <- curl::parse_headers_list(req$headers)
      final_url <- headers$location
      archive_folder <- sprintf("archive-%s_%s", self$organization, self$name)
      fs::dir_create(archive_folder)
      curl::curl_download(
        final_url,
        file.path(archive_folder, sprintf("%s_%s_migration_archive.tar.gz", self$organization, self$name))
      )
      self$downloaded <- TRUE
    }
  ),
  active = list(migration_state = function() {
    migration <- gh::gh(self$migration_url)
    state <- migration[["state"]]
    if (state == "failed") {
      message(sprintf("Re-launching backup of %s/%s at %s", self$organization, self$name, Sys.time()))
      Sys.sleep(3)
      self$launch_migration()
      self$migration_state
    }
    return(state)
  })
)
