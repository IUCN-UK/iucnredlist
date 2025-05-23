% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/list_codes.R
\name{list_codes}
\alias{list_codes}
\title{List group codes}
\usage{
list_codes(api, endpoint_group)
}
\arguments{
\item{api}{An httr2 response object created with \code{init_api()}.}

\item{endpoint_group}{String. A valid API group name which can be found by calling \code{list_group_names()}.}
}
\value{
A tibble of codes or, in the case of Comprehensive Groups, names.
}
\description{
Returns a \code{tibble()} of all codes (or names) for a specified API group.
}
\examples{
\dontrun{
list_codes(api, "threats")
}
}
