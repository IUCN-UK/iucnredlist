#' Get minimal assessment data for a Latin binomial
#' @importFrom dplyr %>%
#'
#' @description The `assessment_by_` functions including `assessments_by_name()` return 'minimal' assessment data
#' for your specified filters (arguments). The minimal assessment data provides assessment_ids and sis_taxon_ids
#' (as a tibble) which can be used with `assessment_data()`, `assessment_data_many()` and `partial_assessment_data()`
#' to get full assessment data.
#'
#' The `assessments_by_name()` function returns minimal assessment data for a supplied Latin binomial.
#' The genus and species arguments are not case sensitive.
#'
#' @param api An httr2 response object created with init_api().
#' @param genus String. A genus name.
#' @param species String. A species name.

#' @returns Returns a `tibble()` of minimal assessment data for the supplied genus and species name. The minimal assessment data
#' provides assessment_ids and sis_taxon_ids which can then be used with `assessment_data()`, `assessment_data_many()` and
#'  `partial_assessment_data()` to get full assessment data.
#' @export
#' @examples
#' \dontrun{
#' assessments_by_name(api, "panthera", "leo")
#' }
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
