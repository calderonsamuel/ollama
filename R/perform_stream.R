perform_stream <- function(request, parser) {
    request_body <- request %>% 
        purrr::pluck("body")
    
    request_url <- request %>% 
        purrr::pluck("url")
    
    request_handle <- curl::new_handle() %>% 
        curl::handle_setopt(postfields = body_to_json_str(request_body))
    
    curl_response <- curl::curl_fetch_stream(
        url = request_url,
        handle = request_handle,
        fun = function(x) parser$parse_ndjson(rawToChar(x))
    )
    
    httr2::response_json(
        url = curl_response$url,
        method = "POST",
        body = list(response = parser$lines)
    )
}
