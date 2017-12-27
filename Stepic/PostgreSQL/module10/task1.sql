--https://stepik.org/lesson/57264/step/2

WITH bar AS (
    SELECT tag, count AS count
    FROM (
           SELECT (each(wiki)).key as tag, COUNT(*)
           FROM planet
           WHERE wiki @> 'danger => 1'
           GROUP BY tag
         ) AS foo
    WHERE tag in ('dinosaurs', 'weapons', 'pirates', 'earthquakes', 'crime', 'mosquitoes')
)
SELECT * FROM bar 
WHERE count = (SELECT MAX(count) FROM bar)
;