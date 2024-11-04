CREATE SCHEMA IF NOT EXISTS telegram; -- создадим бд(схему)
SET search_path TO telegram; -- в текущей сессии мы устанавливаем, что будем работать с этой схемой

CREATE TABLE IF NOT EXISTS users
(
    id            BIGSERIAL PRIMARY KEY,
    first_name    VARCHAR(100)        NOT NULL,
    last_name     VARCHAR(100)        NOT NULL,
    login         VARCHAR(100) UNIQUE NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    hash_password VARCHAR(256)        NOT NULL,
    phone_number  BIGINT       UNIQUE NOT NULL
);

CREATE INDEX username_index ON users (first_name, last_name);
COMMENT ON INDEX username_index IS 'users';

CREATE TYPE COLOR_THEME AS ENUM ('classic', 'day', 'tinted', 'night');
CREATE TYPE LANG AS ENUM ('english', 'french', 'russian', 'german', 'belorussian', 'croatian', 'dutch');
CREATE  TYPE MEDIA_TYPE AS ENUM ('video', 'message', 'image', 'audio', 'text');
CREATE TYPE STATUS AS ENUM ('requested', 'joined', 'left');

CREATE TABLE IF NOT EXISTS user_settings
(
    id                       BIGSERIAL PRIMARY KEY,
    user_id                  BIGINT UNIQUE           NOT NULL,
    is_premium_account       BOOLEAN                 NOT NULL,
    is_night_mode_enabled    BOOLEAN                 NOT NULL,
    color_scheme             COLOR_THEME             NOT NULL,
    status_text              VARCHAR(70)             NOT NULL,
    language                 LANG                    NOT NULL,
    notifications_and_sounds JSON                    NOT NULL,
    created_at               TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_user_settings_user_id FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

ALTER TABLE users
    ADD COLUMN birthday TIMESTAMP;
ALTER TABLE users
    ALTER COLUMN birthday TYPE DATE,
    ALTER COLUMN birthday SET NOT NULL;
ALTER TABLE users
    RENAME COLUMN birthday to date_of_birth;
ALTER TABLE users
    DROP COLUMN date_of_birth;

CREATE TABLE IF NOT EXISTS private_messages
(
    id          BIGSERIAL PRIMARY KEY,
    sender_id   BIGINT                  NOT NULL,
    receiver_id BIGINT                  NOT NULL,
    media_type  MEDIA_TYPE              NOT NULL,
    body        TEXT,
    filename    VARCHAR(200)            NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    reply_to_id BIGINT                  NULL,
    CONSTRAINT fk_p_m_reply_to_id FOREIGN KEY (reply_to_id) REFERENCES private_messages (id),
    CONSTRAINT fk_p_m_sender_id FOREIGN KEY (sender_id) REFERENCES users (id),
    CONSTRAINT fk_p_m_receiver_id FOREIGN KEY (receiver_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS groups
(
    id            BIGSERIAL PRIMARY KEY,
    title         VARCHAR(45)             NOT NULL,
    icon          VARCHAR(45)             NULL,
    invite_link   VARCHAR(100)            NOT NULL,
    settings      JSON                    NOT NULL,
    owner_user_id BIGINT                  NOT NULL,
    is_private    BOOLEAN                 NOT NULL,
    created_at    TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT fk_groups_owner_user_id FOREIGN KEY (owner_user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS group_members
(
    id         BIGSERIAL PRIMARY KEY,
    group_id   BIGINT NOT NULL,
    user_id    BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_g_m_group_id FOREIGN KEY (group_id) REFERENCES groups (id),
    CONSTRAINT fk_g_m_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS group_messages
(
    id          BIGSERIAL PRIMARY KEY,
    group_id    BIGINT                  NOT NULL,
    sender_id   BIGINT                  NOT NULL,
    reply_to_id BIGINT                  NULL,
    media_type  MEDIA_TYPE              NOT NULL,
    body        TEXT                    NOT NULL,
    filename    VARCHAR(100)            NULL,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,

    CONSTRAINT fk_g_msg_group_id FOREIGN KEY (group_id) REFERENCES groups (id),
    CONSTRAINT fk_g_msg_sender_id FOREIGN KEY (sender_id) REFERENCES users (id),
    CONSTRAINT fk_g_msg_reply_to_id FOREIGN KEY (reply_to_id) REFERENCES group_messages (id)
);

CREATE TABLE IF NOT EXISTS channels
(
    id            BIGSERIAL PRIMARY KEY,
    title         VARCHAR(45)             NOT NULL,
    icon          VARCHAR(45)             NULL,
    invite_link   VARCHAR(45)             NOT NULL,
    settings      JSON                    NOT NULL,
    owner_user_id BIGINT                  NOT NULL,
    is_private    BOOLEAN,
    created_ad    TIMESTAMP DEFAULT NOW() NOT NULL,

    CONSTRAINT fk_channels_owner_user_id FOREIGN KEY (owner_user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS channel_subscribers
(
    channel_id BIGINT                  NOT NULL,
    user_id    BIGINT                  NOT NULL,
    status     STATUS                  NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,

    CONSTRAINT pk_channel_user PRIMARY KEY (channel_id, user_id),
    CONSTRAINT fk_channel_id FOREIGN KEY (channel_id) REFERENCES channels (id),
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS channel_messages
(
    id         BIGSERIAL PRIMARY KEY,
    channel_id BIGINT       NOT NULL,
    sender_id  BIGINT       NOT NULL,
    media_type MEDIA_TYPE   NOT NULL,
    body       TEXT,
    filename   VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_channel_messages_channel_id FOREIGN KEY (channel_id) REFERENCES channels (id),
    CONSTRAINT fk_channel_messages_sender_id FOREIGN KEY (sender_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS saved_messages
(
    id         BIGSERIAL PRIMARY KEY,
    user_id    BIGINT NOT NULL,
    body       TEXT,
    created_at TIMESTAMP DEFAULT NOW(),

    CONSTRAINT saved_messages_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS reactions_list
(
    id   BIGSERIAL PRIMARY KEY,
    code TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS private_message_reactions
(
    reaction_id BIGINT NOT NULL,
    message_id  BIGINT NOT NULL,
    user_id     BIGINT NOT NULL,

    CONSTRAINT fk_private_message_reactions_reaction_id FOREIGN KEY (reaction_id) REFERENCES reactions_list (id),
    CONSTRAINT fk_private_message_reactions_message_id FOREIGN KEY (message_id) REFERENCES private_messages (id),
    CONSTRAINT fk_private_message_reactions_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS channel_message_reactions
(
    reaction_id BIGINT NOT NULL,
    message_id  BIGINT NOT NULL,
    user_id     BIGINT NOT NULL,

    CONSTRAINT fk_private_message_reactions_reaction_id FOREIGN KEY (reaction_id) REFERENCES reactions_list (id),
    CONSTRAINT fk_private_message_reactions_message_id FOREIGN KEY (message_id) REFERENCES channel_messages (id),
    CONSTRAINT fk_private_message_reactions_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS group_message_reactions
(
    reaction_id BIGINT NOT NULL,
    message_id  BIGINT NOT NULL,
    user_id     BIGINT NOT NULL,

    CONSTRAINT fk_private_message_reactions_reaction_id FOREIGN KEY (reaction_id) REFERENCES reactions_list (id),
    CONSTRAINT fk_private_message_reactions_message_id FOREIGN KEY (message_id) REFERENCES group_messages (id),
    CONSTRAINT fk_private_message_reactions_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS stories
(
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL,
    caption     VARCHAR(140),
    filename    VARCHAR(100),
    views_count INT,
    created_at  TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_stories_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS stories_likes
(
    id         BIGSERIAL PRIMARY KEY,
    story_id   BIGINT NOT NULL,
    user_id    BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT stories_likes_story_id FOREIGN KEY (story_id) REFERENCES stories (id),
    CONSTRAINT stories_likes_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);