test_that("assessment_data calls perform_request and returns expected response", {
  httptest2::with_mock_dir("assessment_742738", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    result <- assessment_data(api, 742738)

    expect_true(is.list(result))
    expect_length(result, 33)

    expect_equal(result$assessment_date, "2023-04-29T00:00:00.000Z")
    expect_equal(result$year_published, "2023")
    expect_equal(result$latest, TRUE)
    expect_equal(result$possibly_extinct, FALSE)
    expect_equal(result$possibly_extinct_in_the_wild, FALSE)
    expect_equal(result$sis_taxon_id, 157079)
    expect_equal(result$criteria, NULL)
    expect_equal(result$url, 'https://www.iucnredlist.org/species/157079/742738')
    expect_equal(result$citation, "Parmakelis, A. 2023. Mastus unius. The IUCN Red List of Threatened Species 2023: e.T157079A742738. https://dx.doi.org/10.2305/IUCN.UK.2023-1.RLTS.T157079A742738.en. Accessed on 02 December 2024.")
    expect_equal(result$assessment_id, 742738)
    expect_equal(result$assessment_points, FALSE)
    expect_equal(result$assessment_ranges, FALSE)

    expect_true(is.list(result$taxon))
    expect_length(result$taxon, 21)
    expect_equal(result$taxon$sis_id, 157079)

    expect_true(is.list(result$taxon$ssc_groups))
    expect_true(is.list(result$taxon$common_names))
    expect_true(is.list(result$taxon$synonyms))
  })
})
