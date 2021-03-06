#' List activity in a given Databrary session for which the user has
#' ownership privileges.
#'
#' @param vol_id Selected volume number.
#' @param session_id Selected session/slot number.
#' @param vb A Boolean value. If TRUE provides verbose output.
#' @return A list with the activity history on a slot.
#' @examples
#' list_session_activity()
#' @export
list_session_activity <- function(session_id = 6256, vb = FALSE) {
  # Parameter checking----------------------------------------------
  if (length(session_id) > 1) {
    stop("session_id must have length == 1.")
  }
  if ((!is.numeric(session_id)) || session_id <= 0 ) {
    stop("session_id must be > 0.")
  }
  if (length(vb) > 1) {
    stop("vb must have length == 1.")
  }
  if (!is.logical(vb)) {
    stop("vb must be logical.")
  }
  if (vb) message('list_session_activity()...')

  # Make URL, GET(), and handle response ---------------------------

  r <- GET_db_contents(URL_components = paste0('/api/slot/', session_id,
                                               '/activity'),
                       vb = vb)
  r
}
