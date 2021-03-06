#' Download a specific video file.
#'
#' @param asset_id Asset number.
#' @param session_id Slot/session number.
#' @param file_name Name for downloaded file.
#' @param return_response A Boolean value.
#' @param vb A Boolean value. If TRUE provides verbose output.
#' @examples
#' download_asset()
#' @export
download_asset <- function(asset_id = 11643, session_id = 9825,
                           file_name = "test.mp4",
                           return_response = FALSE, vb = FALSE) {

  # Error handling
  if (length(asset_id) > 1) {
    stop("Asset ID must have length 1.")
  }
  if ((!is.numeric(asset_id)) || asset_id <= 0 ) {
    stop("Asset ID must be number > 0.")
  }
  if (length(session_id) > 1) {
    stop("Session ID must have length 1.")
  }
  if ((!is.numeric(session_id)) || session_id <= 0 ) {
    stop("Session ID must be number > 0.")
  }
  if (!is.character(file_name)) {
    stop("File name must be character string.")
  }

  asset_url <- paste("/slot", session_id, "-", "asset", asset_id,
                     "download", sep="/")
  url_download <- paste0("https:/nyu.databrary.org", asset_url)

  webpage <- rvest::html_session(url_download)
  if (webpage$response$status_code == 200) {
    content_type <- webpage$response$headers$`content-type`
    if (vb) {
      message("Successful HTML GET query\n")
      message(paste0("Content-type is ", content_type))
    }
    # TODO(somebody): Add support for other content types
    if (content_type == "video/mp4") {
      if (file_name == "test.mp4") {
        if (vb) {
          message("File name unspecified. Generating unique name.\n")
        }
        file_name <- paste0(session_id, "-", asset_id, "-", format(Sys.time(), "%F-%H%M-%S"), ".mp4")
      }
      if (vb) {
        message(paste0("Downloading video as ", file_name, "\n"))
      }
      utils::download.file(webpage$handle$url, file_name, mode = "wb")
    }
  } else {
    if (vb) message(paste('Download Failed, HTTP status ', webpage$response$status_code, '\n', sep="" ))
    if (return_response) return(webpage$response)
  }
}
