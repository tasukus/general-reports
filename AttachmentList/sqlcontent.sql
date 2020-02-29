SELECT A.reftype AS Type, A.refid AS Nr,
C.StartDate||' | '||C.AssetName||' | '
||(SELECT pfx_symbol FROM CurrencyFormats WHERE currencyid = (SELECT infovalue FROM infotable WHERE INFONAME = 'BASECURRENCYID') )
||round(C.Value, 2)
||(SELECT sfx_symbol FROM CurrencyFormats WHERE currencyid = (SELECT infovalue FROM infotable WHERE INFONAME = 'BASECURRENCYID') ) AS Reference,
A.description AS Description, A.filename AS File,
(SELECT infovalue FROM infotable WHERE infoname = 'ATTACHMENTSFOLDER:Win' COLLATE NOCASE) AS BasePath,
'\'||A.reftype||'\'||A.filename AS FilePath, '' AS BasepathLUA
FROM Attachment A INNER JOIN assets C ON C.assetid = A.refid
WHERE A.reftype = "Asset"

UNION ALL

SELECT A.reftype AS Type, A.refid AS Nr,
C.AccountType||' | '||C.AccountName AS Reference,
A.description AS Description, A.filename AS File,
(SELECT infovalue FROM infotable WHERE infoname = 'ATTACHMENTSFOLDER:Win' COLLATE NOCASE) AS BasePath,
'\'||A.reftype||'\'||A.filename AS FilePath, '' AS BasepathLUA
FROM Attachment A INNER JOIN AccountList C ON C.accountid = A.refid
WHERE A.reftype = "BankAccount"

UNION ALL

SELECT A.reftype AS Type, A.refid AS Nr,
AC.AccountName||' | '|| CURR.pfx_symbol||round(C.Transamount, 2) ||CURR.sfx_symbol ||' | Next ->'|| C.nextoccurrencedate AS Reference,
A.description AS Description, A.filename AS File,
(SELECT infovalue FROM infotable WHERE infoname = 'ATTACHMENTSFOLDER:Win' COLLATE NOCASE) AS BasePath,
'\'||A.reftype||'\'||A.filename AS FilePath, '' AS BasepathLUA
FROM Attachment A
    INNER JOIN BillsDeposits C ON C.bdid = A.refid
    INNER JOIN AccountList AC ON C.accountid = AC.accountid
    INNER JOIN CurrencyFormats CURR ON AC.currencyid = CURR.currencyid
WHERE A.reftype = "RepeatingTransaction"

UNION ALL

SELECT A.reftype AS Type, A.refid AS Nr, C.PayeeName AS Reference, A.description AS Description, A.filename AS File,
(SELECT infovalue FROM infotable WHERE infoname = 'ATTACHMENTSFOLDER:Win' COLLATE NOCASE) AS BasePath,
'\'||A.reftype||'\'||A.filename AS FilePath, '' AS BasepathLUA
FROM Attachment A INNER JOIN PayEe C ON C.payeeid = A.refid
WHERE A.reftype = "Payee"

UNION ALL

SELECT A.reftype AS Type, A.refid AS Nr,
C.PurchaseDate||' | '||C.StockName||' - '||C.Symbol||' | '||C.NumShares||' | '
||(SELECT pfx_symbol FROM CurrencyFormats WHERE currencyid = (SELECT infovalue FROM infotable WHERE INFONAME = 'BASECURRENCYID') )
||round(C.PurchasePrice, 2)
||(SELECT sfx_symbol FROM CurrencyFormats WHERE currencyid = (SELECT infovalue FROM infotable WHERE INFONAME = 'BASECURRENCYID') ) AS Reference,
A.description AS Description, A.filename AS File,
(SELECT infovalue FROM infotable WHERE infoname = 'ATTACHMENTSFOLDER:Win' COLLATE NOCASE) AS BasePath,
'\'||A.reftype||'\'||A.filename AS FilePath, '' AS BasepathLUA
FROM Attachment A INNER JOIN Stock C ON C.stockid = A.refid
WHERE A.reftype = "Stock"

UNION ALL

SELECT A.reftype AS Type, A.refid AS Nr,
C.transdate||' | '||AC.AccountName||' | '|| CURR.pfx_symbol||round(C.Transamount, 2) ||CURR.sfx_symbol AS Reference,
A.description AS Description, A.filename AS File,
(SELECT infovalue FROM infotable WHERE infoname = 'ATTACHMENTSFOLDER:Win' COLLATE NOCASE) AS BasePath,
'\'||A.reftype||'\'||A.filename AS FilePath, '' AS BasepathLUA
FROM Attachment A
    INNER JOIN CheckingAccount C ON C.transid = A.refid
    INNER JOIN AccountList AC ON C.accountid = AC.accountid
    INNER JOIN CurrencyFormats CURR ON AC.currencyid = CURR.currencyid
WHERE A.reftype = "Transaction"

ORDER BY A.reftype, A.refid,A.filename