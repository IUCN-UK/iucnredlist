#' Get full assessment data for a vector of assessment IDs
#' @importFrom dplyr %>%
#'
#' @description This function wraps around `assessment_data()` and allows the return of full assessment
#' data for an arbitrary number of assessment IDs.
#'
#'
#' @param api An httr2 response object created with init_api()
#' @param assessment_ids Vector. A vector of valid assessment IDs
#' @param wait_time Time in seconds to wait between API calls. A wait of 0.5 seconds or greater will ensure you
#' won't hit the IUCN Red List API rate limit.
#' @returns A list of full assessment data. Each element in the list corresponds to a unique assessment_id passed
#' to the function via the argument assessment_ids
#' @examples
#' \dontrun{
#' assessment_data_many(api, assessment_ids = c(123, 456), wait_time = 0.5)
#' }
assessment_data_many <- function(api, assessment_ids, wait_time = 0.5) {
  # Initialize an empty list to store results
  results_list <- list()

  # Ensure list of assessment_ids is unique to prevent unnecessary calls to the API
  assessment_ids <- unique(assessment_ids)

  if (wait_time < 0.5) {
    cli::cli_alert_warning(paste0("Waiting for ", wait_time, " seconds between API calls."))
    cli::cli_alert_warning(paste0("This is a short wait time and could result in your API token being rate limited."))
    cli::cli_alert_warning(paste0("Please consider increasing your wait time to >=0.5 seconds between calls to maintain service reliablity for all."))
  } else {
    cli::cli_alert_success(paste0("Waiting for ", wait_time, " second(s) between API calls. Thanks for using the API responsibly!"))
  }

  cli::cli_alert_info(paste0("You are processing ", length(assessment_ids), " assessment IDs."))

  # Short wait outside loop so users have time to read CLI output
  Sys.sleep(3)

  start <- Sys.time()

  pb <- cli::cli_progress_bar(
    format = "Progress: {cli::pb_bar} {cli::pb_percent} | ETA: {cli::pb_eta}",
    total = length(assessment_ids),
    clear = TRUE
  )

  for (i in seq_along(assessment_ids)) {
    results_list[[i]] <- assessment_data(api, assessment_ids[i])
    cli::cli_progress_update(pb, set = i)
    Sys.sleep(wait_time)
  }

  cli::cli_progress_done(pb)

  end <- Sys.time()

  cli::cli_alert_success(paste0("Assessment data finished downloading in ", round(difftime(end, start, units = "secs"), 2), " seconds."))

  # Return the list of results
  return(results_list)
}
