#' Get full assessment data for a vector of assessment IDs
#'
#' @description This function wraps around `assessment_data()` and allows the return of full assessment
#' data for an arbitrary number of assessment IDs.
#'
#'
#' @param api An httr2 response object created with init_api()
#' @param assessment_ids Vector. A vector of valid assessment IDs
#' @param wait_time Time in seconds to wait between API calls. A wait of 0.5 seconds or greater will ensure you
#' won't hit the IUCN Red List API rate limit.
#' @param silent Logical. If FALSE (default) then the status of each API call will be printed to the R console.
#' @returns A list of full assessment data. Each element in the list corresponds to a unique assessment_id passed
#' to the function via the argument assessment_ids
#' @examples
#' assessment_data_many(api, assessment_ids = c(123, 456), wait_time = 0.5, silent = FALSE)
assessment_data_many <- function(api, assessment_ids, wait_time = 1, silent = FALSE) {
  # Initialize an empty list to store results
  results_list <- list()

  # Ensure list of assessment_ids is unique to prevent unnecessary calls to the API
  assessment_ids <- unique(assessment_ids)

  if (wait_time < 0.5) {
    cli::cli_alert_danger(paste0("Waiting for ", wait_time, " seconds between API calls.
                                This is a short wait time and could result in your API token being rate limited.
                                Please consider increasing your wait time to >=0.5 seconds between calls to maintain service reliablity for all."))
  } else {
    cli::cli_alert_success(paste0("Waiting for ", wait_time, " second(s) between API calls. Thanks for using the API responsibly!"))
  }

  cli::cli_alert_info(paste0("You are processing ", length(assessment_ids), " assessment IDs."))

  # Short wait outside loop so users have time to read CLI output
  Sys.sleep(3)

  for (i in seq_along(assessment_ids)) {
    # Fetch and process the data for this assessment ID
    results_list[[i]] <- assessment_data(api, assessment_ids[i])
    if (silent == FALSE) {
      print(paste("Processed assessment ID:", assessment_ids[i]))
    }
    Sys.sleep(wait_time)
  }

  cli::cli_alert_success(paste0("Assessment data finished downloading in ", round(difftime(end, start, units = "secs"), 2), " seconds."))

  # Return the list of results
  return(results_list)
}
