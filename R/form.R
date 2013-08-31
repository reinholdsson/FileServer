
listNodes <- function(lst) {
    sapply(lst, function(x) if (is.list(x)) names(x) else x)
}

#' Build form
#' 
#' ...
#' 
#' @export
build_form <- function(inputs, query) {
    sapply(names(inputs), function(i) {
        choices <- inputs[[i]]
        if (is.null(choices)) {
            textInput(i, i, query[[i]])
        } else if (length(choices) <= 3) {
            radioButtons(i, i, listNodes(choices), query[[i]])
        } else {
            selectInput(i, i, listNodes(choices), query[[i]])
        }
    })
}
