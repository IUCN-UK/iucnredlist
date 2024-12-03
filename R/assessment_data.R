#' Get raw assessment data for a single assessment_id
#' @importFrom dplyr %>%
#'
#' @description Returns full JSON response from the Red List API as nested lists
#'
#' @param api An httr2 response object created with init_api()
#' @param assessment_id Integer. A single assessment_id
#' @returns A list of raw assessment data
#' @examples
#' \dontrun{
#' assessment_data(api, assessment_id = 123)
#' }
assessment_data <- function(api, assessment_id) {
  endpoint_request <- paste0("assessment/", assessment_id)

  perform_request(api, endpoint_request)
}
