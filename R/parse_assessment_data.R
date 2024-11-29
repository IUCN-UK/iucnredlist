# Function to process the entire list of assessments
parse_assessment_data <- function(assessment_data) {

  processed_list <- purrr::map(assessment_data, parse_element_to_tibble)
  processed_list <- purrr::map(processed_list, flatten_tibble)
  return(processed_list)
}
