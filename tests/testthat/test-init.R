test_that("init_redlist_api returns a valid httr2 request object", {
  red_list_api_key <- "a_valid_red_list_api_key"
  request <- initialise_red_list_client(red_list_api_key)

  expect_equal(request[1]$url, "https://apiv4staging.iucnredlist.org/api/v4/")
  expect_equal(request[3]$headers$Authorization, red_list_api_key)
})

test_that("init_redlist_api returns an error if no red list api key is passed", {
  expect_error(initialise_red_list_client())
})

test_that("RedListClient returns an object with an httr2 request", {
  client <- RedListClient$new("an_api_key")
  expect_equal(client$request[1]$url, "https://apiv4staging.iucnredlist.org/api/v4/")
  expect_equal(client$request[3]$headers$Authorization, "an_api_key")
})
