select a.ACCOUNTNAME,

	strftime('%m-%Y', date('now', 'start of month', '-11 month')) as date11,
	strftime('%m-%Y', date('now', 'start of month', '-10 month')) as date10,
	strftime('%m-%Y', date('now', 'start of month', '-9 month')) as date9,
	strftime('%m-%Y', date('now', 'start of month', '-8 month')) as date8,
	strftime('%m-%Y', date('now', 'start of month', '-7 month')) as date7,
	strftime('%m-%Y', date('now', 'start of month', '-6 month')) as date6,
	strftime('%m-%Y', date('now', 'start of month', '-5 month')) as date5,
	strftime('%m-%Y', date('now', 'start of month', '-4 month')) as date4,
	strftime('%m-%Y', date('now', 'start of month', '-3 month')) as date3,
	strftime('%m-%Y', date('now', 'start of month', '-2 month')) as date2,
	strftime('%m-%Y', date('now', 'start of month', '-1 month')) as date1,
	strftime('%m-%Y', date('now')) as date0,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-12 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-12 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	)  as Balance12ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-11 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-11 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	)  as Balance11ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-10 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-10 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	)  as Balance10ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-9 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-9 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	)  as Balance9ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-8 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-8 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	)  as Balance8ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-7 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-7 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	) as Balance7ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-6 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-6 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	) as Balance6ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-5 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-5 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	) as Balance5ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-4 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-4 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	) as Balance4ago,
	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-3 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-3 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	) as Balance3ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-2 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-2 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	) as Balance2ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			where  TRANSDATE < date('now', 'start of month', '-1 month')
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer' and TRANSDATE < date('now', 'start of month', '-1 month')
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	) as Balance1ago,

	(select a.INITIALBAL + total(t.TRANSAMOUNT)
		from
		(select ACCOUNTID, STATUS,
			(case when TRANSCODE = 'Deposit' then TRANSAMOUNT else -TRANSAMOUNT end) as TRANSAMOUNT
			from CheckingAccount
			union all
			select TOACCOUNTID, STATUS, TOTRANSAMOUNT 
			from CheckingAccount
			where TRANSCODE = 'Transfer'
		) as t
		where  t.ACCOUNTID = a.ACCOUNTID and t.STATUS NOT IN ('D', 'V')
	) as BalanceNow


from AccountList as a
where a.STATUS = 'Open' and a.FAVORITEACCT = 'TRUE' and BalanceNow>0
group by a.ACCOUNTNAME
order by BalanceNow desc;
