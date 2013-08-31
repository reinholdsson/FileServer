# get_choices <- function(config_list) {
#     res <- names(config_list)
#     names(res) <- sapply(config_list, function(x) x$title)
#     return(res)
# }

get_yaml <- function(path) {
  # check input file
  if (missing(path) || is.null(path)) {
    stop("yaml is missing")
  }
  yaml.load_file(path)
}

eval_fun <- function(x, fun) if(!is.null(x)) fun(x) else NULL

#' Start file server
#' 
#' ...
#' 
#' @param config_file config file path
#' @export
FileServer <- function(config_file, title = "FileServer", fun_label = "", button_label = "Run", ...) {
  # change work dir until exit
  wd <- getwd()
  setwd(dirname(config_file))
  on.exit(setwd(wd))
  config_list <- get_yaml(basename(config_file))
  
  runApp(
    list(
      ui = bootstrapPage(
        h1(title),
        uiOutput("fun"),
        uiOutput("desc"),
        uiOutput("form"),
        downloadButton("download", button_label)
      ),
      
      server = function(input, output, session) {
        
        query <- reactive({
           parseQueryString(session$clientData$url_search)
        })
        
        config <- reactive({
          eval_fun(input$fun_input, function(x) config_list[[x]])
        })
        
        output$desc <- renderUI({
          eval_fun(config()$desc, helpText)
        })
        
        output$fun <- renderUI({
            selectInput(
            inputId = "fun_input",
            label = fun_label,
            choices = names(config_list),
            selected = query()$q
          )
        })
        
        output$form <- renderUI({
          eval_fun(config()$form, function(x) build_form(get_yaml(x), query()))
        })
        
        output$download <- downloadHandler(
          filename = function() config()$output,
          content = function(con) {
            temp_file <- paste(tempfile(), config()$output, sep = "_")
            on.exit(unlink(temp_file))
            code <- paste(readLines(config()$file, warn = F), collapse = "\n")
            eval(parse(text = code))(input = input, output = temp_file)
            bytes <- readBin(temp_file, "raw", file.info(temp_file)$size)
            writeBin(bytes, con)
          }
        )
      }
    )
  , ...)
}