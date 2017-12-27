--https://stepik.org/lesson/50193/step/3


WITH RECURSIVE Amount AS (
  SELECT  id AS id,
          ARRAY[K.id] AS vertex
  FROM Keyword K
  WHERE K.parent_id IS NULL

  UNION ALL

  SELECT  K.id AS id,
          array_append(vertex, K.id) AS vertex
  FROM Keyword K JOIN Amount A
    ON K.parent_id = A.id
)
  SELECT id,
        (SELECT count(*) 
        FROM Amount A1 
        WHERE A.id IN (SELECT * from unnest(vertex))) AS subtree_size
--id, (SELECT COUNT(*) FROM Amount P WHERE P.vertex @> A.vertex) AS subtree_size
  FROM Amount A
