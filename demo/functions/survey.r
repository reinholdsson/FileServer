function(input, output) {
  wb <- loadWorkbook(output, create = TRUE)
  createSheet(wb, name = "output")
  writeWorksheet(wb, MASS::survey, sheet = "output")
  saveWorkbook(wb)
}