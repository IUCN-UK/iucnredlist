test_that("assessment_data_many returns assessment data for a collection of assessment ids", {
  httptest2::with_mock_dir("assessment_data_many_2911619_58307800_178423675", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    result <- assessment_data_many(api, c(2911619, 58307800, 178423675), wait_time = 0)

    expected_names <- c("assessment_date", "assessment_id", "assessment_points", "assessment_ranges", "biogeographical_realms", "citation", "conservation_actions", "conservation_actions_in_place", "credits", "criteria", "errata", "faos", "growth_forms", "habitats", "latest", "lmes", "locations", "population_trend", "possibly_extinct", "possibly_extinct_in_the_wild", "red_list_category", "references", "researches", "scopes", "sis_taxon_id", "stresses", "supplementary_info", "systems", "taxon", "taxon_common_names", "taxon_ssc_groups", "taxon_synonyms", "threats", "url", "use_and_trade", "year_published")

    expect_length(result, 3)

    expect_equal(names(result[[1]]), expected_names)
    expect_equal(names(result[[2]]), expected_names)
    expect_equal(names(result[[3]]), expected_names)

    expect_equal(names(result[[1]]$assessment_id), dplyr::tibble(value = 2911619))
    expect_equal(names(result[[2]]$assessment_id), dplyr::tibble(value = 58307800))
    expect_equal(names(result[[3]]$assessment_id), dplyr::tibble(value = 178423675))
  })
})
