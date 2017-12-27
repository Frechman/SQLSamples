--https://stepik.org/lesson/50209/step/2

CREATE INDEX idx_f_pln_id ON flight(planet_id);
CREATE INDEX idx_f_id ON flight(id);
CREATE INDEX idx_p_id ON planet(id);
CREATE INDEX idx_bok_fl_id ON booking(flight_id);

---------------------------------------------------------- 
SELECT COUNT(1)
FROM Flight F JOIN Spacecraft S ON F.spacecraft_id = S.id
JOIN Planet P ON F.planet_id = P.id
JOIN Booking B ON F.id = B.flight_id
WHERE S.capacity < _capacity AND S.class = 1
AND P.name = _planet_name;