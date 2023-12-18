ollama_generate <- function(model, prompt, stream = TRUE) {
    body <- list(
        model = model,
        prompt = prompt,
        stream = stream
    )
    
    request <- ollama_set_task("generate") %>% 
        httr2::req_body_json(data = body) 
    
    if (stream) {
        parser <- GenerateParser$new()
        
        perform_stream(
            request = request,
            parser = parser
        )
        
        last_line <- parser$lines[[length(parser$lines)]]
        
        last_line$response <- parser$value
        
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

GenerateParser <- R6::R6Class(
    classname = "GenerateParser",
    inherit = NDJSONparser,
    public = list(
        
        value = NULL,
        
        append_parsed_line = function(line) {
            self$value <- paste0(self$value, line$response)
            self$lines <- c(self$lines, list(line))
            
            invisible(self)
        },
        
        initialize = function(value = "") {
            self$value <- value
        }
    )
)
