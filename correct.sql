SELECT d1.name AS n1, d2.name AS n2
FROM donors d1
JOIN donors d2 ON d1.name < d2.name
WHERE NOT EXISTS (
    SELECT 1
    FROM donors dx
    WHERE dx.name = d1.name
      AND dx.cause NOT IN (
          SELECT cause FROM donors WHERE name = d2.name
      )
)
AND NOT EXISTS (
    SELECT 1
    FROM donors dx
    WHERE dx.name = d2.name
      AND dx.cause NOT IN (
          SELECT cause FROM donors WHERE name = d1.name
      )
)
ORDER BY n1, n2;

-- //The query retrieves pairs of donors (n1, n2)
--  who have donated to the same causes. It performs a self-join on the donors 
--  table to compare each donor (d1) with every other donor (d2) where the 
--  two donated to at least one common cause (d1.cause = d2.cause) and
--   ensures that each pair is listed only once by requiring d1.name < d2.name.
--    It then groups the results by the donor names and uses a
--     HAVING clause to filter only those pairs where both donors have donated
--      to the same number of distinct causes. Finally, the results are ordered 
--      alphabetically by donor names. However, it’s important to note that the query
--       checks only if the number of causes is the same—not whether the actual sets of causes are
--        identical—so it may include pairs of donors who donated to the same number of causes but not 
--        necessarily to the exact same ones.

