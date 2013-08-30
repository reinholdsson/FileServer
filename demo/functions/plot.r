function(input, output) {
  pdf(output)
  plot(1, 4, "l", main = input$title, sub = input$subtitle)
  dev.off()
}