-- Описание задания

-- В таблице RPM_ZONE_FUTURE_RETAIL хранятся изменения цен на уровне товар/ценовая зона (ITEM/ZONE). 
-- В таблице RPM_FUTURE_RETAIL хранятся изменения цен на уровне товар/магазин (ITEM/LOCATION). 
-- Каждый магазин может быть только в одной ценовой зоне.
-- Исходим из того, что мы имеем исторические изменения до 3 месяцев в прошлом и все будущие изменения. 
-- Текущая дата в системе 01/07/2011.

-- В нашей конфигурации, все магазины одной ценовой зоны должны иметь одинаковые цены на товар.

-- 1.	Создать таблицу ITEM_ZONE_PRICE следующей структуры:
-- Ценовая зона	Товар	Дата	Цена
CREATE TABLE ITEM_ZONE_PRICE (
  price_zone int,
  item int,
  date date,
  selling_retail NUMERIC(5,2)
)
;

-- Написать insert, который заполнит цену на первое число каждого месяца 
-- для товара ‘03020318’ в первой ценовой зоне за период с 01.06.2011 по 01.09.2012
WITH fill as (
    SELECT shop.*, zl.ZONE_ID as zone
    FROM RPM_FUTURE_RETAIL shop
      JOIN RPM_ZONE_location zl USING (location)
    WHERE shop.ITEM = '03020318' AND zl.ZONE_ID = 1
    AND ACTION_DATE BETWEEN '2011-06-01' AND '2012-09-01'
)
INSERT INTO ITEM_ZONE_PRICE(price_zone, item, date, selling_retail)
  SELECT fill.zone as price_zone, fill.item as item, fill.ACTION_DATE as date, fill.SELLING_RETAIL as selling_retail
  FROM fill
;

-- 2.	Написать update, который позволит выровнять цены в таблице RPM_FUTURE_RETAIL, 
-- используя цену на уровне ценовой зоны на текущую дату.
UPDATE RPM_FUTURE_RETAIL
SET SELLING_RETAIL = (
  SELECT zone.SELLING_RETAIL as price
  FROM RPM_FUTURE_RETAIL shop
    JOIN RPM_ZONE_location zl USING (location)
    LEFT JOIN RPM_ZONE_FUTURE_RETAIL zone
      ON zl.ZONE_ID = zone.ZONE AND
         zone.ITEM = shop.ITEM AND shop.ACTION_DATE = zone.ACTION_DATE
  WHERE shop.ACTION_DATE <= '2011-07-01'
)
;