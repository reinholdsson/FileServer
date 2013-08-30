function(file) {
  wb <- loadWorkbook(file, create = TRUE)
  createSheet(wb, name = "output")
  writeWorksheet(wb, MASS::survey, sheet = "output")
  saveWorkbook(wb)
}