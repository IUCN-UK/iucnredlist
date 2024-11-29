##########################
### INTERNAL FUNCTIONS ###
##########################

# Function to process the entire list of assessments
parse_assessment_data <- function(response_list) {

  processed_list <- purrr::map(response_list, convert_to_tibbles)

  x<-map(processed_list, ~ {
    if (is_tibble(.x)) {
      tryCatch({
        flatten_nested_tibble(.x)
      }, error = function(e) {
        message("Error processing tibble: ", conditionMessage(e))
        .x # Return the original tibble for inspection
      })
    } else {
      .x # Leave non-tibble elements untouched
    }
  })

  return(x)

}

parse_assessment_data2 <- function(response_list) {
  processed_list <- purrr::map(response_list, parse_element_to_tibble)
  # processed_list <- purrr::map(processed_list, flatten_tibble)
  return(processed_list)
}

# Internal. Function to get paginated data
fetch_paginated_data <- function(req, url, query_params, wait_time) {
  all_data <- list()

  while (!is.null(url) && !is.na(url)) {
    # Make sure the URL is valid before making the request
    if (is.character(url) && length(url) == 1 && !is.na(url)) {
      response_page <- req %>%
        httr2::req_url(url) %>%
        httr2::req_url_query(!!!query_params) %>%
        httr2::req_perform()

      Sys.sleep(wait_time)

      response_json <- httr2::resp_body_json(response_page)
      endpoint_data <- response_json$assessments %||% list()

      if (length(endpoint_data) > 0) {
        page_data <- purrr::map_dfr(endpoint_data, possibly(unnest_scopes, otherwise = tibble()))
        all_data <- append(all_data, list(page_data))
      }

      headers <- httr2::resp_headers(response_page)
      url <- stringr::str_match(headers$link, "<([^>]+)>;\\s*rel=\"next\"")[2] %||% NULL
    } else {
      url <- NULL
    }

    query_params$page <- query_params$page + 1
  }

  bind_rows(all_data)
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








convert_to_tibbles <- function(x) {
  if (is.list(x)) {
    if (length(x) == 0) {
      return(NA)
    }
    elem_names <- sapply(x, function(y) {
      if (is.list(y)) {
        paste(sort(names(y)), collapse = ",")
      } else {
        NA
      }
    })
    if (all(!is.na(elem_names)) && length(unique(elem_names)) == 1) {
      lst <- map(x, function(y) {
        y <- convert_to_tibbles(y)
        if (is.list(y) && !is.data.frame(y)) {
          y <- map(y, function(z) {
            if (is.null(z) || (is.list(z) && length(z) == 0)) {
              NA
            } else {
              z
            }
          })
          y <- as_tibble(y)
        }
        return(y)
      })

      # Bind rows with column size compatibility handling
      max_size <- max(sapply(lst, nrow))
      lst <- map(lst, ~{
        if (nrow(.) < max_size) {
          . <- dplyr::bind_rows(., tibble::tibble(rep(NA, max_size - nrow(.))))
        }
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
  .
      })

      df <- bind_rows(lst)
      return(df)
    } else {
      x <- map(x, convert_to_tibbles)
      return(x)
    }
  } else {
    return(x)
  }
}

flatten_nested_tibble <- function(data) {
  data %>%
    mutate(across(everything(), ~ {
      if (is.list(.x)) {
        map_chr(.x, ~ {
          if (is.null(.x)) {
            NA_character_ # Handle NULL values
          } else if (is.atomic(.x)) {
            toString(.x) # Convert atomic values to string
          } else if (is.list(.x) && length(.x) == 1) {
            # Unpack single-element named lists
            unlist(.x, use.names = FALSE)
          } else if (is.list(.x)) {
            # Handle multi-element or nested named lists
            if (all(names(.x) != "")) {
              # If it's a named list, convert to key-value string
              paste(paste(names(.x), .x, sep = ":"), collapse = "; ")
            } else {
              # Otherwise, collapse as a plain list
              paste(sapply(.x, toString), collapse = "; ")
            }
          } else {
            as.character(.x) # Fallback for other types
          }
        })
      } else {
        as.character(.x) # Coerce non-list elements to character
      }
    }))
}



