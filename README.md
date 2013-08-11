# R File Service

**EXPERIMENTAL**

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
http://localhost:8100/?q=comments&top=10&process=1,3
http://localhost:8100/?q=comments&top=10&process='ÅP','BT','PP'
```

# TODO

- Security (e.q. that the user could pass sql code within the query)
  - Escape characters
  - Set read-only on the database (enough?)

