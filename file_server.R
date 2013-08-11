file_server <- function(config) {
  
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
        verbatimTextOutput("queryText")
      ),
      
      server = function(input, output, session) {
        get_sql <- reactive({
          
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
          paste(sep = "",
            "protocol: ", session$clientData$url_protocol, "\n",
            "hostname: ", session$clientData$url_hostname, "\n",
            "pathname: ", session$clientData$url_pathname, "\n",
            "port: ",     session$clientData$url_port,     "\n",
            "search: ",   session$clientData$url_search,   "\n"
          )
        })
       
        # Parse the GET query string
        output$queryText <- renderText({
          str <- get_sql()
          print(str)
          paste(str)
        })
      }
    )
  )
}