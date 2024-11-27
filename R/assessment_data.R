#' Get full assessment data for an assessment ID
#' @importFrom dplyr %>%
#'
#'
#' @description foo bar
#'
#' @param api An httr2 response object created with init_api()
#' @param assessment_id Integer. A single assessment_id
#' @returns A list of length 1 containing full assessment data
#' @examples
#' \dontrun{
#' assessment_data(api, assessment_id = 123)
#' }
assessment_data <- function(api, assessment_id) {

  url <- paste0("https://api.iucnredlist.org/api/v4/assessment/", assessment_id)

  req <- api %>%
    httr2::req_url(url) %>%
    httr2::req_perform()

  response_json <- httr2::resp_body_json(req)

  parse_assessment_data(response_json)

}
