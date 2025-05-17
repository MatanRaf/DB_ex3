select distinct number, avg(startYear-birthYear) as avgAge
from memberInKnesset natural join members natural join knessets
group by number
order by number;