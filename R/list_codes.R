#' List group codes
#'
#' @description
#' Returns a `tibble()` of all codes (or names) for a specified API group.
#'
#' @param api An httr2 response object created with `init_api()`.
#' @param endpoint_group String. A valid API group name which can be found by calling `list_group_names()`.
#' @returns A tibble of codes or, in the case of Comprehensive Groups, names.
#' @export
#' @examples
#' \dontrun{
#' list_codes(api, "threats")
#' }
#' @export
#'
list_codes <- function(api, endpoint_group) {
  req_final <- api %>%
    httr2::req_url_path_append(endpoint_group)

  response <- httr2::req_perform(req_final)
  response_json <- httr2::resp_body_json(response)

  endpoint_data <- response_json[[1]]

  data_tibble <- purrr::map_dfr(endpoint_data, function(item) {
    fields <- names(item)
    tibble_row <- purrr::map(fields, function(field) {
      value <- item[[field]]

      if (is.list(value)) {
        if (!is.null(names(value))) {
          value <- value[[1]]
        } else {
          value <- paste(unlist(value), collapse = ", ")
        }
      }

      if (is.null(value)) NA else value
    })

    dplyr::tibble(!!!rlang::set_names(tibble_row, fields))
  })

  return(data_tibble)
}
