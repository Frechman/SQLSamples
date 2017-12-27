--https://stepik.org/lesson/50186/step/4

SELECT 
    P.name AS planet,
    PS.value AS psystem,
    --count(date),
    rank() OVER (PARTITION BY PS.value ORDER BY COUNT(date) DESC) AS local_rank,
    rank() OVER (ORDER BY COUNT(date) DESC) AS global_rank
FROM Planet P 
LEFT JOIN Flight F ON F.planet_id = P.id
JOIN PoliticalSystem PS ON PS.id = P.psystem_id
GROUP BY P.name, PS.value
;