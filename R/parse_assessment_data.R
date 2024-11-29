# Function to process the entire list of assessments
parse_assessment_data <- function(raw_assessment_data) {
  # Drop unnecessary data elements
  raw_assessment_data[["documentation"]] <- NULL
  raw_assessment_data$supplementary_info$conservation_actions_in_place <- NULL
  raw_assessment_data$taxon$ssc_groups[[1]]$url <- NULL
  raw_assessment_data$taxon$ssc_groups[[1]]$description <- NULL
  raw_assessment_data$taxon$species_taxa <- NULL
  raw_assessment_data$taxon$subpopulation_taxa <- NULL
  raw_assessment_data$taxon$infrarank_taxa <- NULL
  raw_assessment_data$taxon$authority <- NULL
  raw_assessment_data$taxon$common_names <- NULL
  raw_assessment_data$taxon$synonyms <- NULL

  # Reformat elements
  raw_assessment_data$taxon$ssc_groups <- raw_assessment_data$taxon$ssc_groups %>% unlist()

  processed_list <- purrr::map(raw_assessment_data, parse_element_to_tibble)
  processed_list <- purrr::map(processed_list, flatten_tibble)

  if (nrow(processed_list$stresses) > 0) {
    processed_list$stresses <- processed_list$stresses %>%
      distinct(description, code)
  }

  return(processed_list)
}
