USE dp05_eagle

SELECT account_id, rnk FROM customer_ranking_dist
ORDER BY account_id

SELECT account_id, rnk FROM customer_ranking
ORDER BY account_id


SELECT Start_date, COUNT(*) AS cnt 
FROM account2
GROUP BY Start_Date
ORDER BY Start_Date

SELECT LEFT(Start_Date,7) AS yymm, COUNT(*) AS num_accounts
FROM account2
GROUP BY LEFT(Start_Date,7)
ORDER BY LEFT(Start_Date,7)

SELECT * FROM customer_ranking_dist