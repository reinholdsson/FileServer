# R File Service

## Example

`config.yml`

```
query:
  id: comments
  method: pm_query.r
    server: pedal
    port: 8080
    template: sql/get_comments.sql
  input: 
    period: ...
    processid: ...
```

start service

```
file_service("config.yml")
```

go to the url
```
localhost/?q=comments&period=201301&processid=1;2&format=xlsx
```

