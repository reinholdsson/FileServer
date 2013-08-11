function(input) {
  data <- head(MASS::survey, input$rows)
  data <- data[c(1:input$cols)]
  return(data)
}
