#' Fetch all green status of species (gss) assessment data
#' @importFrom utils packageVersion
#'
#' @description Returns full assessment data for all green status of species assessments.
#'
#' @param api An `{httr2}` response object created with `init_api()`.
#'
#' @returns Returns an unprocessed named list of assessment data for all
#' green status of species assessments.
#' The raw JSON from the gss endpoint has been coerced to a list but is otherwise
#' an exact representation of the response from the assessment endpoint.
#' @export
#'
#' @examples
#' \dontrun{
#' gss_data_all(api)
#' }
gss_data_all <- function(api) {
  endpoint_request <- "green_status/all"
  perform_request(api, endpoint_request)
}
