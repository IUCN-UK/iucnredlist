load_biogeographical_realms_fixture <- function() {
  assessment_fixture <- readLines("fixtures/biogeographical_realms.json", warn = FALSE)
  paste(assessment_fixture, collapse = "\n")
}

test_that("the assessment_data function returns a list", {
  mocked_api <- httr2::request("https://api.iucnredlist.org/api/v4/biogepgraphical_realms")

  mocked_response <- httr2::response(
    status_code = 200,
    headers = list("Content-Type" = "application/json"),
    body = charToRaw(load_biogeographical_realms_fixture())
  )

  mocked_perform <- mockery:::mock(mocked_response)
  mockery:::stub(list_codes, "httr2::req_perform", mocked_perform)

  result <- list_codes(api, 'biogeographical_realms')

  expect_true(is.list(result))
  expect_length(result, 2)
  expect_equal(result[[1,1]], 'Afrotropical')
  expect_equal(result[[nrow(result),1]], 'Palearctic')
})
