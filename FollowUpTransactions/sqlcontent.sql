select t.PAYEENAME, t.TRANSDATE, t.TRANSAMOUNT
    , t.TRANSAMOUNT as BaseAmount
    , c.PFX_SYMBOL, c.SFX_SYMBOL
from
    (select p.PAYEENAME as PAYEENAME, c1.TRANSDATE as TRANSDATE, c1.STATUS as STATUS,
        (case when c1.TRANSCODE = 'Deposit' then c1.TRANSAMOUNT else -c1.TRANSAMOUNT end) as TRANSAMOUNT,
        a1.CURRENCYID as CURRENCYID
    from CheckingAccount as c1
    inner join PayEe as p on p.PAYEEID = c1.PAYEEID
    inner join AccountList as a1 on a1.ACCOUNTID = c1.ACCOUNTID
    union all
    select a2.ACCOUNTNAME, c2.TRANSDATE, c2.STATUS, c2.TOTRANSAMOUNT, a2.CURRENCYID
    from CheckingAccount as c2
    inner join AccountList as a2 on a2.ACCOUNTID = c2.TOACCOUNTID
    where TRANSCODE = 'Transfer') as t
inner join CurrencyFormats as c on t.CURRENCYID=c.CURRENCYID
where t.STATUS = 'F'
order by t.PAYEENAME asc, t.TRANSDATE asc;