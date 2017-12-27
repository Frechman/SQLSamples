--https://stepik.org/lesson/50174/step/2

SELECT C.name, S.name, F.start_date
FROM Flight F
JOIN Commander C ON (C.id = F.commander_id) 
JOIN Spacecraft S ON (S.id = F.spacecraft_id) 
WHERE C.id = 6;