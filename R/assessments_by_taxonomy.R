#' Get minimal assessment data for a taxonomic level
#' @importFrom dplyr %>%
#'
#' @description The `assessment_by_` functions including `assessments_by_taxonomy()` return 'minimal' assessment data
#' for your specified filters (arguments). The minimal assessment data provides assessment_ids and sis_taxon_ids
#' (as a tibble) which can then be used with `assessment_data()`, `assessment_data_many()` and `partial_assessment_data()`
#' to get full assessment data.
#'
#' The `assessments_by_taxonomy()` returns minimal assessment data for a given taxonomic hierarchy name.
#'
#' @param api An httr2 response object created with init_api().
#' @param level String. The level of taxonomic hierachy. Must be one of: kingdom, phylum, class, order or family.
#' @param name String. The name of taxonomic hierarchy.
#' @param year_published Integer. The publication year you wish to filter.
#' @param latest Boolean. Return latest or historic assessments. Defaults to `TRUE`.
#' @param scope_code String. A valid assessment scope. Defaults to `NULL` (i.e. returns assessments of all scopes).
#' Valid scope codes can be found by calling `list_codes(api, "scopes")`.
#' @param wait_time Time in seconds to wait between API calls. A wait of 0.5 seconds or greater will ensure you
#' won't hit the IUCN Red List API rate limit.
#' Defaults to `TRUE`.
#' @returns Returns a `tibble()` of minimal assessment data for your specified arguments. The minimal assessment data
#' provides assessment_ids and sis_taxon_ids which can be used with `assessment_data()`, `assessment_data_many()` and
#'  `parse_assessment_data()` to get full assessment data.
#' @export
#' @examples
#' \dontrun{
#' assessments_by_taxonomy(api,
#'   level = "family",
#'   name = "felidae",
#'   year_published = 2022,
#'   latest = TRUE,
#'   scope_code = 1,
#'   wait_time = 0.5
#' )
#' }
assessments_by_taxonomy <- function(api, level, name, year_published = NULL, latest = TRUE, scope_code = NULL, wait_time = 0.5) {
  # Gather user's query params, throw away any that are NULL
  query_params <- list(latest = latest, year_published = year_published, scope_code = scope_code, page = 1, per_page = 100) %>%
    purrr::discard(is.null)

  url <- paste0("https://api.iucnredlist.org/api/v4/taxa/", level, "/", name)
  data <- fetch_paginated_data(api, url, query_params)

  if (nrow(data) > 0) {
    janitor::clean_names(data) %>%
      dplyr::select(sis_taxon_id, assessment_id, latest, year_published, scopes_description_en, scopes_code, url)
  } else {
    cli::cli_alert_warning("There are no assessments for your combination of query parameters/filters. Please check and try again.")
  }
}
