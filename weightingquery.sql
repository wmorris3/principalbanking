USE dp05_eagle

WITH t AS
(
	SELECT COUNT(*) AS cnt_trans, t.account_id, MIN(t.date) AS mindate, MAX(t.date) AS maxdate, t2.balance, l.amount AS good_amt, l2.amount AS bad_amt
	FROM trans AS t LEFT JOIN (
								SELECT * 
								FROM (
										SELECT account_id,RANK() OVER (PARTITION BY account_id ORDER BY date DESC) AS date_rnk, date, Balance
										FROM trans2
										GROUP BY account_id,date, Balance
									) AS p
								WHERE date_rnk = 1
						)AS t2
	ON t.account_id = t2.account_id
	LEFT JOIN loan AS l
	ON l.account_id = t.account_id AND (l.[status] = 'A' OR l.[status] = 'C')
	LEFT JOIN loan AS l2
	ON l2.account_id = t.account_id AND (l2.[status] = 'B' OR l2.[status] = 'D')
	GROUP BY t.account_id, t2.balance,l.amount,l2.amount
), x AS
(
SELECT *, CAST(DATEDIFF(day, t.mindate,t.maxdate) AS decimal (18,10)) AS period
FROM t
), y AS
(
SELECT *, CAST((x.cnt_trans/ x.period) AS decimal (18,10)) AS loyalty_proxy
FROM x
), o AS 
(
SELECT *, RANK() OVER (ORDER BY loyalty_proxy DESC) AS loyalty_rnk
		, RANK() OVER (ORDER BY cnt_trans DESC) AS tx_cnt_rnk
		, RANK() OVER (ORDER BY balance DESC) AS balance_rnk
		, RANK() OVER (ORDER BY good_amt DESC) AS goodloans_rnk
		, RANK() OVER (ORDER BY bad_amt ASC) AS badloans_rnk
FROM y
) 
SELECT *, RANK () OVER (ORDER BY ((	loyalty_rnk * 0.8 + 
									tx_cnt_rnk * 0.75  + 
									balance_rnk * 2 + 
									goodloans_rnk * 2 +
									badloans_rnk * 1
									))/5) AS rnk
FROM o
ORDER BY rnk ASC


SELECT * FROM customer_ranking_dist



SELECT * FROM card



SELECT d.[district_id], [District Name], [region], [num_inhabitants], [num_municipalities<499], [num_municipalities500-1999], [num_municipalities2000-9999], 
[num_municipalities>10000], [num_cities], [urban_inhabitants_ratio], [average_salary], [unemployment_rate_1995], [unemployment_rate_1996],
[num_entrepreneurs_per1000inhab], [num_commited_crimes_1995], [num_commited_crimes_1996], [cnt_trans], c.[account_id], [mindate], [maxdate], 
[balance], [good_amt], [bad_amt], [period], [loyalty_proxy], [loyalty_rnk], [tx_cnt_rnk], [balance_rnk], [goodloans_rnk], [badloans_rnk], [rnk]
FROM customer_ranking as c
INNER JOIN account as a
ON a.account_id = c.account_id
INNER JOIN district as d
ON d.district_id = a.district_id


SELECT COALESCE(ca.type, 'No_card') as type, AVG(rnk) as Avg_rnk
FROM customer_ranking as c
FULL OUTER JOIN disp as d
ON d.account_id = c.account_id
FULL OUTER JOIN card as ca
ON ca.disp_id = d.disp_id
GROUP BY ca.type
ORDER BY Avg_rnk