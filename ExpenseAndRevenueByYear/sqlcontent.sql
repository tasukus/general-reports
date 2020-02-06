select 
    'year' as periode_name,
    periode,
  sum(Deposit) as Deposit,
  sum(Withdrawal) as Withdrawal,
  round(sum(Deposit) + sum(Withdrawal),2) as Total,
    (SELECT sum(initialbal) FROM AccountList) as initialbal
from (  
  select 
    strftime('%Y', TRANSDATE) as periode,
    case
      when transcode = 'Deposit' then transamount
      else 0
    end as Deposit,
    case
          when transcode = 'Withdrawal' then -transamount
          else 0
    end as Withdrawal
    --,*
  from
    CheckingAccount
  where status <>'V'
)
group by periode
order by periode asc
