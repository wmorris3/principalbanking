SELECT * FROM 
client2

SELECT * FROM district

SELECT [District Name], AVG(age) AS avg_age
FROM client2 AS c
JOIN district AS d
ON c.district_id = d.district_id
WHERE [District Name] IN ('Teplice',
'Vsetin',
'Hodonin',
'Karlovy Vary',
'Jihlava')
GROUP BY  [District Name]

