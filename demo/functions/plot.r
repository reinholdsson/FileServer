function(input, output) {
  pdf(output)
  plot(1, 4, "l", main = input$Title, sub = input[["What is the subtitle?"]])
  dev.off()
}