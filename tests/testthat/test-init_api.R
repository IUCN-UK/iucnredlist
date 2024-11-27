test_that("init api returns an S3 object of class <httr2_request>", {
  expect_s3_class(init_api("your_red_list_api_key"), "httr2_request")
})
