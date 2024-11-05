SET search_path TO telegram;

------------------------------------------------------------------------------------------------------------------------
--SubQueries------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- примеры сколеринованного запроса (вложенные циклы под коробкой)

-- вывести first_name, last_name, app_language, is_premium
SELECT
    first_name,
    last_name,

    (SELECT s.language
     FROM user_settings AS s
     WHERE user_id = users.id) AS app_language,

    (SELECT
         CASE
             WHEN s.is_premium_account = TRUE THEN 'premium'
             ELSE 'not premium'
         END AS is_premium
    FROM user_settings AS s WHERE user_id = users.id) AS is_premium_account

FROM users
WHERE id = 1;

-- вывести количество непрочитанных сообщений у пользователя, зная его email
SELECT COUNT(*)
FROM private_messages
WHERE receiver_id = (SELECT u.id FROM users AS u WHERE u.email = 'test@gmail.com') AND is_read = FALSE;

-- заменить reaction_id на само имея реакции
SELECT
    (SELECT rl.code FROM reactions_list AS rl WHERE rl.id = pmr.reaction_id) AS reaction,
    COUNT(*)
FROM private_message_reactions AS pmr
GROUP BY reaction_id;

------------------------------------------------------------------------------------------------------------------------
--CROSS JOIN | INNER JOIN-----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM users, private_messages; -- users CROSS JOIN private_message

SELECT *
FROM users CROSS JOIN private_messages;

SELECT *
FROM private_messages, users; -- private_message CROSS JOIN users

-- два одинаковых запроса

-- медленно
SELECT *
FROM users AS u CROSS JOIN private_messages AS pm
WHERE u.id = pm.sender_id;

-- быстро
SELECT *
FROM users AS u INNER JOIN private_messages AS pm
ON u.id = pm.sender_id;


------------------------------------------------------------------------------------------------------------------------
--LEFT JOIN | RIGHT JOIN------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- LEFT JOIN и RIGHT JOIN зеркальны и взаимнозаменяемы.

-- количество людей, которые не писали сообщения(вырезаем INNER JOIN часть)
SELECT *
FROM users AS u LEFT OUTER JOIN private_messages AS pm
ON u.id = pm.sender_id
WHERE pm.id IS NULL -- если поменяем на IS NOT NULL, то получим INNER JOIN
ORDER BY pm.id;

-- одни и те же результаты
SELECT u.*, pm.*
FROM users AS u LEFT OUTER JOIN private_messages AS pm
ON pm.sender_id = u.id
ORDER BY pm.id;

SELECT u.*, pm.*
FROM private_messages AS pm RIGHT OUTER JOIN users AS u
ON pm.sender_id = u.id
ORDER BY pm.id;

------------------------------------------------------------------------------------------------------------------------
--FULL OUTER JOIN-------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM users AS u FULL OUTER JOIN private_messages AS pm ON u.id = pm.sender_id
ORDER BY u.id;

------------------------------------------------------------------------------------------------------------------------
--UNION-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- пример FULL OUTER JOIN

SELECT *
FROM users AS u LEFT JOIN private_messages AS pm ON u.id = pm.sender_id
         UNION DISTINCT -- ALL включает дубликаты. Для UNION должно выполняться главное условие - это количество столбцов для таблиц должны совпадать.
SELECT *
FROM users as u RIGHT JOIN private_messages AS pm ON u.id = pm.sender_id;

-- Пример для UNION ALL. Количество активных пользователей, которые писали в групповых чатах или чатах канала:

SELECT sender_id, COUNT(sender_id) AS count
FROM (
    SELECT sender_id
    FROM channel_messages
    UNION ALL
    SELECT sender_id
    FROM group_messages
) AS combined_messages
GROUP BY combined_messages.sender_id
ORDER BY combined_messages.count DESC;

------------------------------------------------------------------------------------------------------------------------
--WINDOW FUNCTIONS------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SELECT
    DISTINCT language,
    COUNT(*) OVER (PARTITION BY language) AS count -- не делают группировку.
FROM user_settings;

SELECT
    DISTINCT language,
    COUNT(*) OVER win1 AS count
FROM user_settings
WINDOW win1 AS (PARTITION BY language); -- псевдоним

SELECT
    ROW_NUMBER() OVER() AS rn,
    RANK() OVER (ORDER BY media_type) as media_type_rank, -- условный номер для каждого окна
    DENSE_RANK() OVER (ORDER BY media_type) as media_type_rank, -- условный номер для каждого окна, но увеличение на 1 при смене значения окна
    ROW_NUMBER() OVER(PARTITION BY media_type) AS rn1, -- счетчик в рамках окна
    media_type
FROM group_messages
ORDER BY rn;

------------------------------------------------------------------------------------------------------------------------
--CTE-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SELECT
	first_name ,
	last_name,
	(SELECT language FROM user_settings WHERE user_id = users.id) AS app_language,
	(SELECT is_premium_account FROM user_settings WHERE user_id = users.id) AS is_premium_account
FROM users
WHERE id = 2;

-- то же самое тольк с cte

WITH cte_example AS (
    SELECT
        user_id,
        language,
        is_premium_account
    FROM user_settings
)
SELECT
    u.first_name,
    u.last_name,
    ce.language,
    ce.is_premium_account
FROM cte_example AS ce
RIGHT JOIN users AS u ON u.id = ce.user_id
WHERE id = 2;

------------------------------------------------------------------------------------------------------------------------
--RECURSIVE EXPRESSIONS-------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Вывод цепочки сообщений на примере group_messages
WITH RECURSIVE message_replies (id, body, history) AS (
    SELECT gm1.id, gm1.body, CAST(gm1.id AS TEXT)
    FROM group_messages AS gm1
    WHERE reply_to_id IS NULL -- начинаем иерархию с тех сообщений, которые ни на что не отвечали
    UNION ALL
    SELECT gm2.id, gm2.body, CONCAT(mr.history, ' <-- ', gm2.id)
    FROM message_replies AS mr
    JOIN group_messages AS gm2 ON mr.id = gm2.reply_to_id
)
SELECT * FROM message_replies
ORDER BY history;
