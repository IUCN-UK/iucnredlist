#' Get minimal assessment data for an SIS taxon ID
#' @importFrom dplyr %>%
#'
#' @description The `assessment_by_` functions including `assessments_by_sis_id()` return 'minimal' assessment data
#' for your specified filters (arguments). The minimal assessment data provides assessment_ids and sis_taxon_ids
#' (as a tibble) which can be used with `assessment_data()`, `assessment_data_many()` and `partial_assessment_data()`
#' to get full assessment data.
#'
#' The `assessments_by_sis_id()` function returns minimal assessment data for a supplied SIS taxon ID.
#'
#' @param api An httr2 response object created with init_api().
#' @param sis_taxon_id Integer. A valid SIS taxon ID.

#' @returns Returns a `tibble()` of minimal assessment data for the supplied SIS taxon ID. The minimal assessment data
#' shows assessment_ids for the supplied SIS taxon ID which can then be used with `assessment_data()`,
#' `assessment_data_many()` and `partial_assessment_data()` to get full assessment data.
#' @export
#' @examples
#' \dontrun{
#' assessments_by_sis_id(api, 230)
#' }
assessments_by_sis_id <- function(api, sis_taxon_id) {
  all_data <- list()

  endpoint_request <- paste0("taxa/sis/", sis_taxon_id)
  response_json <- perform_request(api, endpoint_request)

  endpoint_data <- response_json$assessments %||% list()

  page_data <- purrr::map_dfr(endpoint_data, purrr::possibly(unnest_scopes, otherwise = dplyr::tibble()))
  all_data <- append(all_data, list(page_data))

  all_data <- dplyr::bind_rows(all_data) %>%
    janitor::clean_names()

  return(all_data)
}
