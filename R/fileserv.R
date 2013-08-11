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
  
  # start shiny app
  runApp(
    list(
      ui = bootstrapPage(
        h3("URL components"),
        verbatimTextOutput("urlText"),
       
        h3("Parsed query string"),
        verbatimTextOutput("queryText"),
        
        h3("Download data"),
        downloadButton("csv", "csv"),
        downloadButton("xlsx", "xlsx")
      ),
      
      server = function(input, output, session) {
        
        output$csv <- downloadHandler(
          filename = 'test.csv',
          content = function(con) {
            write.csv2(data(), con)
          }
        )
        
        output$xlsx <- downloadHandler(
          filename = 'test.xlsx',
          content = function(con) {
            temp <- paste0(tempfile(), ".xlsx")
            on.exit(unlink(temp))
            
            wb <- loadWorkbook(temp, create = TRUE)
            createSheet(wb, name = "output")
            writeWorksheet(wb, data(), sheet = "output")
            saveWorkbook(wb)
            
            bytes <- readBin(temp, "raw", file.info(temp)$size)
            writeBin(bytes, con)
          }
        )
        
        data <- reactive({
          print(paste("Get data with query:", sql()))
          
          # TODO: GET DATA FROM DATABASE
          data <- MASS::survey  # temp
          
          return(data)
        })
        
        sql <- reactive({
          
          # get url query
          query <- parseQueryString(session$clientData$url_search)
          
#         query <- sapply(query, function(x) {
#           strsplit(x, ";")
#         })
          
          # get local config
          conf <- yaml.load_file(config)
          
          # get local sql
          file <- conf[[query$q]]$file
          sql <- paste(readLines(file, warn = F), collapse = "\n")
          sql <- whisker.render(sql, query)
          
          return(sql)
      })
       
        # Return the components of the URL in a string:
        output$urlText <- renderText({
          session$clientData$url_search
        })
       
        # Parse the GET query string
        output$queryText <- renderText({
          str <- sql()
          paste(str)
        })
      }
    )
  )
}