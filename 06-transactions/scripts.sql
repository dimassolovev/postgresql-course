SET search_path TO telegram;

------------------------------------------------------------------------------------------------------------------------
--Transactions----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- последовательное выполнение операций, которое либо выполнится целиком, либо не выполнится

CREATE OR REPLACE PROCEDURE add_user(
    first_name_param VARCHAR(100),
    last_name_param VARCHAR(100),
    login_param VARCHAR(100),
    email_param VARCHAR(100),
    hash_password_param VARCHAR(256),
    phone_number_param BIGINT,
    birthday_param DATE,
    is_premium_account_param BOOLEAN,
    is_night_mode_enabled_param BOOLEAN,
    color_scheme_param COLOR_THEME,
    status_text_param VARCHAR(70),
    language_param LANG,
    notifications_and_sounds_param JSON,
    created_at_param TIMESTAMP
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    user_id_var INT;
BEGIN
    IF created_at_param IS NULL THEN
        created_at_param := NOW();
    END IF;

    INSERT INTO users (first_name, last_name, login, email, hash_password, phone_number, birthday)
    VALUES (first_name_param, last_name_param, login_param, email_param, hash_password_param, phone_number_param,
            birthday_param)
    RETURNING id INTO user_id_var;

    INSERT INTO user_settings (user_id, is_premium_account, is_night_mode_enabled, color_scheme, status_text,
                               language, notifications_and_sounds, created_at)
    VALUES (user_id_var, is_premium_account_param, is_night_mode_enabled_param, color_scheme_param, status_text_param,
            language_param, notifications_and_sounds_param, created_at_param);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Произошла ошибка при добавлении пользователя. Транзакция откатана.';
        ROLLBACK;
        RAISE;
END;
$$;


CALL add_user(
        'John',
        'Doe',
        'jdoe',
        'jdoe@example.com',
        'hashed_password_value',
        1234567890,
        '1985-05-12',
        TRUE,
        FALSE,
        'day',
        'Online',
        'english',
        '{
          "email": true,
          "sms": false
        }',
        NULL
     );


------------------------------------------------------------------------------------------------------------------------
--Transaction isolation levels------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Уровни изоляций:  Фантомное чтение | Неповторяющееся чтение | "Грязное" чтение
-- READ UNCOMMITTED         -                       -                     -
-- READ COMMITTED           -                       -                     +
-- REPEATABLE READ          -                       +                     +
-- SERIALIZABLE             +                       +                     +
-- с повышением уровня изоляции накладные расходы растут
-- В PostgreSQL по умолчанию стоит READ COMMITTED, а в MySQL стоит REPEATABLE READ

------------------------------------------------------------------------------------------------------------------------
--Table Locks-----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

