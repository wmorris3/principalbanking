
WITH t AS
(
SELECT *,  LEFT(birth_number,2) AS year, 
	CASE 
		WHEN SUBSTRING(CAST(birth_number AS varchar(10)),3,2) >12 THEN SUBSTRING(CAST(birth_number AS varchar(10)),3,2) -50
		WHEN SUBSTRING(CAST(birth_number AS varchar(10)),3,2) <=12 THEN SUBSTRING(CAST(birth_number AS varchar(10)),3,2)
		END AS [month],
	RIGHT(birth_number,2) AS day,
	CASE 
		WHEN SUBSTRING(CAST(birth_number AS varchar(10)),3,2) >12 THEN  0
		WHEN SUBSTRING(CAST(birth_number AS varchar(10)),3,2) <=12 THEN  1
		END AS male
FROM client
), 
x AS
(
SELECT t.client_id, t.district_id, t.male,
	CAST (CONCAT(19,t.year,'-',t.month, '-',t.day) AS date) AS DOB
	
FROM t
) 
SELECT * , DATEDIFF(year, x.DOB, '1998-12-31') AS age



