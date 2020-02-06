select c.transid, c.transdate, c.notes
    , 'ERROR' as Account
    , 'OK' as category
    ,  p.PayeeName as Payee
    from CheckingAccount c
    inner join PayEe p on p.payeeid=c.payeeid
    where c.accountid not in (select accountid from AccountList)
union all
select c.transid, c.transdate, c.notes
    , 'ERROR' as Account
    , 'OK' as category
    ,  '' as Payee
    from CheckingAccount c
    where c.transcode ='Transfer' and c.toaccountid not in (select accountid from AccountList)
union all
select c.transid, c.transdate, c.notes
    , a.AccountName
    , 'OK' 
    ,  'ERROR' 
    from CheckingAccount c
      inner join AccountList a on a.accountid=c.accountid
    where c.payeeid not in (select payeeid from PayEe) and transcode!='Transfer'
union all
select c.transid, c.transdate, c.notes
     , a.AccountName
    , 'ERROR'
    ,  p.PayeeName
    from CheckingAccount c
      inner join PayEe p on p.payeeid=c.payeeid
      inner join AccountList a on a.accountid=c.accountid
    where c.categid=-1 and c.transid not in (select transid from SplitTransactions)
union all
select c.transid, c.transdate, c.notes
     , a.AccountName
    , 'ERROR'
    ,  p.PayeeName
    from CheckingAccount c
      inner join PayEe p on p.payeeid=c.payeeid
      inner join AccountList a on a.accountid=c.accountid
    where c.categid > 0 and c.categid not in (select categid from Category)
union all
select c.transid, c.transdate, c.notes
     , a.AccountName
    , 'ERROR'
    ,  p.PayeeName
    from CheckingAccount c
      inner join PayEe p on p.payeeid=c.payeeid
      inner join AccountList a on a.accountid=c.accountid
    where c.categid > 0 and c.subcategid > 0 and c.subcategid not in (select subcategid from SubCategory)
union all
select c.transid, c.transdate, c.notes
     , a.AccountName
    , 'ERROR'
    ,  p.PayeeName
    from CheckingAccount c
      inner join PayEe p on p.payeeid=c.payeeid
      inner join AccountList a on a.accountid=c.accountid
      inner join SplitTransactions s on c.transid=s.transid
    where s.categid > 0 and s.subcategid > 0 and s.subcategid not in (select subcategid from SubCategory)
union all
select c.transid, c.transdate, c.notes
     , a.AccountName
    , 'ERROR'
    ,  p.PayeeName
    from CheckingAccount c
      inner join PayEe p on p.payeeid=c.payeeid
      inner join AccountList a on a.accountid=c.accountid
      inner join SplitTransactions s on c.transid=s.transid
    where s.categid > 0  and s.categid not in (select categid from Category)
