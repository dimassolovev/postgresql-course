SET search_path TO telegram;

------------------------------------------------------------------------------------------------------------------------
--FullTextSearch--------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- дает больше возможностей по работе с текстом, а именно с поиском.

-- допустим, нужен поиск по нескольким слов в теле сообщения. Это неудобно делать через WHERE
SELECT *
FROM saved_messages
WHERE body LIKE '%Quia%' OR body LIKE '%Alias%';

-- полнотекстовый поиск
-- нужно наложить индекс на поле или набор
CREATE INDEX body_messages ON saved_messages USING GIN(TO_TSVECTOR('english', body));

SELECT *
FROM saved_messages
WHERE TO_TSVECTOR('english', body) @@ TO_TSQUERY('Quia & (!Alias | labore)'); -- |, ! и & как логические операторы. <-> - оператор следования

------------------------------------------------------------------------------------------------------------------------
--Views-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- хранение select запроса.
CREATE OR REPLACE VIEW test_view AS -- OR REPLACE для обновления нашей выборки
    SELECT
        u.first_name,
        u.last_name,
        s.language AS app_language,

        CASE
            WHEN s.is_premium_account = TRUE THEN 'premium'
            ELSE 'not premium'
        END AS is_premium_account

    FROM users u
    LEFT JOIN user_settings s ON s.user_id = u.id
    WHERE u.id = 2;

SELECT * FROM test_view;

------------------------------------------------------------------------------------------------------------------------
--PROCEDURES------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- пример обновления
CREATE OR REPLACE PROCEDURE update_user_language(
    user_id_param INT,
    new_first_name_param VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE users
    SET first_name = new_first_name_param
    WHERE id = user_id_param;

    RAISE NOTICE 'First name (%) updated for user with ID %', new_first_name_param, user_id_param;
END
$$;


CALL update_user_language(1, 'updated');

-- еще пример для показа количества групп или каналов

CREATE OR REPLACE PROCEDURE select_count_from_groups_or_channels(
    param VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE
    result_count INT;
BEGIN
    CASE
        WHEN param ILIKE 'groups' THEN SELECT COUNT(*) INTO result_count FROM groups;
        WHEN param ILIKE 'channels' THEN SELECT COUNT(*) INTO result_count FROM channels;
        ELSE
            RAISE NOTICE 'unknown param %', param;
            RETURN;
    END CASE;
    RAISE NOTICE 'param: %, number: %', param, result_count;
END
$$;

CALL select_count_from_groups_or_channels('Channels');

------------------------------------------------------------------------------------------------------------------------
--FUNCTIONS-------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_premium_percentage()
RETURNS DECIMAL(5, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    premium_account_count INT;
    total_users_count INT;
    result DECIMAL(5, 2);
BEGIN
    --total_users_count := (SELECT COUNT(*) FROM user_settings); -- := - присваивание, а = - сравнение
    SELECT COUNT(*) INTO total_users_count FROM user_settings;
    SELECT COUNT(*) INTO premium_account_count FROM user_settings WHERE is_premium_account;
    CASE
        WHEN total_users_count = 0 THEN RETURN 0;
        ELSE result = premium_account_count / total_users_count;
    END CASE;

    RETURN result;
END
$$;

SELECT get_premium_percentage();

------------------------------------------------------------------------------------------------------------------------
--Variables-------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
DO $$ -- анонимный блок кода
DECLARE
    my_var INT := 1;
    user_first_name VARCHAR;
BEGIN
    SELECT first_name
    INTO user_first_name
    FROM users
    WHERE id = my_var;

    RAISE NOTICE 'User First Name: %', user_first_name;
END $$;

------------------------------------------------------------------------------------------------------------------------
--Triggers--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- фича, которая позволяет подписаться на определенное событие в жизни таблицы.
-- Применяются для: логирования, аудита, вызова внешних сервисов, дополнительных вычислений, бизнес логики.
-- Плюсы:
-- 1. пишим один раз, а исполняется постоянно.
-- 2. триггеры быстро работают.
-- Минусы:
-- 1. участие триггера неочевидено.
-- 2. нет откладки.

-- добавим бизнес логику на уровне postgresql.
-- создадим триггер, который будет смотреть на дату рождения и проверять ее валидность.

CREATE OR REPLACE FUNCTION date_checker()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.birthday > NOW() THEN
        RAISE EXCEPTION 'Ошибка: Дата рождения не может быть в будущем. Указано: %', NEW.birthday;

    ELSIF NEW.birthday > NOW() - INTERVAL '5 years' THEN
        RAISE EXCEPTION 'Ошибка: Пользователь должен быть старше 5 лет. Указано: %', NEW.birthday;

    ELSIF NEW.birthday < NOW() - INTERVAL '100 years' THEN
        RAISE EXCEPTION 'Ошибка: Пользователь не может быть старше 100 лет. Указано: %', NEW.birthday;

    ELSE
        RAISE NOTICE 'Проверка прошла. Старое значение: % заменится на новое: %', OLD.birthday, NEW.birthday;

    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER check_user_before_update
    BEFORE UPDATE OR INSERT ON users
    FOR EACH ROW
    EXECUTE FUNCTION date_checker();

-- проверим работу триггера

-- создадим UPDATE запрос
UPDATE users
SET
    birthday = '1899-11-18'
WHERE id = (SELECT u.id FROM users AS u WHERE u.first_name = 'Cordelia' AND u.last_name = 'Schmidt');
-- Получаем ошибку

INSERT INTO users (first_name, last_name, login, email, hash_password, phone_number, birthday)
VALUES ('Dmitriy', 'Soloviev', NULL, 'gohasoxx@gmail.com', 'cf8d30fa5ec42613e5ce038910dcfee0c934a878', '79223191679', '2070-07-14')
-- тоже получим ошибку