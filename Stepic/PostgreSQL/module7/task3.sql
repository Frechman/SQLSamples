--https://stepik.org/lesson/50193/step/4

WITH kltr1 AS (
  SELECT  KL.id,
          KL.value,
          row_number() OVER (ORDER BY KL.path) AS row,
          COUNT(*) AS cnt_chl
  FROM KeywordLtree KL JOIN KeywordLtree KL2
  ON KL.path @> KL2.path
  GROUP BY KL.id
  Order By KL.path
),
kltr2 AS (
        SELECT  KL.id,
                COUNT(*) AS cnt_par
        FROM KeywordLtree KL JOIN KeywordLtree KL2
        ON KL.path < @KL2.path
        GROUP BY KL.id
        Order By KL.path
)

SELECT  kltr1.id, kltr1.value,
        row*2 - kltr2.cnt_par AS lft,
        row*2 - kltr2.cnt_par + 2*kltr1.cnt_chl - 1  AS rgt
FROM kltr1, kltr2 
WHERE kltr1.id = kltr2.id
;
