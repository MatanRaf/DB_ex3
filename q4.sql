select number, party, count(*) as memberCount
from memberInKnesset mik
group by number, party
having count(*) >= ALL (select count(*) 
    from memberInKnesset mik1 
    where mik.number = mik1.number
    group by party) 
order by number, party