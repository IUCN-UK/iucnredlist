#' Fetch assessment data for a single assessment ID
#' @importFrom dplyr %>%
#'
#' @description Returns full assessment data for a single assessment_id as a named list.
#' Some of the elements within the top-level named list (e.g. taxon, conservation actions)
#' contains nested lists of data.
#'
#' @param api An `{httr2}` response object created with `init_api()`.
#' @param assessment_id Integer. A single Red List assessment_id.
#' @returns Returns an unprocessed named list of assessment data for a single assessment_id.
#' The raw JSON from the assessment endpoint has been coerced to a list but is
#' otherwise an exact representation of the response from the assessment endpoint.
#' @export
#' @examples
#' \dontrun{
#' assessment_data(api, assessment_id = 266696959)
#' }
assessment_data <- function(api, assessment_id) {
  endpoint_request <- paste0("assessment/", assessment_id)
  perform_request(api, endpoint_request)
}
