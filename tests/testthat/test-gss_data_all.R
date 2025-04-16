test_that("gss_data_all calls perform_request and returns expected response", {
  httptest2::with_mock_dir("gss_data_all", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    raw_gss_result <- gss_data_all(api)

    #expect_true(is.list(gss_fetched))
    #expect_length(gss_fetched, 1)

    #expect_equal(names(gss_fetched), c("assessments"))

    # expect_equal(names(gss_fetched$assessments[[1]]), c(
    #   "assessment_year", "weights", "justification",
    #   "species_recovery_category", "species_recovery_score_best", "species_recovery_score_minimum",
    #   "species_recovery_score_maximum", "conservation_legacy_category", "conservation_legacy_best",
    #   "conservation_legacy_minimum", "conservation_legacy_maximum", "conservation_dependence_category",
    #   "conservation_dependence_best", "conservation_dependence_minimum", "conservation_dependence_maximum",
    #   "conservation_gain_category", "conservation_gain_best", "conservation_gain_minimum",
    #   "conservation_gain_maximum", "recovery_potential_category", "recovery_potential_best",
    #   "recovery_potential_minimum", "recovery_potential_maximum", "assessor_names",
    #   "reviewer_names", "contributors", "facilitators",
    #   "compilers", "url", "assessment_date",
    #   "taxon"
    # )) # Column headers returned for each assessment

    #expect_length(unique(gss_fetched$assessments), 115) # 115 assessments returned
  })
})
