SET search_path TO telegram;


INSERT INTO users (first_name,  last_name,  login,  email,  hash_password,  phone_number,  birthday) VALUES
('Fabiola', 'Gottlieb', NULL, 'hardy42@example.com', '91a2d21ceb966a9ddbc5d1e42b3880fde4840251', 85374584109, '2021-04-27'), 
('Cordelia', 'Schmidt', NULL, 'pfeffer.julianne@example.org', '5b2d07b33b4ca61bff9fdc087e71f964d23d091f', 47225135553, '1989-11-18'), 
('Elenora', 'Kris', NULL, 'hermann.cora@example.org', '4cf04ada40acc5cf77a29d290813f08485711ad0', 10662280403, '1989-10-12'), 
('Darien', 'Kub', NULL, 'luciano.collins@example.org', 'e87f1063ac8b46d4e3f9ca81a15e445897d23176', 42114946271, '1981-09-29'), 
('Janae', 'Kovacek', NULL, 'carmella97@example.org', 'b909da581364805b1d8b9b680dd8b4f88048bd00', 43388084081, '2023-02-24'), 
('Malinda', 'Hoeger', NULL, 'estel86@example.net', '11c13c310474fd7677bf5cc67710dfdcc9194cbe', 35871010050, '2004-05-04'), 
('Morgan', 'Farrell', NULL, 'koby41@example.com', '50b60efecfec1bffdd842c0fb027a97c0788df56', 75004207760, '1972-03-21'), 
('Aron', 'Zieme', NULL, 'mittie.macejkovic@example.com', '0f4990fd6d6515cc7d92ee08f70a9d2005cae417', 75559328704, '2010-03-25'), 
('Cristobal', 'Tromp', NULL, 'chris.berge@example.net', '26004be36bf0027f1f1c05a856c9672c21e3786d', 27258759419, '1974-06-15');

INSERT INTO channels VALUES
(1,  'Et sunt aut soluta ex.',  'eveniet', 'http://huel.com/',   NULL,  1,  TRUE,  '1979-05-18 00:38:14'), 
(2,  'In cumque aut deleniti enim culpa.',  'libero',  'http://www.lednerraynor.com/',  NULL,  2,  FALSE,  '1975-08-30 21:00:37'), 
(3,  'Dolorum repellat sequi excepturi commodi qui ',  'quia',  'http://ortizzboncak.com/', NULL, 3,  TRUE,  '1975-04-06 12:37:26'), 
(4,  'Illo sit minus sunt.', 'nihil',  'http://www.tillman.com/',  NULL,  4,  FALSE,  '1973-11-13 20:22:22'), 
(5,  'Dolor sed consequuntur aperiam.',  'culpa',  'http://www.grant.com/',  NULL,  5,  TRUE,  '2012-12-29 18:27:20');

INSERT INTO groups VALUES
(1, 'Sit natus qui omnis voluptatum magni commodi ', 'blanditiis', 'http://pacocha.com/', NULL, 1, FALSE, '1977-02-20 10:45:38'), 
(2, 'Dolor beatae ut sit distinctio velit quis.', 'et', 'http://www.kuhic.com/', NULL, 4, TRUE, '1972-11-12 08:45:24'), 
(3, 'Et atque est et est.', 'dicta', 'http://kozeyortiz.com/', NULL, 1, TRUE, '1983-04-11 02:27:49'),
(4, 'Aut et suscipit autem aperiam.', 'rerum', 'http://www.zemlak.com/', NULL, 1, FALSE, '1978-04-12 06:48:13'),
(5, 'Omnis hic sapiente recusandae impedit.', 'veniam', 'http://kilback.com/', NULL, 3, FALSE, '1986-01-15 12:06:48');

INSERT INTO stories VALUES
(1, 1, 'Velit iusto dolorem sed soluta amet.', 'nihil', 6170, '1986-06-04 19:32:16'), 
(2, 2, 'Quibusdam sit eos ut omnis ratione.', 'laborum', 5252869, '1977-04-06 09:19:28'), 
(3, 3, 'Corrupti praesentium quos cupiditate omnis neque veritatis reiciendis.', 'est', 63127, '1987-07-16 03:49:04'), 
(4, 4, 'Placeat magni ut provident eos nemo distinctio.', 'illum', 9017, '1991-07-04 04:26:14'), 
(5, 5, 'Omnis id in ut enim dolore et quisquam velit.', 'accusamus', 50903580, '2005-10-10 23:22:18');

