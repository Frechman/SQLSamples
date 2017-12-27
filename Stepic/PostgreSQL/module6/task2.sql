--https://stepik.org/lesson/50186/step/3

SELECT X.value, COUNT(*)
      FROM T AS X, T AS Y
      GROUP BY X.value
      HAVING
        SUM(CASE WHEN Y.value <= X.value
            THEN 1 ELSE 0 END)>=(COUNT(*)+1)/2 
        AND
        SUM(CASE WHEN Y.value >= X.value
            THEN 1 ELSE 0 END)>=(COUNT(*)/2)+1