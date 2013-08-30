# get_ext <- function(str) {
#   x <- str_extract_all(str, "\\[(\\w*)\\]")
#   x <- gsub("\\[", "", x)
#   x <- gsub("\\]", "", x)
#   return(x)
# }

#' Start file server
#' 
#' ...
#' 
#' @param config config file path
#' @export
fileserv <- function(config) {
  
  # check input file
  if (missing(config) || is.null(config)) {
    stop("config is missing")
  }
  
  conf <- yaml.load_file(config)
  
  runApp(
    list(
      ui = bootstrapPage(
        selectInput(
          inputId = "query",
          label = "Query:",
          choices = names(conf)
        ),
        downloadButton("download", "Download data")
      ),
      
      server = function(input, output, session) {
        cfg <- reactive({
          conf[[input$query]]
        })
        
        output$download <- downloadHandler(
          filename = function() cfg()$output,
          content = function(con) {
            temp_file <- paste(tempfile(), cfg()$output, sep = "_")
            on.exit(unlink(temp_file))
            code <- paste(readLines(cfg()$file, warn = F), collapse = "\n")
            eval(parse(text = code))(temp_file)
            
            bytes <- readBin(temp_file, "raw", file.info(temp_file)$size)
            writeBin(bytes, con)
          }
        )
      }
    )
  )
}