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
