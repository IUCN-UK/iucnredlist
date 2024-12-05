`%||%` <- rlang::`%||%`

##########################
### INTERNAL FUNCTIONS ###
##########################

perform_request <- function(api, endpoint_request, query_params = c()) {
  url <- paste0("https://api.iucnredlist.org/api/v4/", endpoint_request)

  tryCatch(
    api |> httr2::req_url(url) |>
      httr2::req_url_query(!!!query_params) |>
      httr2::req_perform(),
    httr2_http_401 = function(error) {
      rlang::abort("Error 401: Unauthorized. This error may occur if your Red List API token was copied incorrectly. You can retrieve your API token at https://api.iucnredlist.org/users/edit\n")
    },
    httr2_http_error = function(error) {
      error_message <- paste0("HTTP Error: ", error$message)
      rlang::abort(error_message)
    },
    error = function(error) {
      rlang::abort(paste("An unexpected error occurred:", error$message))
    }
  )
}

# Internal. Function to get paginated data
fetch_paginated_data <- function(req, endpoint_request, query_params, wait_time = 0.5) {
  all_data <- list()

  while (!is.null(endpoint_request) && !is.na(endpoint_request)) {
    # Make sure the URL is valid before making the request
    if (is.character(endpoint_request) && length(endpoint_request) == 1 && !is.na(endpoint_request)) {
      response_page <- perform_request(api, endpoint_request, query_params)
      Sys.sleep(wait_time)
      response_json <- httr2::resp_body_json(response_page)
      endpoint_data <- response_json$assessments %||% list()

      if (length(endpoint_data) > 0) {
        page_data <- purrr::map_dfr(endpoint_data, purrr::possibly(unnest_scopes, otherwise = dplyr::tibble()))
        all_data <- append(all_data, list(page_data))
      }

      headers <- httr2::resp_headers(response_page)
      endpoint_request <- stringr::str_match(headers$link, "<([^>]+)>;\\s*rel=\"next\"")[2] %||% NULL
      endpoint_request <- sub("https://api.example.org/api/v4/", "", endpoint_request) %||% NULL
    } else {
      endpoint_request <- NULL
    }

    query_params$page <- query_params$page + 1
  }

  dplyr::bind_rows(all_data)
}

# Function to process and flatten nested elements within the parsed data
flatten_tibble <- function(tibble_data) {
  # Check for list columns and flatten them, converting to character explicitly
  tibble_data %>%
    dplyr::mutate(dplyr::across(tidyselect::where(is.list), ~ purrr::map_chr(.x, ~ {
      if (length(.x) == 0) {
        NA_character_
      } else {
        as.character(.x[[1]])
      }
    })))
}

# Function to process each element in list and returns a tibble for each element
# It handles different data types like atomic vectors, lists
# and more complex structures returned by the assessment endpoint
parse_element_to_tibble <- function(element) {
  if (is.null(element)) {
    return(dplyr::tibble())
  } else if (is.atomic(element) || is.character(element)) {
    # For atomic vectors (e.g., chr, int, logi), return a single-row tibble
    return(dplyr::tibble(value = element))
  } else if (is.list(element)) {
    # For lists, recursively process and combine into a tibble
    if (length(element) == 0) {
      return(dplyr::tibble())
    }

    # If list elements are named, convert to tibble
    if (!is.null(names(element))) {
      return(dplyr::as_tibble(purrr::map(element, ~ ifelse(is.null(.x), NA, .x))))
    } else {
      # If list elements are not named, process each element
      return(purrr::map_dfr(element, ~ parse_element_to_tibble(.x)))
    }
  } else {
    return(dplyr::as_tibble(element))
  }
}

# Function to unnest scopes into separate rows
unnest_scopes <- function(item) {
  if (!is.null(item$scopes) && length(item$scopes) > 0) {
    scopes <- item$scopes
    item$scopes <- NULL
    flat_item <- flatten_nested_list(item)

    purrr::map_dfr(scopes, function(scope) {
      tibble_row <- dplyr::tibble(!!!flat_item)
      tibble_row %>%
        dplyr::mutate(
          scopes_description_en = scope$description$en %||% NA_character_,
          scopes_code = scope$code %||% NA_character_
        )
    })
  } else {
    dplyr::tibble(!!!flatten_nested_list(item))
  }
}

# Internal. Function to flatten nested lists
flatten_nested_list <- function(x, parent_key = "") {
  flat_list <- list()

  purrr::walk2(names(x), x, function(key, value) {
    current_key <- ifelse(key == "", paste0(parent_key, "_", seq_along(x)), paste0(parent_key, "_", key))

    if (is.list(value)) {
      flat_list <<- c(flat_list, flatten_nested_list(value, current_key))
    } else {
      flat_list[[current_key]] <<- value
    }
  })

  return(flat_list)
}

# Converts a list into a nice tibble
list_to_tibble <- function(input_list) {
  purrr::map_dfr(input_list, ~ {
    # Replace NULL with NA and ensure all elements are vectorized
    cleaned_list <- purrr::map(.x, ~ {
      if (is.null(.x)) {
        NA
      } else if (is.atomic(.x)) {
        .x
      } else {
        as.character(.x) # Coerce non-atomic structures to character
      }
    })
    tibble::as_tibble(cleaned_list)
  })
}

nested_list_to_tibble <- function(input_list) {
  # Map over the main list and process each element
  purrr::map_dfr(input_list, function(item) {
    # Extract the top-level name
    top_name <- item$name
    # Extract and expand the actions
    actions <- purrr::map_dfr(item$actions, function(action) {
      tibble::tibble(
        actions_name = action$name,
        actions_value = action$value
      )
    })

    # Combine the top-level name with expanded actions
    actions %>%
      dplyr::mutate(name = top_name)
  })
}
