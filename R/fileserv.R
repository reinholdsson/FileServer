#read_yml <- paste(readLines(cfg()$file, warn = F), collapse = "\n")

#' Start file server
#' 
#' ...
#' 
#' @param config config file path
#' @export
fileserv <- function(config) {
  # change work dir until exit
  wd <- getwd()
  setwd(dirname(config))
  on.exit(setwd(wd))
  
  # check input file
  if (missing(config) || is.null(config)) {
    stop("config is missing")
  }
  
  conf <- yaml.load_file(config)
  
  runApp(
    list(
      ui = bootstrapPage(
        uiOutput("fun"),
        uiOutput("form"),
        downloadButton("download", "Run")
      ),
      
      server = function(input, output, session) {

        
        query <- reactive({
           parseQueryString(session$clientData$url_search)
        })
        
        cfg <- reactive({
          if(!is.null(input$fun)) {
            conf[[input$fun]]
          }
        })
        
        output$fun <- renderUI({
            selectInput(
            inputId = "fun",
            label = "Function:",
            choices = names(conf),
            selected = query()$fun
          )
        })
        
        output$form <- renderUI({
          form <- cfg()$form
          if (!is.null(form)) {
            buildForm(yaml.load_file(form), query())
          } else {
            p("No form available")
          }
        })
        
        output$download <- downloadHandler(
          filename = function() cfg()$output,
          content = function(con) {
            temp_file <- paste(tempfile(), cfg()$output, sep = "_")
            on.exit(unlink(temp_file))
            code <- paste(readLines(cfg()$file, warn = F), collapse = "\n")
            eval(parse(text = code))(input = input, output = temp_file)
            
            bytes <- readBin(temp_file, "raw", file.info(temp_file)$size)
            writeBin(bytes, con)
          }
        )
      }
    )
  )
}