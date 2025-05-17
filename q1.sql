select number, count(distinct party) as partyCount
from memberInKnesset
group by number
order by number;