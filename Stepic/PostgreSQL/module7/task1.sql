--https://stepik.org/lesson/50193/step/2

WITH RECURSIVE Goroda AS (
	SELECT 	Cit.id AS id,
			Cit.value AS value,
			1 AS num,
			ARRAY[Cit.id] AS path
	FROM Cities Cit WHERE id = 0

	UNION

	SELECT  Cit.id AS id,
			Cit.value AS value,
			(G.num + 1) AS num,
			array_append(path, Cit.id)
	FROM Cities Cit	JOIN Goroda G
	ON (right(lower(G.value), 1) = left(lower(Cit.value), 1)) 
        AND Cit.id != ALL(path)
)

SELECT id, value, num 
FROM Goroda;