INSERT INTO reactions_list (code) VALUES
('👍'),
('👎'),
('🙂'),
('😢'),
('😋'),
('😡'),
('🔥'),
('❤️'),
('🖐️'),
('🙃');

INSERT INTO channel_messages VALUES
(1, 1, 1, 'audio', 'Eum nam est quia distinctio pariatur. Aperiam possimus ut et et saepe voluptas facilis saepe. Et qui sit nostrum quis quis deserunt.', 'reiciendis', '2002-07-01 09:50:57'),
(2, 2, 2, 'text', 'Placeat et quia voluptatem eos accusamus quia suscipit. Inventore officiis quam et deserunt doloribus. Voluptas et dolores porro ad nostrum.', 'consequatur', '1989-02-14 18:13:35'),
(3, 3, 3, 'text', 'Doloribus fugit aut et occaecati corrupti repellat et. Autem nihil laudantium vitae. Ex nulla dicta atque repellat a dolor ipsa exercitationem.', 'non', '2002-05-16 03:45:02'),
(4, 4, 4, 'video', 'Suscipit sint voluptate modi. Rem architecto ratione omnis tempora.', 'aut', '1974-04-29 13:24:43'),
(5, 5, 5, 'image', 'Unde praesentium eos rem aliquam est reiciendis quae blanditiis. Explicabo error et adipisci nihil dignissimos. Porro amet adipisci ipsa aliquid quis ex sapiente.', 'aut', '1972-06-28 20:35:27');

INSERT INTO channel_message_reactions VALUES
(1, 1, 1, '2023-10-17 17:41:48'), 
(2, 2, 2, '1989-05-27 12:45:43'), 
(3, 3, 3, '2020-05-31 09:36:56'), 
(4, 4, 4, '1983-02-02 19:00:28'), 
(5, 5, 5, '1975-11-18 20:29:05');

INSERT INTO channel_subscribers VALUES
(1, 1, 'requested', '1992-08-16 12:30:06'),
(1, 2, 'joined', '1982-08-14 20:24:05'),
(1, 3, 'joined', '2023-02-16 18:02:53'),
(1, 4, 'joined', '1979-02-21 12:06:24'),
(1, 5, 'joined', '1985-05-17 09:51:01');

INSERT INTO group_members VALUES
(1, 1, 1, '1993-04-24 22:38:10'), 
(2, 2, 2, '1988-12-17 18:06:23'), 
(3, 3, 3, '1974-12-02 13:18:28'), 
(4, 4, 4, '2006-07-06 03:52:44'), 
(5, 5, 5, '1978-11-07 21:26:52');

INSERT INTO group_messages VALUES
(1, 1, 2, NULL, 'audio', 'Maiores veritatis quod vitae ut cum. Aut et fugiat omnis minima id a commodi. Dolor iure magni dolor exercitationem rerum dolores aspernatur labore.', 'sapiente', '2000-06-28 15:12:12'),
(2, 1, 3, 1, 'video', 'Autem eveniet et et dolore quisquam et. Deserunt rem ut qui officiis explicabo.', 'ea', '2019-09-22 17:52:45'),
(3, 1, 4, 2, 'image', 'Et rerum ex ex provident perferendis. Molestiae voluptas ut et consequuntur. Ut hic quibusdam omnis voluptatum adipisci.', 'id', '1977-03-21 06:23:09'),
(4, 1, 5, 3, 'image', 'Reprehenderit eius consequuntur officiis iusto delectus. Dolorem veritatis asperiores consequatur aut rerum nostrum eum. Qui molestias dignissimos nisi nemo eveniet. Laborum nihil et ut quia et dolorem ut consequatur.', 'reprehenderit', '2017-09-21 04:14:41'),
(5, 1, 2, NULL, 'video', 'Animi nostrum fugiat quidem cumque et itaque qui. Cum omnis cum corporis quia corporis eveniet. Temporibus vel sapiente laboriosam sequi voluptatem et sit cum. Est eaque modi esse sint.', 'dolorem', '2014-06-25 09:33:54'),
(6, 1, 2, 5, 'video', 'Velit quidem cum officiis aperiam. Qui id pariatur amet corrupti. Sit laudantium quasi minus vitae. Accusantium dolores inventore ut sit recusandae qui aut.', 'esse', '1979-01-19 00:26:52'),
(7, 1, 3, 6, 'video', 'Quisquam et molestiae nobis vel molestiae sint. Itaque recusandae nam magni molestiae dolores nihil. Et recusandae sed suscipit. Aut nisi omnis tempora quas sit quia ut.', 'amet', '1998-06-24 13:39:41'),
(8, 1, 4, NULL, 'image', 'Aspernatur quod est ut ut voluptatum vitae ut. Amet ut et cumque. Aut dolor praesentium ea magnam laboriosam.', 'neque', '2020-08-09 02:19:12'),
(9, 1, 7, 8, 'text', 'Nesciunt dolor omnis voluptas. Occaecati consectetur debitis dolore modi sunt ab libero minus. Aut quam neque ut maiores. Id earum fugit voluptatem non doloribus atque. Quo neque non et corrupti incidunt.', 'ipsam', '1985-10-22 08:24:52');

