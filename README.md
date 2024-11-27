
<!-- README.md is generated from README.Rmd. Please edit that file -->

# iucnredlist

<!-- badges: start -->
<!-- badges: end -->

The [International Union for Conservation of
Nature’s](https://www.iucn.org) [Red List of Threatened
Species](https://www.iucnredlist.org) has evolved to become the world’s
most comprehensive information source on the global conservation status
of animal, fungi and plant species. It’s a critical indicator of the
health of the world’s biodiversity.

The [IUCN Red List API](https://api.iucnredlist.org) has been developed
to inform and drive biodiversity conservation and policy change -—
critical steps in protecting essential natural resources. It provides
data on species range, population size, habitat and ecology, trade,
threats, and conservation actions to support informed conservation
decisions.

Our goal with the `iucnredlist` R package is to provide a client library
for the R programming language for the Red List API and provide the
research community and other users with an efficient, user-friendly tool
to access and interact with IUCN’s critical data and services.

We have open sourced this package to promoting transparency, enable
research community contributions, and drive adoption of the API. As an
official IUCN-supported library, we can intend to maintain
synchronisation with any API changes and updates. We also plan to
incorporate the library into training resources over time.

## Installation

You can install the development version of iucnredlist from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("IUCN-UK/iucnredlist")
```

## Example usage

Here’s a basic example which shows you how to extract habitat data for
the Felidae family.

To run this example you will first need to sign-up/log-in at
<https://api.iucnredlist.org/> and copy your api key from your account
page.

``` r
# Initialize the API with your API key
api_key <- 'your_red_list_api_key'  # Replace with your actual API key
api <- iucnredlist:::init_api("your_red_list_api_key")
# Step 1: Get assessment IDs for the Felidae family
# Check if assessments were found
# Step 2: Extract unique assessment IDs
# Step 3: Fetch assessment data for each assessment ID
# Set a reasonable wait time to avoid rate limiting (e.g., 0.5 seconds)
# Step 4: Extract habitats from the assessment data
# Clean and process the habitats data as needed
# Display the habitats data
```
