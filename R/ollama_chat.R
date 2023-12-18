ollama_chat <- function(model, messages, stream = TRUE) {
    body <- list(
        model = model,
        messages = messages,
        stream = stream
    )
    
    request <- ollama_set_task("chat") %>% 
        httr2::req_body_json(data = body) 
    
    
    if (stream) {
        parser <- ChatParser$new()
        
        perform_stream(
            request = request,
            parser = parser
        )
        
        last_line <- parser$lines[[length(parser$lines)]]
        
        last_line$message <- list(
            role = "assistant",
            content = parser$value
        ) 
        
        httr2::response_json(
            url = request$url,
            method = "POST",
            body = last_line
        )
    } else {
        request %>% 
            httr2::req_perform() %>% 
            httr2::resp_body_json()
    }
}

ChatParser <- R6::R6Class(
    classname = "ChatParser",
    inherit = NDJSONparser,
    public = list(
        
        value = NULL,
        
        append_parsed_line = function(line) {
            self$value <- paste0(self$value, line$message$content)
            self$lines <- c(self$lines, list(line))
            
            invisible(self)
        },
        
        initialize = function(value = "") {
            self$value <- value
        }
    )
)
