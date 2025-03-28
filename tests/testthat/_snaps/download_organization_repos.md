# wrong case triggers an error

    Code
      download_organization_repos("MAELLE")
    Condition
      Error in `purrr::map_chr()`:
      i In index: 1.
      Caused by error in `map_()`:
      x `username` "MAELLE" not equal to actual user name "maelle"
      i Please fix the case

