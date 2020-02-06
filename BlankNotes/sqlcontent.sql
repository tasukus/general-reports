SELECT IFNULL(CH.CURRVALUE, 1) AS CURRRATE,
    t.TRANSID,
       t.TRANSDATE,
       a.ACCOUNTNAME,
       p.PAYEENAME,
       t.NOTES,
       ((CASE t.TRANSCODE WHEN 'Deposit' THEN t.TRANSAMOUNT ELSE -t.TRANSAMOUNT END) * (IFNULL(CH.CURRVALUE, 1))) AS TRANSAMOUNT,
       m.PFX_SYMBOL,
       m.SFX_SYMBOL,
       m.GROUP_SEPARATOR,
       m.DECIMAL_POINT
  FROM CheckingAccount AS t
       JOIN
       PayEe AS p ON p.PAYEEID = t.PAYEEID
       JOIN
       AccountList AS a ON a.ACCOUNTID = t.ACCOUNTID
       JOIN
       CurrencyFormats AS m ON m.CURRENCYID = a.CURRENCYID
       LEFT JOIN
       CurrencyHistory AS CH ON CH.CURRENCYID = m.CURRENCYID AND 
                                   CH.CURRDATE = (
                                                     SELECT MAX(CRHST.CURRDATE) 
                                                       FROM CurrencyHistory AS CRHST
                                                      WHERE CRHST.CURRENCYID = m.CURRENCYID
                                                 )
 WHERE t.NOTES="";
/* For v13 DB
- remove the _V1 from the tablenames
- remove the m.BASECONVRATE and ISNULL checks on CH.CURRVALUE
*/