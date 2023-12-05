#' Retrieve information from the Ollama AI library.
#'
#' This function scrapes the Ollama library page, retrieves information
#' about available models, and returns a tibble with details such as model name,
#' description, number of pulls, number of tags, and last update.
#'
#' @return A tibble with information about models in the Ollama AI library.
#'
#' @examples
#' \dontrun{
#' ollama_get_library()
#' }
#'
#' @export
ollama_get_library <- function() {
    response <- httr2::request("https://ollama.ai/library") %>% 
        httr2::req_url_query(sort = "popular") %>% 
        httr2::req_perform()
    
    model_elements <- response %>% 
        httr2::resp_body_html() %>% 
        rvest::html_element("body") %>% 
        rvest::html_element("main") %>% 
        rvest::html_element('ul[role="list"]') %>% 
        rvest::html_children()
    
    model_elements %>% 
        purrr::map(model_get_info) %>% 
        purrr::list_rbind()
}


model_get_name <- function(x) {
    x %>% 
        rvest::html_element("a") %>% 
        rvest::html_element("h2") %>% 
        rvest::html_text2()
}

model_get_description <- function(x) {
    p_tags <- x %>% 
        rvest::html_element("a") %>% 
        rvest::html_elements("p") 
    
    if (length(p_tags) < 2) {
        return("")
    } else {
        p_tags %>% 
            purrr::pluck(1L) %>% 
            rvest::html_text2()
    }
}

model_get_metadata <- function(x) {
    p_tags <- x %>% 
        rvest::html_element("a") %>% 
        rvest::html_elements("p") 
    
    p_tags %>% 
        purrr::pluck(length(p_tags)) %>% 
        rvest::html_elements("span") %>% 
        purrr::map(rvest::html_text2) %>% 
        purrr::set_names(nm = c("n_pulls", "n_tags", "last_update"))
}

model_get_info <- function(x) {
    name <- model_get_name(x)
    description <- model_get_description(x)
    metadata <- model_get_metadata(x)
    
    tibble::tibble(
        name = name,
        description = description,
        n_pulls = metadata$n_pulls,
        n_tags = metadata$n_tags,
        last_update = metadata$last_update
    )
}
