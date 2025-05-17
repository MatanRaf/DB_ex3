select name
from memberInKnesset natural join members
group by uid, name
having count(number) >= 5 and count(distinct party) = 1 
order by name;