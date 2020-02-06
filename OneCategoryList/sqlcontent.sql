/*select c.categid, c.categname, s.subcategid, s.subcategname from Category c
left join SubCategory s on s.categid=c.categid
order by c.categname, s.subcategname*/
SELECT 
c.transid AS Nr
, c.transdate as Date
, case ifnull(c.categid, -1) when -1 then s.categid else c.categid end categ_id
, case ifnull(c.subcategid, -1) when -1 then s.subcategid else c.subcategid end subcateg_id
,  (case ifnull(s.splittransid, -1) when -1 then c.transamount else s.splittransamount end)
    *(case c.transcode when 'Deposit' then 1 else -1 end) as Amount
,  (case ifnull(s.splittransid, -1) when -1 then c.transamount else s.splittransamount end)
    *(case c.transcode when 'Deposit' then 1 else -1 end) *1 as BaseAmount
, curr.PFX_SYMBOL, curr.SFX_SYMBOL
, ac.ACCOUNTNAME
, p.payeename
, c.notes as Notes
, i.infovalue AS COLOR
, (SELECT GROUP_CONCAT(t.FileName) AS TagList
    FROM CheckingAccount AS a
     LEFT JOIN Attachment AS at
       ON at.RefId = a.TransId
     LEFT JOIN Attachment AS t
       ON t.AttachmentId = at.AttachmentId
    where a.transid = c.transid
    GROUP BY a.transid) AS Files
FROM CheckingAccount C
    LEFT JOIN PayEe p ON p.payeeid=c.payeeid 
    INNER JOIN AccountList AC ON C.accountid = AC.accountid
    INNER JOIN CurrencyFormats CURR ON AC.currencyid = CURR.currencyid
    LEFT JOIN SplitTransactions s ON s.transid=c.transid
    LEFT JOIN infotable i ON i.INFONAME = 'USER_COLOR'||c.followupid
where categ_id=1 /*category ID*/ and subcateg_id=1 /*subcategory ID*/

ORDER BY c.transdate desc
