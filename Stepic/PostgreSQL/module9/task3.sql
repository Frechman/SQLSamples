--https://stepik.org/lesson/50209/step/4

CREATE INDEX idx_f_id ON flight(id);
CREATE INDEX idx_bok_fl_id ON booking(flight_id);

----
SELECT  F.id AS flight_id, 
        C.name AS commander_name, 
        COUNT(P.id)::INT AS pax_count
FROM Commander C
JOIN Flight F ON F.commander_id = C.id
JOIN Booking B ON B.flight_id = F.id
JOIN Pax P ON B.pax_id = P.id
WHERE F.date BETWEEN '2084-04-01' AND '2084-05-01'
      AND C.name = _commander_name AND P.race = 'Men'
GROUP BY F.id, C.name
HAVING COUNT(P.id)::INT > _pax_count;