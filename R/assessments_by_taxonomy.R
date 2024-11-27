# Main function to retrieve assessment data for the taxa endpoint
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
