body_to_json_str <- function(x) {
    toJSON_params <- rlang::list2(x = x$data, !!!x$params)
    do.call(jsonlite::toJSON, toJSON_params)
}
