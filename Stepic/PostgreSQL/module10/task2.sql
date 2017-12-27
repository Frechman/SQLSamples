--https://stepik.org/lesson/57264/step/3

WITH ListCom AS (
    SELECT commander_id, name, data
    FROM CommanderAchievements 
    JOIN Commander ON Commander.id = CommanderAchievements.commander_id
),
Result AS (
    SELECT
            jsonb_array_elements(wiki_jsonb -> 'log')::jsonb ->> 'commander' AS name_commander,
            format('{"planet": "%s", "with": "dino"}', name)::JSONB AS  msg
    FROM Planet
    WHERE wiki_jsonb -> 'features' ->> 'dinosaurs' = '1'
)
SELECT  commander_id, 
        jsonb_insert(data, '{selfies, -1}', Result.msg, true) AS data
FROM ListCom 
LEFT JOIN Result ON ListCom.name = Result.name_commander