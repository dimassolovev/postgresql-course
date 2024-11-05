SET search_path TO telegram;

------------------------------------------------------------------------------------------------------------------------
--WHERE + LIKE----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM users
WHERE id = 1;

SELECT *
FROM users
WHERE first_name LIKE 'K%'; -- для того, чтобы учитывать или не учитывать регистр используй COLLATE

SELECT *
FROM users
WHERE first_name LIKE '_o%';

SELECT *
FROM users
WHERE first_name LIKE '_____';

SELECT *
FROM users
WHERE login ~ 'test[0-9]{2}'; -- регистрозависим ~ + re

SELECT *
FROM users
WHERE login ~* 'test';
-- регистронезависим ~* + re

------------------------------------------------------------------------------------------------------------------------
--ORDER BY--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM private_messages
WHERE (sender_id = 1 AND receiver_id = 2)
   OR (sender_id = 2 AND receiver_id = 1)
ORDER BY created_at DESC;

-- добавим новую колонку, непрочитанные сообщения
ALTER TABLE private_messages
    ADD COLUMN is_read BOOLEAN DEFAULT FALSE NOT NULL;

-- количество непрочитанных сообщения от пользователя
SELECT COUNT(*)
FROM private_messages
WHERE (sender_id = 1 AND receiver_id = 2);

-- количество непрочитанных диалогов
SELECT COUNT(DISTINCT sender_id)
FROM private_messages
WHERE (receiver_id = 2)
  AND is_read = FALSE;

-- прочитал сообщения
UPDATE private_messages
SET is_read = TRUE
WHERE sender_id = 1
  AND receiver_id = 2;

------------------------------------------------------------------------------------------------------------------------
--AGGREGATE FUNCTIONS---------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
SELECT MIN(DATE_PART('year', created_at))
FROM private_messages;
SELECT MAX(DATE_PART('year', created_at))
FROM private_messages;


------------------------------------------------------------------------------------------------------------------------
--GROUP BY--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- вся таблица user_settings
SELECT *
FROM user_settings;

-- количество пользователей, сгруппированное по языкам с сортировкой по убыванию
SELECT
    COUNT(*) AS language_count,
    language
FROM user_settings
GROUP BY language
ORDER BY language_count DESC;

-- вся таблица подписчиков каналов
SELECT *
FROM channel_subscribers;

-- самый популярный канал по кол-ву пользователей
SELECT
    COUNT(*) AS count,
    channel_id
FROM channel_subscribers
WHERE status = 'joined'
GROUP BY channel_id
ORDER BY count DESC
LIMIT 1;

------------------------------------------------------------------------------------------------------------------------
--HAVING----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SELECT
    group_id,
    COUNT(group_id) AS count
FROM group_messages
WHERE media_type = 'text' -- фильтрация строк
GROUP BY group_id
HAVING COUNT(group_id) > 50 -- фильтрация группировки
ORDER BY count DESC;

------------------------------------------------------------------------------------------------------------------------
--IS NULL---------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM users
WHERE phone_number IS NOT NULL;

------------------------------------------------------------------------------------------------------------------------
--LIMIT + OFFSET--------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM users
WHERE phone_number IS NOT NULL
ORDER BY id -- Сортировка нужна
LIMIT 5
OFFSET 5; -- 0 -> 5 -> 10 -> ... -> 5n

------------------------------------------------------------------------------------------------------------------------
--CASE------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SELECT
    title,
    CASE
        WHEN is_private = TRUE THEN 'private'
        ELSE 'public'
    END AS publicity,
    invite_link
FROM channels;

-- Задача: разбить наших юзеров на поколения: x, y, z
ALTER TABLE users ADD COLUMN birthday DATE DEFAULT NULL;

-- дальше добавление данных ...


-- вывод данных
SELECT
    CASE
        WHEN DATE_PART('year', birthday) BETWEEN 1946 AND 1964 THEN 'baby boomer'
        WHEN DATE_PART('year', birthday) BETWEEN 1965 AND 1980 THEN 'x generation'
        WHEN DATE_PART('year', birthday) BETWEEN 1981 AND 2000 THEN 'y generation'
        WHEN DATE_PART('year', birthday) BETWEEN 2001 AND DATE_PART('year', NOW()) THEN 'z generation'
    END AS generation,
    COUNT(*) AS count
FROM users
GROUP BY generation
ORDER BY count DESC;