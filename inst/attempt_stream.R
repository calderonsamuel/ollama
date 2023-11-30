stream_pull_model <- function(request) {
    request_body <- request %>% 
        purrr::pluck("body")
    
    request_url <- request %>% 
        purrr::pluck("url")
    
    request_handle <- curl::new_handle() %>% 
        curl::handle_setopt(postfields = body_to_json_str(request_body))
    
    buffer <- list(status = glue::glue("Starting pull of codellama"))
    cli::cli_alert_info(buffer$status)
    # the progress bar is not being used currently, but remains for compatibility
    buffer_progress_bar <- cli::cli_progress_bar(
        name = "Pulling {request_body$name}", 
        type = "download"
    )
    
    curl_response <- curl::curl_fetch_stream(
        url = request_url,
        handle = request_handle,
        fun = stream_pull_model_callback
    )
    
    httr2::response(
        url = curl_response$url,
        method = "POST"
    )
}


stream_pull_model_callback <- function(x) {
    stream <- rawToChar(x)
    # cat(stream)
    
    # container <- list()

    jsonlite::stream_in(
        textConnection(stream),
        verbose = FALSE,
        handler = function(x) {
            # container <<- c(container, list(x))
            stream_pull_model_chunk_callback(x, buffer, buffer_progress_bar)
        }
    )

    # container %>%
    #     purrr::walk(~chunk_callback(.x, buffer, buffer_progress_bar))
    
}

stream_pull_model_chunk_callback <- function(chunk, buffer, progress_bar) {
    # For some reason some chunks have length > 1
    if (any(chunk$status != buffer$status)) cli::cli_alert_info(chunk$status[1])
    
    # if (!rlang::is_empty(chunk$total)) {
    #     cli::cli_progress_update(
    #         id = progress_bar,
    #         set = chunk$completed[1],
    #         total = chunk$total[1]
    #     )
    # }
    # 
    # if(rlang::is_empty(chunk$total) && !rlang::is_empty(buffer$total)) {
    #     cli::cli_progress_done(id = progress_bar)
    # }
    
    buffer <<- chunk
}
