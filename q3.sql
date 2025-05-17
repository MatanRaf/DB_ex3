select name
from memberInKnesset natural join members
group by uid
having count(*) >= 5 and count(distinct party) = 1 
order by name;