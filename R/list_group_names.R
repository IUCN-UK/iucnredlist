#' Show API endpoint groups
#'
#' @description
#' Returns a list of API groups which have code/name parameters. These names can
#' be passed to `list_codes()` to get a list of codes or names for
#' an API group of interest (e.g. `list_codes(api, "threats")`)
#'
#' @returns A character vector of valid API group names.
#' @export
#' @examples
#' \dontrun{
#' list_group_names()
#' }
list_group_names <- function() {
  c(
    "biogeographical_realms",
    "comprehensive_groups",
    "conservation_actions",
    "countries",
    "faos",
    "growth_forms",
    "habitats",
    "population_trends",
    "red_list_categories",
    "research",
    "scopes",
    "stresses",
    "systems",
    "threats",
    "use_and_trade"
  )
}
