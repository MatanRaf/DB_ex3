-- WITH RECURSIVE connections AS (
--   SELECT m.uid, m.name, 0 as distance
--   FROM members m
--   WHERE m.name = 'Menachem Begin'

--   UNION

--   SELECT mik2.uid, m2.name, c.distance + 1
--   FROM connections c
--   JOIN memberInKnesset mik1 ON mik1.uid = c.uid
--   JOIN memberInKnesset mik2 ON mik1.number = mik2.number
--   JOIN members m2 ON mik2.uid = m2.uid
--   WHERE mik2.uid != c.uid 
--     AND c.distance < 3
-- )

-- SELECT DISTINCT uid, name
-- FROM connections
-- ORDER BY name;



-- // gemini
WITH RECURSIVE KnessetConnections (mk_uid, distance, menachem_begin_uid) AS (
    -- Anchor Member: Menachem Begin himself, at distance 0
    SELECT
        m.uid AS mk_uid,
        0 AS distance,
        m.uid AS menachem_begin_uid -- Keep track of Begin's UID
    FROM
        members m
    WHERE
        m.name = 'Menachem Begin'

    UNION ALL

    -- Recursive Member: Find MKs connected to those already found, up to distance 3
    SELECT
        mik2.uid AS mk_uid,
        kc.distance + 1 AS distance,
        kc.menachem_begin_uid
    FROM
        KnessetConnections kc
    JOIN
        memberInKnesset mik1 ON kc.mk_uid = mik1.uid -- mik1 is an MK reached in the previous step
    JOIN
        memberInKnesset mik2 ON mik1.number = mik2.number AND mik1.party = mik2.party -- mik2 is connected to mik1 in the same Knesset & party
    WHERE
        mik1.uid != mik2.uid -- Ensure it's a different MK
        AND kc.distance < 3   -- Explore paths:
                              -- If kc.distance = 0, finds MKs at distance 1
                              -- If kc.distance = 1, finds MKs at distance 2
                              -- If kc.distance = 2, finds MKs at distance 3
                              -- Recursion stops before calculating distance 4 for this CTE
),
-- Collect all unique MKs that are within distance 0-3 from Menachem Begin
MKsWithinDistance3 AS (
    SELECT DISTINCT mk_uid
    FROM KnessetConnections
    -- The condition kc.distance < 3 in the CTE ensures all mk_uid here are distance 0, 1, 2, or 3
)
-- Select all members who are NOT Menachem Begin AND are NOT in the MKsWithinDistance3 set
SELECT
    m.name,
    m.uid
FROM
    members m
LEFT JOIN
    MKsWithinDistance3 m3_connected ON m.uid = m3_connected.mk_uid
WHERE
    m3_connected.mk_uid IS NULL -- This means m.uid was not found within distance 3 of Menachem Begin
    AND m.name != 'Menachem Begin'  -- Exclude Menachem Begin himself from the final list
ORDER BY
    m.uid;