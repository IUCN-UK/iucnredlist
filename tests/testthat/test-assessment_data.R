test_that("assessment_data calls perform_request and returns expected response", {
  mock_response <- jsonlite::fromJSON(jsonlite::toJSON(jsonlite::fromJSON('fixtures/assessment_132640680.json')))

  mock_perform_request <- mockery::mock(mock_response)

  with_mock(
    perform_request = mock_perform_request,
    {
      result <- assessment_data("mocked_api", 12345)
      expect_equal(result, mock_response)
    }
  )
})
