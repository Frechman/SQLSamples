--https://stepik.org/lesson/50174/step/3

SELECT SUM(q)::BIGINT
FROM (
    SELECT COUNT(Planet.id) q
    FROM Planet
    WHERE galaxy = 2

UNION

    SELECT MAX(cnt) q
    FROM (
        SELECT COUNT(1) cnt
        FROM Flight F
        JOIN Planet P ON F.planet_id = P.id
        WHERE P.galaxy = 2
        GROUP BY P.id) AS Tmp
) AS Rslt;