# Return latest and historic assessments for an SIS taxon ID
assessments_by_sis_id <- function(api, sis_taxon_id) {
  all_data <- list()

  url <- paste0("https://api.iucnredlist.org/api/v4/taxa/sis/", sis_taxon_id)

  resp <- api %>%
    httr2::req_url(url) %>%
    httr2::req_perform()

  response_json <- httr2::resp_body_json(resp)
  endpoint_data <- response_json$assessments %||% list()

  page_data <- purrr::map_dfr(endpoint_data, purrr::possibly(unnest_scopes, otherwise = dplyr::tibble()))
  all_data <- append(all_data, list(page_data))

  all_data <- dplyr::bind_rows(all_data) %>%
    janitor::clean_names()

  return(all_data)
}
