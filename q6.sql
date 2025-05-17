WITH RECURSIVE KnessetConnections (mk_uid, distance, menachem_begin_uid) AS (
    SELECT
        m.uid AS mk_uid,
        0 AS distance,
        m.uid AS menachem_begin_uid
    FROM
        members m
    WHERE
        m.name = 'Menachem Begin'

    UNION ALL

    SELECT
        mik2.uid AS mk_uid,
        kc.distance + 1 AS distance,
        kc.menachem_begin_uid
    FROM
        KnessetConnections kc
    JOIN
        memberInKnesset mik1 ON kc.mk_uid = mik1.uid 
    JOIN
        memberInKnesset mik2 ON mik1.number = mik2.number AND mik1.party = mik2.party 
    WHERE
        mik1.uid != mik2.uid
        AND kc.distance < 3 
),
MKsWithinDistance3 AS (
    SELECT DISTINCT mk_uid
    FROM KnessetConnections
)
SELECT
    m.uid,
    m.name
FROM
    members m
LEFT JOIN
    MKsWithinDistance3 m3_connected ON m.uid = m3_connected.mk_uid
WHERE
    m3_connected.mk_uid IS NULL
    AND m.name != 'Menachem Begin' 
ORDER BY
    m.uid;