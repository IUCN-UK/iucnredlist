
test_that("conservation actions can be flattened to list of strings", {
  fixture <- jsonlite::fromJSON(jsonlite::toJSON(jsonlite::fromJSON('fixtures/assessment.json')))
  result <- flatten_conservation_actions(fixture$supplementary_info$conservation_actions)

  expect_equal(unname(result[1]), "In-place research and monitoring | Action Recovery Plan | Yes")
  expect_equal(unname(result[2]), "In-place research and monitoring | Systematic monitoring scheme | Yes")
  expect_equal(unname(result[3]), "In-place land/water protection | Conservation sites identified | Yes, over entire range")
  expect_equal(unname(result[4]), "In-place land/water protection | Occurs in at least one protected area | Yes")
  expect_equal(unname(result[5]), "In-place land/water protection | Invasive species control or prevention | Yes")
  expect_equal(unname(result[6]), "In-place species management | Successfully reintroduced or introduced benignly | No")
  expect_equal(unname(result[7]),  "In-place species management | Subject to ex-situ conservation | No")
  expect_equal(unname(result[8]), "In-place education | Subject to recent education and awareness programmes | No")
  expect_equal(unname(result[9]), "In-place education | Included in international legislation | Yes")
  expect_equal(unname(result[10]), "In-place education | Subject to any international management / trade controls | No")
})
