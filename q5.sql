select party, number, (select count(*) 
from (memberInKnesset natural join members) m1
where mik.number = m1.number and mik.party = m1.party and gender = 'female') / count(*) * 100 as femalePercent
from memberInKnesset mik
group by number, party
having count(*)*0.3 <= (select count(*) 
from (memberInKnesset natural join members) m1
where mik.number = m1.number and mik.party = m1.party and gender = female) 
order by number, party