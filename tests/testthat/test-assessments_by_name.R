test_that("assessment_data calls perform_request and returns expected response", {
  httptest2::with_mock_dir("assessments_panthera_leo", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    result <- assessments_by_name(api, "panthera", "leo")
    expect_true(is.list(result))
    expect_length(result, 7)

    expect_equal(names(result), c("year_published", "latest", "sis_taxon_id", "url", "assessment_id", "scopes_description_en", "scopes_code"))
    expect_equal(result$year_published, c("2024", "2023", "2024", "2016", "2016", "2016", "2015", "2015", "2012", "2008", "2010", "2004", "2002", "1996"))
    expect_equal(unique(result$sis_taxon_id), c(15951))
    expect_equal(unique(result$scopes_description_en), c("Global", "Mediterranean"))
    expect_equal(unique(result$scopes_code), c("1", "4"))
  })
})
