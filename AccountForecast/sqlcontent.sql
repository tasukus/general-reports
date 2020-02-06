-- TODO: Update account name in line 25. 
select b.TRANSAMOUNT, b.REPEATS, b.NUMOCCURRENCES, b.NEXTOCCURRENCEDATE, c.PFX_SYMBOL, c.SFX_SYMBOL, c.DECIMAL_POINT, c.GROUP_SEPARATOR,
    (select a.INITIALBAL + total(t.TRANSAMOUNT)
    from
        (select ACCOUNTID, STATUS,
            (case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
        from CheckingAccount
        union all
        select TOACCOUNTID, STATUS, TOTRANSAMOUNT
        from CheckingAccount
        where TRANSCODE = 'Transfer') as t
    where  t.ACCOUNTID = a.ACCOUNTID
        and t.STATUS NOT IN ('V','D')) as Balance, a.ACCOUNTNAME as ACCOUNTNAME
from 
    (select ACCOUNTID, STATUS, REPEATS, NUMOCCURRENCES, NEXTOCCURRENCEDATE,
        (case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
    from BillsDeposits
    union all
    select TOACCOUNTID, STATUS, REPEATS, NUMOCCURRENCES, NEXTOCCURRENCEDATE, TOTRANSAMOUNT
    from BillsDeposits
    where TRANSCODE = 'Transfer') as b
inner join AccountList as a on b.ACCOUNTID = a.ACCOUNTID
inner join CurrencyFormats as c on c.CURRENCYID = a.CURRENCYID
where b.STATUS NOT IN ('V','D')
and a.ACCOUNTNAME = 'Account1';