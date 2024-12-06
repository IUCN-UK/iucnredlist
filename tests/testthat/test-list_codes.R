test_that("list_codes performs a request and returns a list of codes for a valid group", {
  httptest2::with_mock_dir("list_codes_scope", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    result <- list_codes(api, "scopes")
    expect_equal(result$description, c("Global", "Europe", "Mediterranean", "Western Africa", "S. Africa FW", "Pan-Africa", "Central Africa", "Northeastern Africa", "Eastern Africa", "Northern Africa", "Gulf of Mexico", "Caribbean", "Persian Gulf", "Arabian Sea"))
  })
})

test_that("list_codes performs a request and returns an error for an invalid group", {
  httptest2::with_mock_dir("list_codes_invalid", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    result <-
      expect_error(
        list_codes(api, "an_invalid_group"),
        "HTTP 404 Not Found."
      )
  })
})
