-- Описание задания

-- В таблице RPM_ZONE_FUTURE_RETAIL хранятся изменения цен на уровне товар/ценовая зона (ITEM/ZONE). 
-- В таблице RPM_FUTURE_RETAIL хранятся изменения цен на уровне товар/магазин (ITEM/LOCATION). 
-- Каждый магазин может быть только в одной ценовой зоне.
-- Исходим из того, что мы имеем исторические изменения до 3 месяцев в прошлом и все будущие изменения. 
-- Текущая дата в системе 01/07/2011.

-- В нашей конфигурации, все магазины одной ценовой зоны должны иметь одинаковые цены на товар.

-- 1.	Написать SQL запрос, который покажет цену для всех товаров в первой ценовой зоне  
-- на начало и конец отчетного периода. Отчетный период с 01.06.2011 – 20.07.2012.

WITH win as (
  (SELECT RPM_FUTURE_RETAIL.*, ZONE_ID as zone
     , first_value(SELLING_RETAIL) OVER (PARTITION BY item ORDER BY ACTION_DATE <= '2011-06-01' DESC ) as start_period
     , last_value(SELLING_RETAIL) OVER (PARTITION BY item ORDER BY ACTION_DATE <= '2012-07-20' DESC ) as end_period

   FROM RPM_FUTURE_RETAIL
     JOIN RPM_ZONE_location ON RPM_ZONE_location.LOCATION=RPM_FUTURE_RETAIL.LOCATION
   WHERE ZONE_id = 1
   ORDER BY ACTION_DATE DESC
  )
  UNION
  (SELECT *,ZONE as zone
     , first_value(SELLING_RETAIL) OVER (PARTITION BY item ORDER BY ACTION_DATE <= '2011-06-01' DESC ) as start_period
     , last_value(SELLING_RETAIL) OVER (PARTITION BY item ORDER BY ACTION_DATE <= '2012-07-20' DESC ) as end_period

   FROM RPM_ZONE_FUTURE_RETAIL
   WHERE ZONE = 1
   ORDER BY ACTION_DATE DESC
  )
)
SELECT  win.ITEM, start_period, end_period --??,LOCATION??
FROM win
GROUP BY item, start_period, end_period --??,LOCATION??
;

-- 2.	Написать SQL запросы, которые покажут товары, отвечающие следующим условиям на текущую дату: 
-- a.	Товар имеет цену на уровне магазина, но при этом не имеет цену на уровне зоны, к которой привязан магазин.
SELECT *
FROM RPM_FUTURE_RETAIL magaz
JOIN RPM_ZONE_location zl USING (location)
LEFT OUTER JOIN RPM_ZONE_FUTURE_RETAIL zone
    ON zl.ZONE_ID = zone.ZONE
       AND zone.ITEM = magaz.ITEM AND magaz.ACTION_DATE = zone.ACTION_DATE
WHERE magaz.ACTION_DATE <= '2011-07-01'  AND
zone.SELLING_RETAIL is NULL
;

-- b.	Цена товара на уровне магазина отличается от цены товара на уровне зоны.
SELECT *
FROM RPM_FUTURE_RETAIL shop
JOIN RPM_ZONE_location zl USING (location)
LEFT OUTER JOIN RPM_ZONE_FUTURE_RETAIL zone
    ON zl.ZONE_ID = zone.ZONE
       AND zone.ITEM = shop.ITEM AND shop.ACTION_DATE = zone.ACTION_DATE
WHERE shop.ACTION_DATE <= '2011-07-01'  AND
shop.SELLING_RETAIL != zone.SELLING_RETAIL
;
