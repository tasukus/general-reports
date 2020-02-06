/* Setup: edit line 35 for the account types required */
SELECT a.ACCOUNTNAME,
       IFNULL(CH.CURRVALUE, 1) AS CURRVALUE,-- Only use ch.currvalue for v13 DB
       c.PFX_SYMBOL,
       c.SFX_SYMBOL,
       c.DECIMAL_POINT,
       c.GROUP_SEPARATOR,
       (
           SELECT a.INITIALBAL + total(t.TRANSAMOUNT) 
             FROM (
                      SELECT c1.ACCOUNTID,
                             (CASE WHEN c1.TRANSCODE = 'Deposit' THEN c1.TRANSAMOUNT ELSE -c1.TRANSAMOUNT END) AS TRANSAMOUNT
                        FROM CheckingAccount AS c1
                       WHERE c1.STATUS NOT IN ('D', 'V') 
                      UNION ALL
                      SELECT c2.TOACCOUNTID,
                             c2.TOTRANSAMOUNT
                        FROM CheckingAccount AS c2
                       WHERE c2.TRANSCODE = 'Transfer' AND 
                             c2.STATUS NOT IN ('D', 'V') 
                  )
                  AS t
            WHERE t.ACCOUNTID = a.ACCOUNTID
       )
       AS BALANCE
  FROM AccountList AS a
       INNER JOIN
       CurrencyFormats AS c ON c.CURRENCYID = a.CURRENCYID
       LEFT JOIN
       CurrencyHistory AS CH ON CH.CURRENCYID = c.CURRENCYID AND 
                                   CH.CURRDATE = (
                                                     SELECT MAX(CRHST.CURRDATE) 
                                                       FROM CurrencyHistory AS CRHST
                                                      WHERE CRHST.CURRENCYID = c.CURRENCYID
                                                 )
 WHERE a.ACCOUNTTYPE IN ('Checking', 'Term') AND 
       a.STATUS = 'Open'
 GROUP BY a.ACCOUNTNAME
 ORDER BY a.ACCOUNTNAME ASC;
