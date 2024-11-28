extract_element <- function(assessments_list, element_name) {
  # Map through all elements in the list
  extracted_data <- purrr::map_dfr(seq_along(assessments_list), function(i) {
    item <- assessments_list[[i]]

    # Extract 'assessment_id' and ensure it's a character
    assessment_id <- as.character(item$assessment_id %||% NA)

    # Extract the specified element (e.g., 'stresses' or 'references')
    element_data <- item[[element_name]] %||% dplyr::tibble() # Handle missing elements

    # Add 'assessment_id' and 'index' column to the extracted tibble
    element_data <- element_data %>%
      dplyr::mutate(assessment_id = assessment_id, index = element_name) %>% # Use 'element_name' as the index
      dplyr::relocate(index, assessment_id, .before = everything()) # Place 'index' at the front

    return(element_data)
  })

  return(extracted_data)
}
