# load config
require(yaml)
conf <- yaml.load_file("config.yml")

# test input list (from the url parser)
input <- list(
  q = "test_query",
  rows = 5
)

# get query list
query <- conf[[input$q]]

# replace query inputs with user inputs if they exist
query$input <- sapply(names(query$input), function(x) {
  if (x %in% names(input)) {
    input[[x]]
  } else {
    query$input[[x]]
  }
})

# read function from file
fun <- eval(parse(text = paste(readLines(query$method), collapse = "\n")))

# eval function
 fun(query$input)
