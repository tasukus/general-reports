SELECT	wd_data.id				id,
	wd_data.date					AS date,
	wd_data.amount				AS amount,
	COALESCE(c.categname, '')
	||  ":" || 
	COALESCE(sc.subcategname, '')	AS cat,
	wd_data.notes				AS notes,
	p.payeename					AS payee,
	acc.accountname				AS account,
	c.PFX_SYMBOL				AS pfx_symbol,
	c.SFX_SYMBOL				AS sfx_symbol,
	c.GROUP_SEPARATOR			AS group_separator,
	c.DECIMAL_POINT				AS decimal_point
FROM (SELECT	t1.transid		AS id,
	t1.transdate				AS date,
	t2.splittransamount		AS amount,
	t2.categid				AS catid,
	t2.subcategid				AS subcatid, 
	''						AS notes,
	t1.payeeid				AS payeeid,
	t1.accountid				AS accountid
	FROM SplitTransactions AS t2
		INNER JOIN CheckingAccount AS t1	ON t1.TRANSID = t2.TRANSID
	WHERE  
	t1.transcode = "Withdrawal"
UNION ALL
SELECT	ca.transid	AS id,
	ca.transdate		AS date,
	ca.transamount	AS amount,
	ca.categid		AS catid,
	ca.subcategid		AS subcatid, 
	ca.notes			AS notes,
	ca.payeeid		AS payeeid,
	ca.accountid		AS accountid
	FROM  CheckingAccount AS ca
	WHERE  
		ca.transcode = "Withdrawal" AND ca.categid <>-1
) AS wd_data
LEFT JOIN AccountList AS acc ON wd_data.accountid = acc.accountid
LEFT JOIN CurrencyFormats AS c ON c.CURRENCYID = acc.CURRENCYID
LEFT JOIN Category AS c ON wd_data.catid=c.categid
LEFT JOIN SubCategory AS sc ON wd_data.subcatid= sc.subcategid
LEFT JOIN PayEe AS p ON wd_data.payeeid = p.payeeid
ORDER BY date ASC;