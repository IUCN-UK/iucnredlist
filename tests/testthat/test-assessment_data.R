load_assessment_fixture <- function() {
  assessment_fixture <- readLines("fixtures/assessment_132640680.json", warn = FALSE)
  paste(assessment_fixture, collapse = "\n")
}

test_that("the assessment_data function returns a list", {
  mocked_api <- httr2::request("https://api.iucnredlist.org/api/v4/assessment/132640680")

  mocked_response <- httr2::response(
    status_code = 200,
    headers = list("Content-Type" = "application/json"),
    body = charToRaw(load_assessment_fixture())
  )

  mocked_perform <- mockery:::mock(mocked_response)
  mockery:::stub(assessment_data, "httr2::req_perform", mocked_perform)

  result <- assessment_data(mocked_api, 132640680)

  expect_true(is.list(result))
  expect_length(result, 33)

  expect_true(is.list(result))
  expect_equal(result$assessment_date[[1, 1]], "2018-08-07T00:00:00.000Z")
})
