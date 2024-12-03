test_that("assessment_by_group performs a request and returns expected response", {
  httptest2::with_mock_dir("assessment_by_group_scopes_100765562", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    result <- assessments_by_group(api, 'scopes', 100765562, wait_time = 0)

    expect_true(is.list(result))
    expect_equal(dim(result), c(58, 7))

    expect_equal(names(result), c('sis_taxon_id', 'assessment_id', 'latest', 'year_published', 'scopes_description_en', 'scopes_code', 'url'))

    expect_equal(result[1,]$sis_taxon_id, 39371)
    expect_equal(result[1,]$assessment_id, 109876922)
    expect_equal(result[1,]$latest, TRUE)
    expect_equal(result[1,]$year_published, '2017')
    expect_equal(result[1,]$scopes_description_en, 'Global')
    expect_equal(result[1,]$scopes_code, '1')
    expect_equal(result[1,]$url, 'https://www.iucnredlist.org/species/39371/109876922')

    expect_equal(result[2,]$sis_taxon_id, 39371)
    expect_equal(result[2,]$assessment_id, 109876922)
    expect_equal(result[2,]$latest, TRUE)
    expect_equal(result[2,]$year_published, '2017')
    expect_equal(result[2,]$scopes_description_en, 'Arabian Sea')
    expect_equal(result[2,]$scopes_code, '100765562')
    expect_equal(result[2,]$url, 'https://www.iucnredlist.org/species/39371/109876922')
  })
})
