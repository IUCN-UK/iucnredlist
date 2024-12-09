#' Display API and Red List versions
#'
#' @param api A httr2 response object created with init_api().
#' @returns A list containing the API version and Red List version.
#' @export
#' @examples
#' \dontrun{
#' api <- rl_version(api)
#' }
rl_version <- function(api) {

  endpoint_request <- paste0("information/api_version")
  api_version <- perform_request(api, endpoint_request)
  api_version

  endpoint_request <- paste0("information/red_list_version")
  rl_version <- perform_request(api, endpoint_request)
  rl_version

  return(c(api_version, rl_version))
}
