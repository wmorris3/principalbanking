CREATE PROC customer_ranking_proc
(@loyalty_rnk_weight decimal (18,10), 
@tx_cnt_rnk_weight decimal (18,10), 
@balance_rnk_weight decimal (18,10), 
@goodloans_rnk_weight decimal (18,10),
@badloans_rnk_weight decimal (18,10))
AS

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
SELECT *, RANK () OVER (ORDER BY ((	loyalty_rnk * @loyalty_rnk_weight + 
									tx_cnt_rnk * @tx_cnt_rnk_weight + 
									balance_rnk * @balance_rnk_weight + 
									goodloans_rnk * @goodloans_rnk_weight +
									badloans_rnk * @badloans_rnk_weight
									))/5) AS rnk
FROM o
ORDER BY rnk ASC;


EXEC customer_ranking_proc	@loyalty_rnk_weight = 1,
							@tx_cnt_rnk_weight =1,
							@balance_rnk_weight =1,
							@goodloans_rnk_weight =1,
							@badloans_rnk_weight =1



