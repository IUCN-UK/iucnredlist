#' Creates a request object for a valid red_list_api_key
#' @importFrom dplyr %>%
#'
#' @param red_list_api_key A Red List API token string (alphanumeric)
#' @returns An httr2 request object.
#' @export
#' @examples
#' \dontrun{
#' api <- init_api("your_red_list_api_key")
#' }
init_api <- function(red_list_api_key) {
  key <- httr2::secret_make_key()
  my_key <- httr2::secret_encrypt(red_list_api_key, key)

  httr2::request("https://api.iucnredlist.org/api/v4/") %>%
    httr2::req_headers("Authorization" = httr2::secret_decrypt(my_key, key))
}
