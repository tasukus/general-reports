SELECT AccountList.ACCOUNTNAME, AccountList.CREDITLIMIT as CreditLimit, AccountList.INTERESTRATE as InterestRate
    , AccountList.INITIALBAL + total(transactions.TRANSAMOUNT) as Balance
    , ROUND( (AccountList.CREDITLIMIT + AccountList.INITIALBAL + total(transactions.TRANSAMOUNT)), 2) as AvailableCredit
    , C.PFX_SYMBOL AS PFX_SYMBOL, C.SFX_SYMBOL AS SFX_SYMBOL, C.GROUP_SEPARATOR AS GROUP_SEPARATOR, C.DECIMAL_POINT AS DECIMAL_POINT
    , IFNULL(CH.CURRVALUE, 1) AS CURRVALUE
FROM
	(
		SELECT
			CA1.ACCOUNTID, CA1.TRANSDATE, CA1.STATUS, 
			(case when CA1.TRANSCODE='Deposit' then CA1.TRANSAMOUNT else -CA1.TRANSAMOUNT end) as TRANSAMOUNT
		FROM
			CheckingAccount AS CA1
		UNION ALL
		SELECT
			CA2.TOACCOUNTID as ACCOUNTID, CA2.TRANSDATE, CA2.STATUS, CA2.TOTRANSAMOUNT
		FROM
			CheckingAccount AS CA2
		WHERE
			CA2.TRANSCODE = 'Transfer'
	) as transactions
INNER JOIN AccountList on AccountList.ACCOUNTID = transactions.ACCOUNTID
INNER JOIN CurrencyFormats as c on AccountList.CURRENCYID=c.CURRENCYID
LEFT JOIN CurrencyHistory AS CH ON CH.CURRENCYID = c.CURRENCYID AND 
	                     CH.CURRDATE = (
                                                    SELECT	MAX(CRHST.CURRDATE) 
                                                      FROM	CurrencyHistory AS CRHST
                                                     WHERE	CRHST.CURRENCYID = c.CURRENCYID
                                                )
WHERE transactions.STATUS NOT IN ('V','D')
AND AccountList.ACCOUNTTYPE = "Credit Card"
AND AccountList.STATUS <> "Closed"
GROUP BY AccountList.ACCOUNTID
ORDER BY AccountList.INTERESTRATE DESC