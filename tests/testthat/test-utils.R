load_assessment_fixture <- function() {
  assessment_fixture <- readLines("fixtures/assessment_132640680.json", warn = FALSE)
  paste(assessment_fixture, collapse = "\n")
}

test_that("the parse_assessment_data function returns a list", {

  fixture <- jsonlite::fromJSON(jsonlite::toJSON(jsonlite::fromJSON('fixtures/assessment_132640680.json')))
  result <- parse_assessment_data(fixture)

  expect_true(is.list(result))
  expect_length(result, 33)

  expect_equal(result$assessment_date[[1,1]], "2018-08-07T00:00:00.000Z")
  expect_equal(result$year_published[[1,1]], "2018")
  expect_equal(result$latest[[1,1]], TRUE)
  expect_equal(result$possibly_extinct[[1,1]], FALSE)
  expect_equal(result$possibly_extinct_in_the_wild[[1,1]], FALSE)
  expect_equal(result$sis_taxon_id[[1,1]], 22698305)
  expect_equal(result$criteria[[1,1]], 'A4bd')
  expect_equal(result$url[[1,1]], 'https://www.iucnredlist.org/species/22698305/132640680')
  expect_equal(result$citation[[1,1]], "BirdLife International 2018. Diomedea exulans. The IUCN Red List of Threatened Species 2018: e.T22698305A132640680. https://dx.doi.org/10.2305/IUCN.UK.2018-2.RLTS.T22698305A132640680.en. Accessed on 28 November 2024.")
  expect_equal(result$assessment_id[[1,1]], 132640680)
  expect_equal(result$assessment_points[[1,1]], FALSE)
  expect_equal(result$assessment_ranges[[1,1]], TRUE)

  expect_equal(is.list(result$taxon), TRUE)
  expect_length(result$taxon, 21)
  expect_equal(result$taxon$sis_id, 22698305)

  expect_equal(class(result$taxon$ssc_groups), 'character')
  expect_equal(class(result$taxon$common_names), 'character')
  expect_equal(class(result$taxon$synonyms), 'character')



})
