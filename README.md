
<!-- README.md is generated from README.Rmd. Please edit that file -->

# iucnredlist <a href="https://iucn-uk.github.io/iucnredlist/"><img src="man/figures/logo.png" align="left" height="160" alt="iucnredlist website" /></a>

[![R-CMD-check](https://github.com/IUCN-UK/iucnredlist/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/IUCN-UK/iucnredlist/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/IUCN-UK/iucnredlist/actions/workflows/test-coverage.yaml/badge.svg?branch=main)](https://github.com/IUCN-UK/iucnredlist/actions/workflows/test-coverage.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Star on
GitHub](https://github.com/IUCN-UK/iucnredlist/)](https://img.shields.io/github/stars/IUCN-UK/iucnredlist)

The [International Union for Conservation of
Nature’s](https://www.iucn.org) [Red List of Threatened
Species](https://www.iucnredlist.org) has evolved to become the world’s
most comprehensive information source on the global conservation status
of animal, fungi and plant species. It’s a critical indicator of the
health of the world’s biodiversity.

The [IUCN Red List API](https://api.iucnredlist.org) has been developed
to inform and drive biodiversity conservation and policy change -—
critical steps in protecting essential natural resources. It provides
programmatic access to data including (but limited to); population size,
habitat and ecology, trade and threats to help support informed
conservation decisions.

The iucnredlist R package aims to serve as a client library for the Red
List API, offering the research community and other users an efficient
and user-friendly tool to access and interact with the vital data and
services provided by the IUCN Red List.

We have open sourced this package to promote transparency, enable
research community contributions, and drive adoption of the API. As an
official IUCN-supported library, we shall maintain synchronisation with
any API changes and updates.

We are proponents of the [tidyverse](https://www.tidyverse.org) and have
worked to ensure that outputs from `iucnredlist` functions conform to
tidy data principles where possible.

## API Usage

The use of the API falls under the same [Terms of
Use](https://www.iucnredlist.org/terms/terms-of-use) as the Red List. By
requesting a token, you are agreeing to abide by the Terms of Use of the
Red List. If your token usage is found to be in breach of our terms of
use, it will be revoked. We kindly request your cooperation in ensuring
responsible and respectful usage of our services.

Please be aware that misusing your API token, such as using it for
information extraction (scraping) rather than making legitimate requests
for non-commercial purposes, may result in your token being rate limited
and/or revoked.

We are committed to maintaining a high-quality service for all users and
have implemented a rate limiting system to ensure our resources are
accessible equally to all. We actively monitor API usage to prevent
abuse. We understand that some users may have unique requirements for
making frequent calls in succession. If you find yourself in such a
situation, we kindly request that you incorporate appropriate delays
between your API calls to ensure smooth operation and prevent
overloading our system, otherwise your token may be further
rate-limited. It’s important to note that the Red List API is primarily
designed to support conservation efforts, particularly in the fields of
education and research. We may need to restrict access if the API is
being used for purposes that do not align with our mission, such as
mobile app development, inclusion in computing courses, or visualization
projects unrelated to conservation.

*Use of the Red List API for commercial purposes is strictly forbidden.
Users who wish to use Red List data for commercial purposes should
consider subscribing to [IBAT](www.ibat-alliance.org).*

### Responsible Usage

We are committed to ensuring fast and reliable access for all users of
this API. To this end, we have implemented rate limiting to maintain
service reliability for all users. Several functions within this package
have an argument called `wait_time` - we recommend setting this to
\>=0.5 seconds (default 0.5 seconds) to avoid rate limiting. If you
build your own functions from this package, we recommend you implement
an appropriate wait time in your code to avoid any such limits.

## Installation

You can install the development version of `iucnredlist` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("IUCN-UK/iucnredlist")
```

## Example Usage

The `iucnredlist` package contains a number of functions to allow quick
access to Red List data. The examples below are some quick-start scripts
to get you familiar with a basic `iucnredlist` workflow.

Before running this code, you must first sign up to the [Red List
API](https://api.iucnredlist.org) to obtain an API token. You can view
(and cycle) your token from your [account
page](https://api.iucnredlist.org/users/edit).

### Fetch data for a single assessment

``` r
# Initialize the API with your API key
api <- init_api("your_red_list_api_key")

# Fetch assessment data for assessment_id = 266696959 (Panthera leo)
# Returns a list containing all assessment data
assessment_raw <- assessment_data(api, 266696959)

# Parse the 'raw' assessment data to tidy tibbles
assessment <- parse_assessment_data(assessment_raw)

# View e.g. threats or habitats
# The result is a tidy 'tibble()` of data
assessment$threats
assessment$habitats
```

### Fetch all assessments for an SIS taxon ID

``` r
# Initialize the API with your API key
api <- init_api("your_red_list_api_key")

# Get 'minimal' assessment data for the European Sturgeon
sturgeon <- assessments_by_sis_id(api, 230)
```

### Gather full assessment data for many assessment IDs

``` r

# Using the sturgeon assessment IDs from above example, get full assessment data
sturgeon_all <- assessment_data_many(api, sturgeon$assessment_id)

# View theats
sturgeon_threats <- extract_element(sturgeon_all, "threats")
```

### Fetch all assessments for a Latin binomial name

``` r
# Initialize the API with your API key
api <- init_api("your_red_list_api_key")

# Get all historic and latest assessments for Panthera leo (not case-sensitive)
lion <- assessments_by_name(api, genus = "panthera", species = "leo")
```

### Show threats for a taxonomic level

``` r
# Initialize the API with your API key
api <- init_api("your_red_list_api_key")

# Step 1: Get all latest and global-scope assessment IDs for the family Felidae
felidae <- assessments_by_taxonomy(api,
  level = "family",
  name = "felidae",
  latest = TRUE,
  scope_code = 1,
  wait_time = 0.5
)

# Step 2: Fetch assessment data for each assessment ID
# Pass the assessment_id column to `assessment_data_many() to grab
# full assessment data for each assessment_id
a_data <- assessment_data_many(api,
  felidae$assessment_id,
  wait_time = 0.5
)

# Step 3: Extract habitats from the assessment data
# This will iterate over each assessment in the list a_data
# and return a tidy `tibble()` for all habitats
habitats <- extract_element(a_data, "habitats")

# Alternatively, extract threats
threats <- extract_element(a_data, "threats")

# See all elements you can extract - use any of these with `extract_element()`
element_names()
```

# How to contribute

As an official IUCN-supported library, we intend to maintain
synchronisation with any API changes and updates. We do, however,
welcome contributions from our community of users, be it bug fixes or
increased test coverage.

## Testing

We use [testthat](https://testthat.r-lib.org/) for unit testing to
ensure functions work as expected; see the tests/testthat/ directory for
examples of test cases.

## Submitting changes

To get started, make sure you have the latest version of R. Then run the
following code to get the packages you’ll need for development:

    install.packages(c("devtools", "roxygen2", "testthat", "knitr"))

Please send a GitHub Pull Request with a clear list of the changes –
please also include tests and make sure all of your commits contain only
one feature per commit.

It is essential that any pull request passes `R CMD` check (also a
requirement for submitting to CRAN). Our recommended way to run `R CMD`
check is in the R console via devtools by running:

    check()
