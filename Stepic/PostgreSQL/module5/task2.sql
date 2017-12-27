--https://stepik.org/lesson/50180/step/3

DECLARE 
  ag INT;
  sc INT;
BEGIN
	--1FK  нет такой конференции
	IF EXISTS   (
                SELECT conference_id 
                FROM ConferenceEvent 
                WHERE conference_id NOT IN (SELECT id FROM Conference) 
                ) THEN RAISE SQLSTATE 'DB017'; 
	END IF;
	--2FK  нет статьи на конференции-неправильная CE
	IF EXISTS   (
                SELECT event_id 
                FROM Paper 
                WHERE event_id NOT IN (SELECT id FROM ConferenceEvent)
                ) THEN RAISE SQLSTATE 'DB017'; 
	END IF;
	--3FK  нет такого рецензента для этой статьи
	IF EXISTS   (
                SELECT paper_id 
                FROM PaperReviewing 
                WHERE paper_id NOT IN (SELECT id FROM Paper)
                ) THEN RAISE SQLSTATE 'DB017';
	END IF;
	--4FK нет такого рецензента для этой статьи
	IF EXISTS   (
                SELECT reviewer_id 
                FROM PaperReviewing 
                WHERE reviewer_id NOT IN (SELECT id FROM Reviewer)
                ) THEN RAISE SQLSTATE 'DB017';
	END IF;
	--нет такой статьи
	IF NOT EXISTS   (
                    SELECT id 
                    FROM Paper 
                    WHERE id = _paper_id
                    ) THEN RAISE SQLSTATE 'DB017';
	END IF;
	--нет такого рецензента
	IF NOT EXISTS  (
                    SELECT id FROM Reviewer WHERE id = _reviewer_id
                    ) THEN RAISE SQLSTATE 'DB017';
	END IF;
	--нет такой статьи для такого рецензента
	IF NOT EXISTS   (
                    SELECT paper_id FROM PaperReviewing WHERE paper_id = _paper_id
                    ) THEN RAISE SQLSTATE 'DB017';
	END IF;
	--нет такого рецензента для этой статьи
	IF NOT EXISTS  (
                    SELECT reviewer_id 
                    FROM PaperReviewing 
                    WHERE reviewer_id = _reviewer_id
                    ) THEN RAISE SQLSTATE 'DB017';
	END IF;
    
    --нет такой статьи для такого рецензента
	IF NOT EXISTS   (
                    SELECT paper_id 
                    FROM PaperReviewing 
                    WHERE paper_id = _paper_id AND reviewer_id = _reviewer_id
                    ) THEN RAISE SQLSTATE 'DB017';
	END IF;
	--нет такого рецензента для этой статьи
	IF NOT EXISTS   (
                    SELECT reviewer_id 
                    FROM PaperReviewing 
                    WHERE paper_id = _paper_id AND reviewer_id = _reviewer_id
                    ) THEN RAISE SQLSTATE 'DB017';
	END IF;
	
	
	-- Оценками могут быть целые числа в диапазоне [1..7]
	IF _score NOT IN (1,2,3,4,5,6,7) THEN RAISE SQLSTATE 'DB017'; 
	END IF;
	
	--ТО УСТАНАВЛИВАЕМ ОЦЕНКУ ДЛЯ статьи определенного ревьювера
	UPDATE PaperReviewing SET score = _score WHERE paper_id = _paper_id AND reviewer_id = _reviewer_id;

	IF EXISTS(SELECT accepted FROM Paper WHERE accepted IS NULL AND id = _paper_id) 
	THEN 
		IF (SELECT COUNT(score) FROM PaperReviewing WHERE paper_id = _paper_id AND score IS NOT NULL) >= 3
		THEN 
			IF (SELECT AVG(score)::INT  FROM PaperReviewing WHERE paper_id = _paper_id AND score IS NOT NULL) > 4
				THEN UPDATE Paper SET accepted = TRUE WHERE id = _paper_id;
				
			ELSE UPDATE Paper SET accepted = FALSE WHERE id = _paper_id;

			END IF;
		ELSE 
		END IF;
	ELSE RAISE SQLSTATE 'DB017'; --если не нулл
	END IF;
END;