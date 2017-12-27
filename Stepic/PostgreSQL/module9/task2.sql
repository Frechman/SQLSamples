--https://stepik.org/lesson/50209/step/3

-- здесь можно создавать индексы, если угодно 
-- CREATE INDEX idx1 ON Commander(name);

---- Запрос, нуждающийся в ускорении. 
SELECT  Price.planet_id,
        Price.spacecraft_class,
        Price.price * COUNT(Pax.id)
FROM Price
JOIN Planet P ON Price.planet_id = P.id
JOIN Flight F ON P.id = F.planet_id AND Price.planet_id = F.planet_id
JOIN Booking B ON B.flight_id = F.id
JOIN Spacecraft S ON F.spacecraft_id = S.id AND S.class = Price.spacecraft_class
JOIN Pax ON B.pax_id = Pax.id
GROUP BY Price.planet_id, Price.spacecraft_class, Price.price;