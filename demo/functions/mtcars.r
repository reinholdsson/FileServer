function(input, output) {
  wb <- loadWorkbook(output, create = TRUE)
  createSheet(wb, name = "output")
  writeWorksheet(wb, mtcars, sheet = "output")
  saveWorkbook(wb)
}