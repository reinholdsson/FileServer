# R File Service

## Example

`config.yml`

```
comments:
  file: sql/get_comments.sql
  server: pedal
  port: 8080
```

start service

```
file_server("config.yml")
```

go to the url
```
http://localhost:8100/?q=comments&top=10
```

