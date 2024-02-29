# Creates a request object for a valid red_list_api_key
# encryption key with secret_make_key() that is used to scramble and descramble secrets using symmetric cryptography:

init_red_list_api <- function(red_list_api_key) {
  key <- httr2::secret_make_key()
  my_key <- httr2::secret_encrypt(red_list_api_key, key)

  req <- httr2::request("https://apiv4staging.iucnredlist.org/api/v4/") %>%
    req_headers("Authorization" = secret_decrypt(my_key, key))

  return(req)
}
