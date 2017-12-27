--https://stepik.org/lesson/50186/step/5

--- Получаем таблицу с разницей между текущей ценой и ценой из прошлой недели
WITH T1 AS (
  SELECT company, 
  week, 
  share_price - FIRST_VALUE(share_price) OVER (PARTITION BY company ORDER BY week ASC
          ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS delta_price                                                     
FROM StockQuotes),

--- Получаем таблицу, в которой для каждой комании-недели указано был ли прирост по компании больше среднего прироста на неделе (uspeh=1)
T2 AS (SELECT 
  company, 
  week,   
  (CASE 
    WHEN (delta_price > AVG(delta_price) OVER (PARTITION BY week)) 
    THEN 1
    ELSE 0 
  END) AS uspeh
FROM T1),

--- Вычислем количество успехов за текущую неделю и две предыдущие 
T3 AS (SELECT company,
  week,
  uspeh,
  (SUM(uspeh) OVER (PARTITION BY company ORDER BY week
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS seriya
FROM T2),

--- Подсчитываем сколько раз у нас упоминалась компания с серией успехов (т.е. сколько было третьих успешных недель) 
T4 AS (SELECT company, COUNT(seriya) AS c_seriya
FROM T3 
WHERE seriya >= 3 
GROUP BY company)

--- Выводим результат с сортировкой по увеличению количества серий успехов, по компаниям.
SELECT * FROM T4 ORDER BY c_seriya, company
;

----OTHER SOLUTION
WITH week_delta AS (
    SELECT *, share_price - lag(share_price) OVER (PARTITION BY company ORDER BY week) AS delta
    FROM StockQuotes
),
stock_index AS (
    SELECT *, AVG(delta) OVER (PARTITION BY week) AS stock_index
    FROM week_delta
),
company_streak AS (
    SELECT *, SUM((delta > stock_index)::INT) OVER _success_week AS streak
    FROM stock_index
    WINDOW _success_week AS (PARTITION BY company ORDER BY week ROWS 2 PRECEDING)
)
SELECT company, COUNT(*) 
FROM company_streak 
WHERE streak = 3 
GROUP BY company;