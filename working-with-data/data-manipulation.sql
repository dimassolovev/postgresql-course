SET search_path TO telegram;

------------------------------------------------------------------------------------------------------------------------
--INSERT команды--------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
INSERT INTO users (first_name, last_name, login, email, hash_password, phone_number)
VALUES ('Kelsie', 'Olson', 'OlsKel', 'test@gmail.com', '098f6bcd4621d373cade4e832627b4f6', '+79234321252');

INSERT INTO users (id, first_name, last_name, login, email, hash_password, phone_number)
VALUES (DEFAULT, 'Kelsie', 'Olson', 'OlsKel2', 'test3@gmail.com', '098f6bcd4621d373cade4e832627b4f6', '+7923432129')
ON CONFLICT (email) DO NOTHING;

INSERT INTO users
VALUES (DEFAULT, 'Kelsie', 'Olson', 'OlsKel3', 'test5@gmail.com', '098f6bcd4621d373cade4e832627b4f6', '+7913432129');

INSERT INTO users (last_name, first_name, login, email, hash_password, phone_number)
SELECT 'Olson',
       'Kelsie',
       'OlsKel6',
       'test6@gmail.com',
       '098f6bcd4621d373cade4e832627b4f6',
       '+7924432119';

INSERT INTO users
VALUES (2, 'Kelsie', 'Olson', 'OlsKel2001', 'testtest123@gmail.com', '098f6bcd4621d373cade4e832627b4f6', '+7921432129')
ON CONFLICT(id) DO UPDATE SET id = DEFAULT;

------------------------------------------------------------------------------------------------------------------------
--Пример копирования из одной базы в другую-----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS copy;
CREATE TABLE IF NOT EXISTS copy.users_copy
(
    id            BIGSERIAL PRIMARY KEY,
    first_name    VARCHAR(100)        NOT NULL,
    last_name     VARCHAR(100)        NOT NULL,
    login         VARCHAR(100) UNIQUE NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    hash_password VARCHAR(256)        NOT NULL,
    phone_number  BIGINT UNIQUE       NOT NULL
);

INSERT INTO copy.users_copy
VALUES (200, 'Test', 'Test', 'Test', 'Test@gmail.com', '098f6bcd4621d373cade4e832627b4f6', '+7923462119');

INSERT INTO users
SELECT *
FROM copy.users_copy;

------------------------------------------------------------------------------------------------------------------------
--Одиночные вставки работаю медленно, так как много сетевых взаимодействий----------------------------------------------
------------------------------------------------------------------------------------------------------------------------
INSERT INTO users (first_name, last_name, login, email, hash_password, phone_number)
VALUES ('Ozella', 'Hauck', 'test', 'idickens@example.com', '098f6bcd4621d373cede4e832627b4f6', '+9773438197'),
       ('Emmet', 'Hammes', 'test1', 'qcremin@example.org', '098f6bcd4621d373cede4e832627b4fb', '+9694110645'),
       ('Lori', 'Koch', 'test2', 'damaris34@example.net', '198f6bcd4621d373cede4e832627b4f6', '+9192291407'),
       ('Sam', 'Kuphal', 'test3', 'telly.miller@example.net', '098f6qcd4521d373cede4e832627b4f6', '+9917826315');
------------------------------------------------------------------------------------------------------------------------
--Пакетная вставка работает быстро--------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
--SELECT команды(поверхностная теория)----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
SELECT 'Hello, World!';

SELECT *
FROM users;

SELECT id, first_name, last_name
FROM users;

SELECT DISTINCT COUNT(first_name)
FROM users;

SELECT DISTINCT *
FROM users
WHERE id = 1;

SELECT *
FROM users
LIMIT 5;
SELECT *
FROM users
ORDER BY email;

------------------------------------------------------------------------------------------------------------------------
--UPDATE команды--------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
UPDATE users
SET
    first_name = 'updated'
WHERE id = 9;

UPDATE users
SET
    first_name = 'updated'
WHERE login LIKE 'Ols%';

------------------------------------------------------------------------------------------------------------------------
--DELETE команды--------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- подготовка данных (добавляем несколько сообщений между пользователями)
INSERT INTO private_messages (sender_id, receiver_id, media_type, body, filename, created_at)
VALUES
(1,2,'text','Eveniet suscipit ullam occaecati consequatur hic. Nulla est in molestiae odit. Placeat perferendis consequatur qui omnis id vel autem.','officiis','2010-04-07 09:01:02'),
(2,1,'audio','Non repudiandae maiores molestiae vel doloribus. Quis facere blanditiis est magnam est ut vero.','qui','1971-05-29 07:31:20'),
(1,3,'text','Voluptas qui consequatur quae sunt et consequatur. Rem alias sed cupiditate explicabo voluptate. Officiis repellat porro accusamus eveniet quos. Laborum dolores sed enim aut.','excepturi','1998-10-28 20:08:01'),
(1,4,'video','Est delectus tempora exercitationem atque tempora reiciendis nulla voluptatem. Cupiditate non fugit blanditiis quasi ad et autem expedita. Aut est provident odio quasi possimus.','vitae','2001-12-03 15:54:43'),
(1,2,'video','Est ducimus amet et asperiores. Reiciendis debitis qui ipsa. Nemo laboriosam ea aut omnis voluptates quisquam accusantium. Quibusdam totam similique aut.','optio','1970-09-18 20:39:35'),
(1,2,'video','Quis cupiditate quis maxime et placeat consectetur ut quis. Voluptas unde voluptatem deserunt in dolorum maxime. Sunt fugiat sit tenetur placeat at.','laboriosam','1980-05-11 03:39:43'),
(2,1,'audio','Voluptatum nihil rem laboriosam delectus aperiam consequuntur et modi. Laudantium molestias corporis quo omnis ut ea. At minima iure et voluptatum culpa deleniti non. Sint laboriosam molestias dolor vel. Quibusdam omnis quas ullam dolor.','sit','1988-08-19 10:30:44'),
(2,4,'audio','Nemo eos sed aspernatur voluptates perspiciatis tenetur. Voluptas sunt magnam vero nam earum. Magnam eum vitae qui. Vel atque accusantium in non rem non et.','consectetur','1984-06-28 16:22:44'),
(4,5,'audio','Quod nihil possimus id qui. Quasi officia rerum eum doloribus est voluptas maxime. Et debitis enim non enim fugit.','repellat','1981-12-11 16:04:11'),
(3,1,'text','Qui voluptatem earum temporibus rem vel sequi. Et quasi vel qui est autem aliquam. Modi est voluptatem aut rerum ea velit. Voluptate et eligendi debitis nostrum nihil dolorum.','nihil','1988-02-16 13:29:14'),
(3,2,'image','Rem et ullam cum vitae autem reprehenderit quia. Enim a ipsam id ut aliquam est error. Quis dolorum omnis expedita eaque maiores illo.','et','2015-04-07 18:02:42');

-- так не надо делать
DELETE FROM private_messages
WHERE sender_id = 1 AND receiver_id = 2;

-- Другое решение
ALTER TABLE private_messages ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;
UPDATE private_messages
SET is_deleted = TRUE
WHERE sender_id = 1 AND receiver_id = 2;

DELETE FROM private_messages WHERE TRUE;
TRUNCATE private_messages; -- пересоздает таблицу