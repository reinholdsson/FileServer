SELECT * FROM ANSWERS A
LEFT JOIN B ON A.VAR = B.VAR
WHERE process IN ({{process}})