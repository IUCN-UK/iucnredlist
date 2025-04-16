test_that("parse_gss_data takes input data and returns expected response", {
  httptest2::with_mock_dir("parse_gss_data", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    raw_gss_result <- gss_data_all(api)
    parsed_gss <- parse_gss_data(raw_gss_result)

    expect_true(tibble::is_tibble(parsed_gss))
    expect_equal(nrow(parsed_gss), length(raw_gss_result$assessments))

    expected_names <- c(
      "sis_id", "scientific_name", "assessment_date", "assessment_year", "weights",
      "species_recovery_category", "species_recovery_score_best",
      "species_recovery_score_minimum", "species_recovery_score_maximum",
      "conservation_legacy_category", "conservation_legacy_best",
      "conservation_legacy_minimum", "conservation_legacy_maximum",
      "conservation_dependence_category", "conservation_dependence_best",
      "conservation_dependence_minimum", "conservation_dependence_maximum",
      "conservation_gain_category", "conservation_gain_best",
      "conservation_gain_minimum", "conservation_gain_maximum",
      "recovery_potential_category", "recovery_potential_best",
      "recovery_potential_minimum", "recovery_potential_maximum",
      "kingdom_name", "phylum_name", "class_name", "order_name", "family_name",
      "genus_name", "species_name", "species", "subpopulation", "infrarank", "infra_name"
    ) # Column headers returned for each assessment

    expect_equal(names(parsed_gss), expected_names)

    expect_equal(parsed_gss[which(parsed_gss$sis_id == 15958 & parsed_gss$assessment_year == 2024),]
                 $scientific_name, "Panthera pardus ssp. nimr")
    expect_equal(parsed_gss[which(parsed_gss$sis_id == 5672 & parsed_gss$assessment_year == 2021),]
                 $species_recovery_category, "Critically Depleted")
    expect_equal(parsed_gss[which(parsed_gss$sis_id == 22697810 & parsed_gss$assessment_year == 2021),]
                 $conservation_legacy_best, "33%")
    expect_equal(parsed_gss[which(parsed_gss$sis_id == 15958 & parsed_gss$assessment_year == 2024),]
                 $conservation_legacy_minimum, "-13%")
    expect_equal(parsed_gss[which(parsed_gss$sis_id == 271005149 & parsed_gss$assessment_year == 2024),]
                 $family_name, "FELIDAE")
    expect_equal(parsed_gss[which(parsed_gss$sis_id == 271005149 & parsed_gss$assessment_year == 2024),]
                 $species, FALSE)
    expect_equal(parsed_gss[which(parsed_gss$sis_id == 15958 & parsed_gss$assessment_year == 2024),]
                 $infra_name, "nimr")

  })
})
