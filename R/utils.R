##########################
### INTERNAL FUNCTIONS ###
##########################

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

convert_to_tibbles <- function(x) {
  if (is.list(x)) {
    if (length(x) == 0) {
      return(NA)
    }
    # Check if all elements are lists with the same names
    elem_names <- sapply(x, function(y) {
      if (is.list(y)) {
        paste(sort(names(y)), collapse = ",")
      } else {
        NA
      }
    })
    if (all(!is.na(elem_names)) && length(unique(elem_names)) == 1) {
      # All elements are lists with the same structure
      lst <- map(x, function(y) {
        y <- convert_to_tibbles(y)
        if (is.list(y) && !is.data.frame(y)) {
          # Replace NULLs and empty lists with NA
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
      df <- bind_rows(lst)
      return(df)
    } else {
      # Process each element individually
      x <- map(x, convert_to_tibbles)
      return(x)
    }
  } else {
    # If not a list, return the element as is
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


