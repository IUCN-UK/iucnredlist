test_that("assessments_by_taxonomy calls perform_request and returns expected response", {
  httptest2::with_mock_dir("assessments_by_taxonomy_family_felidae", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    result <- assessments_by_taxonomy(api,
                                      level = "family",
                                      name = "felidae",
                                      latest = TRUE,
                                      scope_code = 1
    )

    expect_true(is.list(result))
    expect_length(result, 7)

    expect_equal(names(result), c("sis_taxon_id","assessment_id","latest","year_published","scopes_description_en","scopes_code","url"))
    expect_length(unique(result$assessment_id), 39)
  })
})
