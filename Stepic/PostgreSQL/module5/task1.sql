--https://stepik.org/lesson/50180/step/2

SELECT  name, 
        year, 
        COUNT(accepted)::INT AS total_papers, 
        AVG(accepted::INT)::NUMERIC(3,2) AS acceptance_ratio 
FROM ConferenceEvent CE 
JOIN Conference C ON C.id = CE.conference_id
JOIN Paper P ON P.event_id = CE.id
GROUP BY name, year
HAVING COUNT(accepted)::INT > 5 AND AVG(accepted::INT)::NUMERIC(3,2) > 0.75
;