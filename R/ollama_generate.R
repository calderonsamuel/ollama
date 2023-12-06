ollama_generate <- function(model, prompt, stream = TRUE) {
    body <- list(
        model = model,
        prompt = prompt,
        stream = stream
    )
    
    request <- ollama_set_task("generate") %>% 
        httr2::req_body_json(data = body) 
    
    response <- NULL
    
    if(stream) {
        response <- stream_generate(request)
    } else {
        response <- httr2::req_perform(request) 
    }
    
    response %>% 
        httr2::resp_body_json() %>% 
        purrr::pluck("response") %>%
        stringr::str_trim(side = "left")
}

stream_generate <- function(request) {
    request_body <- request %>% 
        purrr::pluck("body")
    
    request_url <- request %>% 
        purrr::pluck("url")
    
    request_handle <- curl::new_handle() %>% 
        curl::handle_setopt(postfields = body_to_json_str(request_body))
    
    buffer <- StreamBuffer$new()
    
    curl_response <- curl::curl_fetch_stream(
        url = request_url,
        handle = request_handle,
        fun = function(x) stream_generate_callback(x, buffer)
    )
    
    httr2::response_json(
        url = curl_response$url,
        method = "POST",
        body = list(response = buffer$value)
    )
}

stream_generate_callback <- function(x, StreamBuffer) {
    stream <- rawToChar(x)
    
    jsonlite::stream_in(
        con = textConnection(stream),
        verbose = FALSE,
        simplifyDataFrame = FALSE,
        handler = function(x) stream_generate_chunk_callback(x, StreamBuffer)
    )
}

stream_generate_chunk_callback <- function(x, StreamBuffer) {
    purrr::walk(x, function(chunk) {
        StreamBuffer$append(chunk$response)
    })
}

StreamBuffer <- R6::R6Class(
    classname = "StreamBuffer",
    public = list(
        value = NULL,
        append = function(text) {
            self$value <- paste0(self$value, text)
            invisible(self)
        },
        initialize = function(value = "") {
            self$value <- value
        },
        print = function() {
            print(self$value)
        }
    )
)
