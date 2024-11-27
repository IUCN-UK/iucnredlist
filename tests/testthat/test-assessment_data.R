test_that("the assessment data function returns an expeted response", {
  mocked_api <- httr2::request("https://api.iucnredlist.org/api/v4/assessment/742738")
  mocked_response <- httr2::response(
    status_code = 200,
    headers = list("Content-Type" = "application/json"),
    body = charToRaw('{"assessment_date": "2023-04-29T00:00:00.000Z", "year_published": "2023", "latest": true, "sis_taxon_id": 157079}')
  )

  mocked_perform <- mockery:::mock(mocked_response)
  mockery:::stub(assessment_data, "httr2::req_perform", mocked_perform)

  result <- assessment_data(mocked_api, 742738)

  expect_true(is.list(result))
  expect_length(result, 4)

  expect_true(is.list(result))
  expect_equal(result$assessment_date[[1,1]], "2023-04-29T00:00:00.000Z")
})
