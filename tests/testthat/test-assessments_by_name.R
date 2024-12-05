test_that("assessment_data calls perform_request and returns expected response", {
  httptest2::with_mock_dir("assessments_panthera_leo", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    result <- assessments_by_name(api, 'panthera','leo')
    expect_true(is.list(result))
    expect_length(result, 7)

    print(result)

  })
})
