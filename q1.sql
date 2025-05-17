return number, count(party) as partyCount
from memeberInKnesset
group by number
order by number;