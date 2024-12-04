#' Get minimal assessment data for an API group
#' @importFrom dplyr %>%
#'
#' @description The `assessment_by_` functions including `assessments_by_group()` return 'minimal' assessment data
#' for your specified filters (arguments). The minimal assessment data provides assessment_ids and sis_taxon_ids
#' (as a tibble) which can then be used with `assessment_data()`, `assessment_data_many()` and `partial_assessment_data()`
#' to get full assessment data.
#'
#' The `assessments_by_group()` function acts upon the API assessment group names and codes.
#' Valid names can be found by calling `list_group_names()` and codes can be
#' found with `list_codes(api, "scopes")`.
#'
#' @param api An httr2 response object created with init_api().
#' @param group String. A valid API group name. Valid names can be found by calling `list_group_names()`.
#' @param code String. A valid group code. Valid codes for an API group can be
#' found by calling e.g. `list_codes(api, "habitats")`
#' @param wait_time Time in seconds to wait between API calls. A wait of 0.5 seconds or greater will ensure you
#' won't hit the IUCN Red List API rate limit.
#' @param latest Boolean. Return latest or historic assessments. Defaults to `TRUE`.
#' @param scope_code String. A valid assessment scope. Defaults to `NULL` (i.e. returns assessments of all scopes).
#' Valid scope codes can be found by calling `list_codes(api, "scopes")`.
#' @param wait_time Float. Time in seconds to wait between API calls. A wait time of >=0.5s will avoid API rate limiting.
#' @param show_warnings Boolean. Whether to show a warning to the console if no assessments are found for your specified arguments.
#' Defaults to `TRUE`.
#' @returns Returns a `tibble()` of minimal assessment data for your specified arguments. The minimal assessment data
#' provides assessment_ids and sis_taxon_ids which can be used with `assessment_data()`, `assessment_data_many()` and
#'  `partial_assessment_data()` to get full assessment data.
#' @export
#' @examples
#' \dontrun{
#' assessments_by_group(api, group = "habitats", code = "1_1", year_published = 2012, latest = TRUE, scope_code = 1, wait_time = 0.5, show_warnings = TRUE)
#' }
assessments_by_group <- function(api, group, code, year_published = NULL, latest = TRUE, scope_code = NULL, wait_time = 0.5, show_warnings = TRUE) {
  # Gather user's query params, throw away any that are NULL
  query_params <- list(latest = latest, year_published = year_published, scope_code = scope_code, page = 1, per_page = 100) %>%
    purrr::discard(is.null)

  url <- paste0("https://api.iucnredlist.org/api/v4/", group, "/", code)
  data <- fetch_paginated_data(api, url, query_params, wait_time = wait_time)

  if (nrow(data) > 0) {
    janitor::clean_names(data) %>%
      dplyr::select(sis_taxon_id, assessment_id, latest, year_published, scopes_description_en, scopes_code, url)
  } else {
    if (show_warnings == TRUE) {
      cli::cli_alert_warning("There are no assessments for your combination of query parameters/filters. Please check and try again.")
    }
    dplyr::tibble()
  }
}
