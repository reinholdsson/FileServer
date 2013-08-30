# R File Server

**EXPERIMENTAL**

## Example

`config.yml`

```
plot chart:
  file: functions/plot.r
  output: plot.pdf
  form: forms/plot.yml
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

Set default inputs within the url:
```
http://localhost:8100/?fun=plot%20chart&title=Plot%203&subtitle=This%20is%20a%20subtitle
```

## Todo

- Add auto-submit through url (e.g. url...?submit=1)

## See also

- [FastRWeb](http://www.rforge.net/FastRWeb/)
