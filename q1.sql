select number, count(party) as partyCount
from memberInKnesset
group by number
order by number;