INSERT INTO group_message_reactions VALUES
(1, 1, 1, '1979-01-24 20:23:12'), 
(1, 2, 1, '2019-07-26 12:05:10'),
(1, 3, 2, '1972-07-11 06:01:18'),
(6, 4, 4, '2019-01-30 09:54:14'), 
(7, 5, 5, '1985-06-05 13:19:07');

INSERT INTO private_messages (sender_id, receiver_id, media_type, body, filename, created_at, is_read) VALUES
(1, 2, 'audio', 'Maiores veritatis quod vitae ut cum. Aut et fugiat omnis minima id a commodi. Dolor iure magni dolor exercitationem rerum dolores aspernatur labore.', 'sapiente', '2000-06-28 15:12:12', FALSE),
(2, 3, 'video', 'Autem eveniet et et dolore quisquam et. Deserunt rem ut qui officiis explicabo.', 'ea', '2019-09-22 17:52:45', TRUE),
(3, 4, 'image', 'Et rerum ex ex provident perferendis. Molestiae voluptas ut et consequuntur. Ut hic quibusdam omnis voluptatum adipisci.', 'id', '1977-03-21 06:23:09', TRUE),
(4, 5, 'image', 'Reprehenderit eius consequuntur officiis iusto delectus. Dolorem veritatis asperiores consequatur aut rerum nostrum eum. Qui molestias dignissimos nisi nemo eveniet. Laborum nihil et ut quia et dolorem ut consequatur.', 'reprehenderit', '2017-09-21 04:14:41', TRUE),
(5, 2, 'video', 'Animi nostrum fugiat quidem cumque et itaque qui. Cum omnis cum corporis quia corporis eveniet. Temporibus vel sapiente laboriosam sequi voluptatem et sit cum. Est eaque modi esse sint.', 'dolorem', '2014-06-25 09:33:54', FALSE);

INSERT INTO saved_messages VALUES
(1, 1, 'Alias labore dolores dignissimos perferendis repellendus dolore deleniti veniam. Et eum aspernatur quo nesciunt sunt. Deserunt quia natus asperiores cum est. Qui ut voluptas cum qui.', '1993-11-29 05:55:15'), 
(2, 2, 'Qui quas ea reprehenderit facere. Quia ab nemo nisi quia et vitae aut. Est quia et aut officia nam. Iure mollitia similique a. Distinctio sed sint autem cupiditate qui aspernatur.', '2009-04-01 09:26:35'), 
(3, 3, 'Doloremque fugiat nesciunt cumque corrupti odio et. Cupiditate sint eum incidunt quaerat dicta similique. Alias eum sapiente odio animi. Ratione numquam aut beatae similique accusantium.', '1979-01-22 21:29:46'), 
(4, 4, 'Id illum eos vero et harum cupiditate. Reprehenderit eius non nulla quibusdam. Ut ea est temporibus non nam.', '1997-12-05 05:40:58'), 
(5, 5, 'Sed iusto ex tempore et est aut fuga. Eos omnis quibusdam autem. Rerum vitae expedita odit et quaerat.', '1989-01-28 09:15:13');

INSERT INTO stories_likes VALUES
(1, 1, 1, '2002-05-24 05:07:29'), 
(2, 2, 2, '1993-10-25 10:43:17'), 
(3, 3, 3, '1987-01-16 15:01:07'), 
(4, 4, 4, '1990-08-11 22:27:55'), 
(5, 5, 5, '1990-11-17 15:19:33');