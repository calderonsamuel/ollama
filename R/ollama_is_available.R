#' Check if Ollama is running
#' 
#' @param verbose Display status message?
#'
#' @return A logical value indicating if Ollama is running or not, invisible.
#' 
#' @export
#' @examples
#' ollama_is_available()
#' 
ollama_is_available <- function(verbose = FALSE) {
  request <- ollama_api_url() %>%
    httr2::request() 
  
  check_value <- logical(1)
  
  rlang::try_fetch({
    response <- httr2::req_perform(request) %>% 
      httr2::resp_body_string() 
      
    if (verbose) cli::cli_alert_success(response)
    check_value <- TRUE
    
  }, error = function(cnd) {
      
    if(inherits(cnd, "httr2_failure")) {
      if (verbose) cli::cli_alert_danger("Couldn't connect to Ollama in {.url {ollama_api_url()}}. Is it running there?")
    } else {
      if (verbose) cli::cli_alert_danger(cnd)
    }
    check_value <- FALSE
  })
  
  invisible(check_value)
}

