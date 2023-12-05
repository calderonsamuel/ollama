#' List Local Models
#'
#' List models that are available locally.
#'
#' @return A list with fields `name`, `modified_at`, and `size` for each model. 
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
#' @param name Name of the model to show
#' @return A list. 
#'
#' @export
#' @examples
#' \dontrun{
#' ollama_show_model_info("llama2")
#' ollama_show_model_info("mistral")
#' }
#' 
ollama_show_model_info <- function(name) {
    body <- list(name = name)
    ollama_set_task("show") %>% 
        httr2::req_body_json(body) %>% 
        httr2::req_perform() %>% 
        httr2::resp_body_json()
}

#' Copy a Model
#' 
#' Copy a model. Creates a model with another name from an existing model.
#' 
#' @param source Name of the existing model to copy
#' @param destination Name of the new model. Must be different from `source`.
#' 
#' @return None
#' 
#' @export
#' @examples
#' \dontrun{
#' ollama_copy_model("llama2", "llama2_backup")
#' }
#' 
ollama_copy_model <- function(source, destination) {
    body <- list(source = source, destination = destination)
    response <- ollama_set_task("copy") %>% 
        httr2::req_body_json(body) %>% 
        httr2::req_perform()
    
    if(httr2::resp_status(response) == 200) {
        cli::cli_alert_success("{.val {destination}} model has been added")
    }
}

#' Delete a Model
#' 
#' Delete a model and its data.
#' 
#' @param name Model name to delete
#' 
#' @return None
#' 
#' @export
#' @examples
#' \dontrun{
#' ollama_delete_model("llama2")
#' }
#' 
ollama_delete_model <- function(name) {
    body <- list(name = name)
    response <- ollama_set_task("delete") %>% 
        httr2::req_method("DELETE") %>% 
        httr2::req_body_json(body) %>% 
        httr2::req_perform() 
    
    if(httr2::resp_status(response) == 200) {
        cli::cli_alert_success("{.val {name}} model has been deleted")
    }
}

#' Pull a Model
#' 
#' Download a model from the ollama library. 
#' Cancelled pulls are resumed from where they left off, 
#' and multiple calls will share the same download progress.
#' 
#' @param name Name of the model to pull
#' @param insecure (optional) allow insecure connections to the library. 
#' Only use this if you are pulling from your own library during development.
#' @param stream (optional) if FALSE the response will be returned as a single 
#' response object, rather than a stream of objects
#' 
#' @return None
#' 
#' @export
#' @examples 
#' \dontrun{
#' ollama_pull_model("mistral")
#' ollama_pull_model("mistral", stream = FALSE)
#' }
ollama_pull_model <- function(name, insecure = FALSE, stream = TRUE) {
    body <- list(name = name, insecure = insecure, stream = stream)
    
    request <- ollama_set_task("pull") %>% 
        httr2::req_body_json(body)
    
    if (!stream) {
        cli::cli_alert_info("This will take some time. Be patient")
        response <- httr2::req_perform(request) 
    } else {
        response <- stream_pull_model(request)
    }
    
    if(httr2::resp_status(response) == 200) {
        cli::cli_alert_success("{.val {name}} model has been pulled")
    }
}
