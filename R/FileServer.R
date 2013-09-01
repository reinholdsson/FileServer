#' Read yaml file
#' 
#' Read a yaml file and return it as a list
get_yaml <- function(path) {
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
#' @param title Page title
#' @param fun_label Function's select input label
#' @param button_label Download button label
#' @param ... see runApp()
#' @export
FileServer <- function(config_file, title = "File Server", fun_label = "", button_label = "Run", ...) {
  # change work dir until exit
  wd <- getwd()
  setwd(dirname(config_file))
  on.exit(setwd(wd))
  config_list <- get_yaml(basename(config_file))
  
  runApp(
    list(
      ui = pageWithSidebar(
        headerPanel(
          title
        ),
        sidebarPanel(
          uiOutput("fun"),
          uiOutput("help"),
          uiOutput("form"),
          downloadButton("download", button_label)
        ),
        mainPanel(
          tags$head(tags$script(HTML('
            Shiny.addCustomMessageHandler("jsCode",
              function(message) {
                eval(message.value);
              }
            );
          '))),
          uiOutput("readme")
        )
      ),
      
      server = function(input, output, session) {
        
        query <- reactive({
          query <- parseQueryString(session$clientData$url_search)
        })
        
        config <- reactive({
          eval_fun(input$fun_input, function(x) config_list[[x]])
        })
        
        output$help <- renderUI({
          eval_fun(config()$help, helpText)
        })
        
        output$readme <- renderUI({
          eval_fun(config()$readme, includeMarkdown)
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
        
        # Initiate download automatically
        # http://stackoverflow.com/questions/18541896
        # Thanks jdharrison!
        observe({
          if(!is.null(query()$download)){
            if(query()$download == 1){
              jsinject <- "setTimeout(function(){window.open($('#download').attr('href'))}, 5000);"
              session$sendCustomMessage(type = 'jsCode', list(value = jsinject))          
            }
          }
        })
      }
    )
  , ...)
}