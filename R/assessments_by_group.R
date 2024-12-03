# GET BASIC ASSESSMENT INFORMATION BY GROUP AND CODE/NAME
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
