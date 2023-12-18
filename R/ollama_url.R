ollama_api_url <- function() {
    Sys.getenv("OLLAMA_HOST", "http://localhost:11434")
}

ollama_set_task <- function(task) {
    ollama_api_url() %>%
        httr2::request() %>%
        httr2::req_url_path_append("api") %>% 
        httr2::req_url_path_append(task)
}

ollama_check_running <- function() {
    request <- ollama_api_url() %>%
        httr2::request() 
    
    rlang::try_fetch({
        httr2::req_perform(request) %>% 
            httr2::resp_body_string() 
    }, error = function(cnd) {
        if(inherits(cnd, "httr2_failure")) {
            cli::cli_abort("Couldn't connect to Ollama in {.url {ollama_api_url()}}. Is it running there?", parent = cnd)
        } else {
            cnd
        }
    })
    return(TRUE)
}
