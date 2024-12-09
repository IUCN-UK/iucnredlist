test_that("test rl version returns two named elements in a list", {
  httptest2::with_mock_dir("rl_version", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)
    ver <- rl_version(api)
    expect_named(ver, c("api_version", "red_list_version"))
  })
})
