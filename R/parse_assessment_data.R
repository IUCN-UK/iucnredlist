# Function to process the entire list of assessments
parse_assessment_data <- function(raw_assessment_data) {

  # Drop unnecessary data elements
  raw_assessment_data[["documentation"]] <- NULL
  raw_assessment_data$taxon$ssc_groups[[1]]$url <- NULL
  raw_assessment_data$taxon$ssc_groups[[1]]$description <- NULL
  raw_assessment_data$taxon$ssc_groups<-raw_assessment_data$taxon$ssc_groups %>% unlist()


  processed_list <- purrr::map(raw_assessment_data, parse_element_to_tibble)
  # processed_list <- purrr::map(processed_list, flatten_tibble)
  return(processed_list)
}
