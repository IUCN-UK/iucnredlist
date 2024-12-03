test_that("perform_request successfuly requests an assessment from the API and returns a list", {
  httptest2::with_mock_dir("assessment_742738", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)
    expect_length(perform_request(api, 'assessment/742738'), 33)
  })
})

test_that("perform_request handles a 401 error for an invalid API key", {
  httptest2::with_mock_dir("assessment_invalid_api_key", {
    api <- init_api('an_invalid_api_key')
    expect_error(
      perform_request(api, 'assessment/742738'),
      "Error 401: Unauthorized. This error may occur if your Red List API token was copied incorrectly."
    )
  })
})

test_that("perform_request handles a non 200 or 401 http status code (e.g. for an invalid endpoint)", {
  httptest2::with_mock_dir("assessment_invalid_endpoint", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)
    expect_error(
      perform_request(api, 'invalid_endpoint/742738'),
      "An unexpected error occurred: HTTP 404 Not Found."
    )
  })
})
