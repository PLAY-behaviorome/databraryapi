#' Downloads session spreadsheet as a CSV.
#'
#' @param type Type of Databrary report to run "institutions", "people", "data"
#' @param vb A Boolean value. If TRUE provides verbose output.
#' @return A tibble (data.frame) with the requested data.
#' @examples get_db_stats()
#' @examples get_db_stats("stats")
#' @examples get_db_stats("people")
#' @examples get_db_stats("places")
#' @export
get_db_stats <- function(type = "stats", vb = FALSE) {
  # Error handling
  if (length(type) > 1) {
    stop("type must have length == 1.")
  }
  if (!is.character(type)) {
    stop("'type' must be character.")
  }
  if (!(type %in% c("institutions", "places", "people", "datasets", "volumes", "stats", "numbers"))){
    stop("Type '", type, "' not valid.")
  }
  if (length(vb) > 1) {
    stop("vb must have length == 1.")
  }
  if (!is.logical(vb)) {
    stop("vb must have logical value.")
  }

  r <- GET_db_contents(URL_components = '/api/activity')
  if (is.null(r)) {
    message("No content returned.")
    r <- NULL
  } else {
    if (type == "people") {
      d <- tibble::as_tibble(r$activity$party)
      if (!is.null(d)) {
        d <- dplyr::filter(d, !is.na(id), !is.na(affiliation), !is.na(sortname), !is.na(prename))
      } else {
        d <- NULL
      }
    }
    if (type %in% c("institutions", "places")) {
      d <- tibble::as_tibble(r$activity$party)
      if ("institution" %in% names(d)) {
        d <- dplyr::filter(d, !is.na(id), !is.na(institution))
      } else {
        d <- NULL # No new institutions
      }
    }
    if (type %in% c("datasets", "volumes")) {
      d <- tibble::as_tibble(r$activity$volume)
      if (!is.null(d)) {
        d <- dplyr::filter(d, !is.na(id))
      } else {
        d <- NULL
      }
    }
    if (type %in% c("stats", "numbers")) {
      d <- data.frame(date = Sys.time(),
                      investigators = r$stats$authorized[5],
                      affiliates = r$stats$authorized[4],
                      institutions = r$stats$authorized[6],
                      datasets_total = r$stats$volumes,
                      datasets_shared = r$stats$shared,
                      n_files = r$stats$assets,
                      hours = r$stats$duration/(1000*60*60),
                      TB = r$stats$bytes/(1e12)) # seems incorrect
    }
  }
  return(d)
}
