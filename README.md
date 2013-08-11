# R File Service

## Example

`config.yml`

```
query: comments
  function: pm_query.r
    server: pedal
    port: 8080
    template: sql/get_comments.sql
  args: 
    period: ...
    processid: ...
```

start service

```
file_service("config.yml")
```

go to the url
```
localhost/?q=comments&period=201301&processid=1;2&format=
```

