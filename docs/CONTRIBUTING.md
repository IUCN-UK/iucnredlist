# How to contribute

As an official IUCN-supported library, we can intend to maintain synchronisation with any API changes and updates. We do, however, welcome contributions from our community of users, be it bug fixes or increased test coverage.

## Testing

We use [testthat](https://testthat.r-lib.org/)  for unit testing to ensure functions work as expected; see the tests/testthat/ directory for examples of test cases.

## Submitting changes

To get started, make sure you have the latest version of R.  Then run the following code to get the packages you’ll need for development:
```
install.packages(c("devtools", "roxygen2", "testthat", "knitr"))
```

Please send a GitHub Pull Request with a clear list of the changes -- please also include tests and make sure all of your commits contain only one feature per commit.

It is essential that any pull request passes `R CMD` check (also a requirement for submitting to CRAN).  Our recommended way to run `R CMD` check is in the R console via devtools by running:
```
check()
```
