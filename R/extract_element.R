#' Extract data from a named element
#' @importFrom dplyr %>%
#'
#' @description This is a helper function to return a tidy `tibble()` for a
#' specified element name. Here, an 'element name' is one of the named tibbles
#' created when running `parse_assessement_data()` or `assessment_data_many()`.
#'
#' To get a list of valid element names that you can concatenate with `extract_element()`
#' first call `element_names()`. Pass one of these names to `extract_element()` to
#' create a tidy `tibble()` of that specific data.
#'
#' @param assessments_list A list containing full assessment data.
#' @param element_name String.

#' @returns Returns a tidy `tibble()` of data for the specified element name.
#' @export
#' @examples
#' \dontrun{
#' extract_element(assessments_list, "habitats")
#' extract_element(assessments_list, "biogeographical_realms")
#' extract_element(assessments_list, "taxon_synonyms")
#' extract_element(assessments_list, "threats")
#' }

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
