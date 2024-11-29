# Function to process the entire list of assessments
parse_assessment_data <- function(raw_assessment_data) {

  # Drop unnecessary data elements
  raw_assessment_data[["documentation"]] <- NULL
  raw_assessment_data$supplementary_info$conservation_actions_in_place <- NULL
  raw_assessment_data$taxon$species_taxa <- NULL
  raw_assessment_data$taxon$subpopulation_taxa <- NULL
  raw_assessment_data$taxon$infrarank_taxa <- NULL
  raw_assessment_data$taxon$authority <- NULL

  common_names<-list_to_tibble(raw_assessment_data$taxon$common_names)
  ssc_groups<-list_to_tibble(raw_assessment_data$taxon$ssc_groups)
  synonyms<-list_to_tibble(raw_assessment_data$taxon$synonyms)

  # Delete from raw response for subsequent parsing and flattening
  raw_assessment_data$taxon$common_names <- NULL
  raw_assessment_data$taxon$ssc_groups <- NULL
  raw_assessment_data$taxon$synonyms <- NULL

  processed_list <- purrr::map(raw_assessment_data, parse_element_to_tibble)
  processed_list <- purrr::map(processed_list, flatten_tibble)

  if (nrow(processed_list$stresses) > 0) {
    processed_list$stresses <- processed_list$stresses %>%
      dplyr::distinct(description, code)
  }

  processed_list$taxon_common_names <- common_names
  processed_list$taxon_ssc_groups <- ssc_groups
  processed_list$taxon_synonyms <- synonyms

  processed_list <- processed_list[sort(names(processed_list))]


  return(processed_list)
}
