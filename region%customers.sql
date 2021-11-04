USE dp05_eagle

WITH t AS
(
SELECT [District Name], d.district_id, CAST(num_inhabitants AS decimal (18,10)) AS num_inhabitants1, CAST(COUNT(*) AS decimal (18,10))AS customer_cnt,
		d.average_salary, d.num_cities, d.num_commited_crimes_1995,d.num_commited_crimes_1996, d.unemployment_rate_1995, d.unemployment_rate_1996
FROM district AS d
JOIN account2 AS a
ON a.district_id = d.district_id
GROUP BY [District Name], num_inhabitants, d.district_id, d.average_salary, d.num_cities,
		d.num_commited_crimes_1995,d.num_commited_crimes_1996, d.unemployment_rate_1995, d.unemployment_rate_1996
), x AS
(
SELECT *, (customer_cnt/ num_inhabitants1)*100 AS 'cust_sat', RANK() OVER (ORDER BY (customer_cnt/ num_inhabitants1)*100) AS rnk
FROM t
)
SELECT * 
FROM x



SELECT * FROM district
SELECT * FROM client2
SELECT * FROM account2

SELECT * FROM customer_ranking_dist
SELECT * FROM disp
SELECT * FROM client2