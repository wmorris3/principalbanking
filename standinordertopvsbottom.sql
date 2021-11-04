USE dp05_eagle

SELECT  Transaction_Characterisation, COUNT (*) AS TOP1000cnt
FROM customer_ranking_dist AS crd
JOIN disp AS d
ON crd.account_id = d.account_id
JOIN client2 AS c
ON c.client_id = d.client_id
JOIN [order2] AS o
ON o.account_id = crd.account_id
WHERE rnk<1000
GROUP BY Transaction_Characterisation
ORDER BY TOP1000cnt DESC

SELECT  Transaction_Characterisation, COUNT (*) AS "3000-4000cnt"
FROM customer_ranking_dist AS crd
JOIN disp AS d
ON crd.account_id = d.account_id
JOIN client2 AS c
ON c.client_id = d.client_id
JOIN [order2] AS o
ON o.account_id = crd.account_id
WHERE rnk>3683 AND rnk<=4683
GROUP BY Transaction_Characterisation
ORDER BY "3000-4000cnt" DESC

SELECT * FROM customer_ranking_dist
