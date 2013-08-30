function(file) {
  wb <- loadWorkbook(file, create = TRUE)
  createSheet(wb, name = "output")
  writeWorksheet(wb, mtcars, sheet = "output")
  saveWorkbook(wb)
}