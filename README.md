# R File Service

**EXPERIMENTAL**

## Example

`config.yml`

```
plot chart:
  file: functions/plot.r
  output: plot.pdf
mtcars dataset:
  file: functions/mtcars.r
  output: mtcars.xlsx
survey dataset:
  file: functions/survey.r
  output: survey.xlsx
```

start service

```
library(fileserv)
fileserv("config.yml")
```
