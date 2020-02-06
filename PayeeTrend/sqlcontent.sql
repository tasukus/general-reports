-- TODO: Update payee name in line 26. 
select strftime('%Y', t.TRANSDATE) as YEAR
    , total(case when '01' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Jan
    , total(case when '02' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Feb
    , total(case when '03' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Mar
    , total(case when '04' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Apr
    , total(case when '05' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as May
    , total(case when '06' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Jun
    , total(case when '07' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Jul
    , total(case when '08' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Aug
    , total(case when '09' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Sep
    , total(case when '10' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Oct
    , total(case when '11' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Nov
    , total(case when '12' = strftime('%m', t.TRANSDATE) then t.TRANSAMOUNT * IFNULL(CH.CURRVALUE, 1) else 0 end) as Dec
    , p.PAYEENAME AS PAYEENAME
from CheckingAccount as t
inner join AccountList as a on a.ACCOUNTID = t.ACCOUNTID
inner join CurrencyFormats as c on c.CURRENCYID = a.CURRENCYID
inner join  PayEe as p on t.PAYEEID = p.PAYEEID
LEFT JOIN CurrencyHistory AS CH ON CH.CURRENCYID = c.CURRENCYID AND 
									CH.CURRDATE = (
                                                    SELECT	MAX(CRHST.CURRDATE) 
                                                      FROM	CurrencyHistory AS CRHST
                                                     WHERE	CRHST.CURRENCYID = c.CURRENCYID
                                                )
where p.PAYEENAME = 'Payee1'
    and t.TRANSCODE='Withdrawal'
    and t.STATUS NOT IN ('D', 'V')
group by year
order by year desc;
