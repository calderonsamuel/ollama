#' List Local Models
#'
#' List models that are available locally.
#'
#' @return A with fields `name`, `modified_at`, and `size` for each model. 
#'
#' @export
#' @examples
#' \dontrun{
#' ollama_list()
#' }
#' 
ollama_list <- function() {
    ollama_set_task("tags") %>% 
        httr2::req_perform() %>% 
        httr2::resp_body_json()
}


#' Show Model Information
#'
#' Show details about a model including modelfile, template, parameters, license, and system prompt.
#'
#' @param model Name of the model to show
#' @return A list. 
#'
#' @export
#' @examples
#' \dontrun{
#' ollama_show_model_info("llama2")
#' ollama_show_model_info("mistral")
#' }
#' 
ollama_show_model_info <- function(model) {
    body <- list(name = model)
    ollama_set_task("show") %>% 
        httr2::req_body_json(body) %>% 
        httr2::req_perform() %>% 
        httr2::resp_body_json()
}

ollama_copy_model <- function(source, destination) {
    body <- list(source = source, destination = destination)
    response <- ollama_set_task("copy") %>% 
        httr2::req_body_json(body) %>% 
        httr2::req_perform()
    
    if(httr2::resp_status(response) == 200) {
        cli::cli_alert_success("{.val {destination}} model has been added")
    }
}

ollama_delete_model <- function(model) {
    body <- list(name = model)
    response <- ollama_set_task("delete") %>% 
        httr2::req_method("DELETE") %>% 
        httr2::req_body_json(body) %>% 
        httr2::req_perform() 
    
    if(httr2::resp_status(response) == 200) {
        cli::cli_alert_success("{.val {model}} model has been deleted")
    }
}

ollama_pull_model <- function(model, stream = TRUE) {
    body <- list(name = model, stream = stream)
    
    request <- ollama_set_task("pull") %>% 
        httr2::req_body_json(body)
    
    if (stream) {
        response <- stream_pull_model(request)
    } else {
        cli::cli_alert_info("This will take some time. Be patient")
        response <- httr2::req_perform(request) 
    }
    
    if(httr2::resp_status(response) == 200) {
        cli::cli_alert_success("{.val {model}} model has been pulled")
    }
}
