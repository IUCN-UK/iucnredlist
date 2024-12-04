#' Show element names
#'
#' @description
#' Returns a vector of element names which can be passed to `extract_element()`
#' to concatenate data from a large list of assessment data.
#'
#' @returns A character vector of valid element names.
#' @export
#' @examples
#' \dontrun{
#' list_group_names()
#' }

element_names <- function(){
  c(
    "assessment_date",
    "assessment_id",
    "assessment_points",
    "assessment_ranges",
    "biogeographical_realms",
    "citation",
    "conservation_actions",
    "conservation_actions_in_place",
    "credits",
    "criteria",
    "errata",
    "faos",
    "growth_forms",
    "habitats",
    "latest",
    "lmes",
    "locations",
    "population_trend",
    "possibly_extinct",
    "possibly_extinct_in_the_wild",
    "red_list_category",
    "references",
    "researches",
    "scopes",
    "sis_taxon_id",
    "stresses",
    "supplementary_info",
    "systems",
    "taxon",
    "taxon_common_names",
    "taxon_ssc_groups",
    "taxon_synonyms",
    "threats",
    "url",
    "use_and_trade",
    "year_published"
  )

}
