--https://stepik.org/lesson/50165/step/3

SELECT conference FROM Paper WHERE conference NOT IN (SELECT value FROM Conference)
UNION
SELECT conference FROM Paper GROUP BY conference HAVING COUNT(DISTINCT location) > 1