#' Creates a request object for a valid red_list_api_key
#'
#' @param red_list_api_key A string.
#'
#' @return A list.
#' @export
#'
initialise_red_list_client <- function(red_list_api_key) {
  key <- httr2::secret_make_key()
  my_key <- httr2::secret_encrypt(red_list_api_key, key)

  req <- httr2::request("https://apiv4staging.iucnredlist.org/api/v4/") %>%
    httr2::req_headers("Authorization" = httr2::secret_decrypt(my_key, key))

  return(req)
}

RedListClient <- R6::R6Class("RedListClient", list(
  red_list_api_token = NULL,
  request = NULL,
  version = NULL,
  initialize = function(red_list_api_token) {
    self$request <- httr2::request("https://apiv4staging.iucnredlist.org/api/v4/") %>% httr2::req_headers("Authorization" = red_list_api_token)
    self$version <- httr2::req_url_path_append(self$request, '/information/version')
  }
))
