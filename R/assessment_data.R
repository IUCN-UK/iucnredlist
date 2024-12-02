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
  url <- paste0("https://api.iucnredlist.org/api/v4/assessment/", assessment_id)

  tryCatch(
    {
      req <- api %>%
        httr2::req_url(url) %>%
        httr2::req_perform()

      httr2::resp_body_json(req)
    },
    httr2_http_401 = function(e) {
      cat("Error 401: Unauthorized. This error may occur if your Red List API token was copied incorrectly. You can retrieve your API token at https://api.iucnredlist.org/users/edit\n")
    },
    error = function(error) {
      cat("An unexpected error occurred:", error$message, "\n")
    }
  )
}
