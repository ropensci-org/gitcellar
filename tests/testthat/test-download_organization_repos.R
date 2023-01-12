test_that("external repos in `extra_repos` trigger an error", {

  expect_error(
    download_organization_repos("maelle-test", extra_repos = c("cran" = "sf")),
    "accounts"
  )

})
