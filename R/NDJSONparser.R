NDJSONparser <- R6::R6Class(
    classname = "NDJSONparser",
    portable = TRUE,
    public = list(
        
        lines = NULL,
        
        append_parsed_line = function(line) {
            self$lines <- c(self$lines, list(line))
            
            invisible(self)
        },
        
        parse_ndjson = function(ndjson, pagesize = 500, verbose = FALSE, simplifyDataFrame = FALSE) {
            jsonlite::stream_in(
                con = textConnection(ndjson),
                pagesize = pagesize,
                verbose = verbose,
                simplifyDataFrame = simplifyDataFrame,
                handler = function(x) lapply(x, self$append_parsed_line)
            )
            
            invisible(self)
        },
        
        initialize = function() {
            self$lines <- list()
        }
    )
)
