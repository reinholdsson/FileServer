.formLabels <- list(
    inputs = "inputs",
    inputId = "inputId",
    label = "label",
    choices = "choices"
)

listNodes <- function(lst) {
    sapply(lst, function(x) if (is.list(x)) names(x) else x)
}

#' Build form
#' 
#' ...
#' 
#' @export
buildForm <- function(formList) {
    sapply(formList[[.formLabels$inputs]], function(i) {
        id <- i[[.formLabels$inputId]]
        lbl <- i[[.formLabels$label]]
        ch <- i[[.formLabels$choices]]
        
        if (is.null(id)) id <- lbl

        if (is.null(ch)) {
            textInput(id, lbl)
        } else if (length(ch) <= 3) {
            radioButtons(id, lbl, listNodes(ch))
        } else {
            selectInput(id, lbl, listNodes(ch))
        }
    })
}
