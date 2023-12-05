#' Retrieve tags from a model.
#'
#' This function scrapes the Ollama library page, retrieves information
#' about available available tags for a specific model, and returns a character
#' vector with all the tag names.
#' 
#' @param name The model from which the tags will be retrieved
#'
#' @return A character vector with all the available tags.
#'
#' @examples
#' \dontrun{
#' ollama_get_tags("llama2")
#' ollama_get_tags("mistral")
#' }
#'
#' @export
ollama_get_tags <- function(name) {
    response <- httr2::request("https://ollama.ai/library") %>% 
        httr2::req_url_path_append(name) %>% 
        httr2::req_url_path_append("tags") %>% 
        httr2::req_perform() %>% 
        httr2::resp_body_html()
    
    tag_elements <- response %>% 
        rvest::html_element("body") %>% 
        rvest::html_element("main") %>% 
        rvest::html_elements("section") %>% 
        purrr::pluck(2L) %>% 
        rvest::html_children()
    
    tag_elements %>% 
        purrr::map(tag_get_wrapper) %>% 
        purrr::map_chr(tag_get_name)
}

tag_get_wrapper <- function(x) {
    x %>% 
        rvest::html_children() %>% 
        purrr::pluck(1L) %>% 
        rvest::html_element("a")
}

tag_get_name <- function(tag_wrapper) {
    tag_wrapper %>% 
        rvest::html_elements("div") %>% 
        purrr::pluck(1L) %>% 
        rvest::html_text2()
}

