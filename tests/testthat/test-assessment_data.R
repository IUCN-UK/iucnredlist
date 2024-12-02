test_that("assessment_data calls perform_request and returns expected response", {
  mocked_api <- "mocked_api_object"
  mocked_response <- jsonlite::fromJSON(jsonlite::toJSON(jsonlite::fromJSON('fixtures/assessment_132640680.json')))

  mocked_perform_request <- mockery::mock(mocked_response)
  mockery::stub(assessment_data, "perform_request", mocked_perform_request)

  result <- assessment_data(mocked_api, 742738)
  expect_equal(result, mocked_response)
})
