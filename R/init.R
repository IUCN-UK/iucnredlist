

init_redlist_api<-function(redlist_api_key){

  key<-httr2::secret_make_key()
  my_key<-httr2::secret_encrypt(redlist_api_key, key)

  req<-httr2::request("https://apiv4staging.iucnredlist.org/api/v4/") %>%
    req_headers("Authorization" = secret_decrypt(my_key, key))

  return(req)

}


