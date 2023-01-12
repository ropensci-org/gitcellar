<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# gitcellar (development version)

## Bug fixes

- Test.
- Fix failure behavior (#15).

## Features

- Support personal accounts (#18).

## Documentation

- Clarify keep parameter.
fix #16

## Uncategorized

- More than 1 organization.


# gitcellar 0.0.0.9000

* Parameter `keep` allows users to define which repositories should be archived (#13, @zkamvar)

* The README and function documentation include a note about the required 
  permissions for the GitHub PAT (#11, @Bisaloo)

* Asking for repositories from an external organization in `extra_repos` now 
  return an error (#10, @Bisaloo)

* Fix GitHub PAT finding for the curl step (#6, @k-doering-NOAA).

* Added a `NEWS.md` file to track changes to the package.
