ollama_api_url <- function() {
    "http://localhost:11434/api"
}

ollama_set_task <- function(task) {
    ollama_api_url() %>%
        httr2::request() %>% 
        httr2::req_url_path_append(task)
}
