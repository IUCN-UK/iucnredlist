# Function to process the entire list of assessments
parse_assessment_data <- function(raw_assessment_data) {

  # Drop unnecessary data elements
  raw_assessment_data[["documentation"]] <- NULL
  raw_assessment_data$supplementary_info$conservation_actions_in_place <- NULL
  raw_assessment_data$taxon$species_taxa <- NULL
  raw_assessment_data$taxon$subpopulation_taxa <- NULL
  raw_assessment_data$taxon$infrarank_taxa <- NULL
  raw_assessment_data$taxon$authority <- NULL

  # Extract Common Names into tibble
  common_names<-raw_assessment_data$taxon$common_names %>%
    purrr::map_dfr(., ~ tibble::tibble(
      main = .x$main,
      name = .x$name,
      language = .x$language
    ))

  # Extract SSC Groups into tibble
  ssc_groups <- raw_assessment_data$taxon$ssc_groups %>%
    purrr::map_dfr(., ~ tibble::tibble(
      name = .x$name,
      url = .x$url,
      description = .x$description
    ))

  # Extract Synonyms into tibble
  synonyms <- raw_assessment_data$taxon$synonyms %>%
    purrr::map_dfr(., ~ tibble::tibble(
      name = .x$name,
      status = .x$status,
      genus_name = .x$genus_name,
      species_name = .x$species_name,
      species_author = .x$species_author,
      infrarank_author = .x$infrarank_author,
      subpopulation_name = .x$subpopulation_name,
      infra_type = .x$infra_type,
      infra_name = .x$infra_name


    ))

  # Delete from raw response for parsing and flattening
  raw_assessment_data$taxon$common_names <- NULL
  raw_assessment_data$taxon$ssc_groups <- NULL
  raw_assessment_data$taxon$synonyms <- NULL

  # Reformat elements
  raw_assessment_data$taxon$ssc_groups <- raw_assessment_data$taxon$ssc_groups %>% unlist()

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
