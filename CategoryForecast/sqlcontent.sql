SELECT b.TRANSAMOUNT AS TRANSAMOUNT,
       b.REPEATS AS REPEATS,
       b.NUMOCCURRENCES AS NUMOCCURRENCES,
       b.NEXTOCCURRENCEDATE AS NEXTOCCURRENCEDATE,
       (
           SELECT total(t.TRANSAMOUNT) 
             FROM (
                      SELECT (CASE CA.CATEGID WHEN -1 THEN SPTX.CATEGID ELSE CA.CATEGID END) AS CATEGID,
                             CA.STATUS AS STATUS,
                             CA.TRANSDATE AS TRANSDATE,
                             ( (CASE CA.CATEGID WHEN -1 THEN (CASE WHEN CA.TRANSCODE = 'Deposit' THEN SPTX.SPLITTRANSAMOUNT ELSE -SPTX.SPLITTRANSAMOUNT END) ELSE (CASE WHEN CA.TRANSCODE = 'Deposit' THEN CA.TRANSAMOUNT ELSE -CA.TRANSAMOUNT END) END) * (IFNULL(CH.CURRVALUE, 1) ) ) AS TRANSAMOUNT
                        FROM CheckingAccount AS CA
                             JOIN
                             AccountList AS acc1 ON ca.ACCOUNTID = acc1.ACCOUNTID
                             JOIN
                             CurrencyFormats AS CF ON ACC1.CURRENCYID = CF.CURRENCYID
                             LEFT JOIN
                             CurrencyHistory AS CH ON CH.CURRENCYID = CF.CURRENCYID AND 
                                                         CH.CURRDATE = (
                                                                           SELECT MAX(CRHST.CURRDATE) 
                                                                             FROM CurrencyHistory AS CRHST
                                                                            WHERE CRHST.CURRENCYID = CF.CURRENCYID
                                                                       )
                             LEFT JOIN
                             SplitTransactions AS sptx ON ca.TRANSID = sptx.TRANSID
                       WHERE CA.STATUS NOT IN ('D', 'V') AND
				CA.TRANSDATE >= date('now', 'start of year') 
                  )
                  AS t
            WHERE t.CATEGID = cat.CATEGID
       )
       AS BALANCE,
       cat.CATEGNAME AS CATEGORY
  FROM (
           SELECT (CASE BD.CATEGID WHEN -1 THEN BDSPX.CATEGID ELSE BD.CATEGID END) AS CATEGID,
                  BD.STATUS,
                  BD.REPEATS,
                  BD.NUMOCCURRENCES,
                  BD.NEXTOCCURRENCEDATE,
                  ( (CASE BD.CATEGID WHEN -1 THEN (CASE WHEN BD.TRANSCODE = 'Deposit' THEN bdSPX.SPLITTRANSAMOUNT ELSE -bdSPX.SPLITTRANSAMOUNT END) ELSE (CASE WHEN BD.TRANSCODE = 'Deposit' THEN BD.TRANSAMOUNT ELSE -BD.TRANSAMOUNT END) END) * (IFNULL(CH2.CURRVALUE, 1) ) ) AS TRANSAMOUNT
             FROM BillsDeposits AS BD
                  INNER JOIN
                  AccountList AS acc2 ON bd.accountid = acc2.accountid
                  INNER JOIN
                  CurrencyFormats AS CF2 ON ACC2.CURRENCYID = CF2.CURRENCYID
                  LEFT JOIN
                  CurrencyHistory AS CH2 ON CH2.CURRENCYID = CF2.CURRENCYID AND 
                                               CH2.CURRDATE = (
                                                                  SELECT MAX(CRHST.CURRDATE) 
                                                                    FROM CurrencyHistory AS CRHST
                                                                   WHERE CRHST.CURRENCYID = CF2.CURRENCYID
                                                              )
                  LEFT JOIN
                  BudgetSplitTransactions AS bdspx ON bd.BDID = bdspx.TRANSID
            WHERE bd.STATUS NOT IN ('D', 'V')
       )
       AS b
       INNER JOIN
       Category AS cat ON b.CATEGID = cat.CATEGID
 WHERE cat.CATEGNAME = 'Bills';
-- Convert to Base Currency from Tx Acc Currency using Curr History or Curr Conv 2 Base Rate
-- CheckingAccount also now use SplitTransactions (check CATEGID = -1)-- Billdeposits Account also now use BudgetSplitTransactions (check CATEGID = -1)