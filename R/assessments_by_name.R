# Return latest and historic assessments for a Latin binomial
assessments_by_name <- function(api, genus, species) {
  all_data <- list()

  url <- paste0("https://api.iucnredlist.org/api/v4/taxa/scientific_name?genus_name=", genus, "&species_name=", species)

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
