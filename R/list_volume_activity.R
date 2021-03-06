#' List activity in a given Databrary volume.
#'
#' @param vol_id Selected volume number.
#' @param vb A Boolean value. If TRUE provides verbose output.
#' @return A list with the activity history on a volume.
#' @examples
#' list_volume_activity()
#' @export
list_volume_activity <- function(vol_id = 1, vb = FALSE) {
  # Parameter checking----------------------------------------------
  if (length(vol_id) > 1) {
    stop("vol_id must have length == 1.")
  }
  if ((!is.numeric(vol_id)) || vol_id <= 0 ) {
    stop("vol_id must be > 0.")
  }
  if (length(vb) > 1) {
    stop("vb must have length == 1.")
  }
  if (!is.logical(vb)) {
    stop("vb must be logical.")
  }
  if (vb) message('list_volume_activity()...')

  # Make URL, GET(), and handle response ---------------------------

  r <- GET_db_contents(URL_components = paste0('/api/volume/', vol_id,
                                               '/activity'),
                       vb = vb)
  r
}
