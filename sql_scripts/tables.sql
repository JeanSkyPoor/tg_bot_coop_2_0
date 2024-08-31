/*Создание таблицы с юзерами*/
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users(
	user_id_tg INTEGER UNIQUE NOT NULL
,	username TEXT DEFAULT NULL
,	first_name TEXT NOT NULL
,	last_name TEXT DEFAULT NULL
,	full_name TEXT NOT NULL
,	birthday DATE DEFAULT NULL
);




/*Создание таблицы с контент типами сообщений \ content_type*/
DROP TABLE IF EXISTS message_content_type CASCADE;
CREATE TABLE message_content_type(
	content_type_id SMALLSERIAL
,	content_type VARCHAR(25) UNIQUE NOT NULL
,	CONSTRAINT pk_content_type_id PRIMARY KEY(content_type_id)
);
INSERT INTO message_content_type(content_type)
VALUES
	('TEXT')
,	('PHOTO')
,	('VIDEO')
,	('DOCUMENT')
,	('ANIMATION')
,	('STICKER')
,	('AUDIO')
,	('POLL')
,	('VOICE');




/*Создание таблицы с типами сообщений*/
DROP TABLE IF EXISTS message_type CASCADE;
CREATE TABLE message_type(
	type_id SMALLSERIAL
,	type VARCHAR(30) UNIQUE NOT NULL
,	CONSTRAINT pk_type_id PRIMARY KEY(type_id)
);
INSERT INTO message_type(type)
VALUES
	('regular_message')
,	('forward_from_user')
,	('forward_from_chat');




/*Создание таблицы с сообщениями*/
DROP TABLE IF EXISTS messages CASCADE;
CREATE TABLE messages(
	message_id SERIAL
,	message_id_tg INTEGER UNIQUE NOT NULL
,	CONSTRAINT pk_message_id PRIMARY KEY(message_id)
);




/*Создание таблицы с описанием сообщений*/
DROP TABLE IF EXISTS messages_info CASCADE;
CREATE TABLE messages_info(
	message_id INTEGER
,	date TIMESTAMP NOT NULL
,	type_id SMALLINT NOT NULL
,	content_type_id SMALLINT NOT NULL
,	user_id_tg INTEGER NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
,	CONSTRAINT fk_type_id FOREIGN KEY(type_id) REFERENCES message_type(type_id)
,	CONSTRAINT fk_content_type_id FOREIGN KEY(content_type_id) REFERENCES message_content_type(content_type_id)
);




/*Создание таблицы с информацией по чату для пересланного сообщения*/
DROP TABLE IF EXISTS messages_forward_from_chat CASCADE;
CREATE TABLE messages_forward_from_chat(
	message_id INTEGER
,	chat_id INTEGER NOT NULL
,	type TEXT NOT NULL
,	title TEXT DEFAULT NULL
,	username TEXT DEFAULT NULL
,	first_name TEXT DEFAULT NULL
,	last_name TEXT DEFAULT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




/*Создание таблицы с информацией по кастомеру для пересланного сообщения*/
DROP TABLE IF EXISTS messages_forward_from_user CASCADE;
CREATE TABLE messages_forward_from_user(
	message_id INTEGER
,	user_id INTEGER NOT NULL
,	is_bot BOOL NOT NULL
,	username TEXT DEFAULT NULL
,	first_name TEXT
,	last_name TEXT DEFAULT NULL
,	full_name TEXT
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);



/*Создание таблицы с текстом или кепшион сообщений*/
DROP TABLE IF EXISTS messages_text CASCADE;
CREATE TABLE messages_text(
	message_id INTEGER
,	text TEXT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




/*Создание таблицы со словами в сообщении*/
DROP TABLE IF EXISTS messages_words CASCADE;
CREATE TABLE messages_words(
	message_id INTEGER
,	word_count SMALLINT NOT NULL
,	words TEXT[] NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




/*Создание таблицы с линками*/
DROP TABLE IF EXISTS messages_links CASCADE;
CREATE TABLE messages_links(
	message_id INTEGER
,	link TEXT[] NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




/*Создание таблицы с информацией по фотографиям или картинкам*/
DROP TABLE IF EXISTS messages_photos CASCADE;
CREATE TABLE messages_photos(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	unique_file_id TEXT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




/*Создание таблицы с информацией по видосам*/
DROP TABLE IF EXISTS messages_videos CASCADE;
CREATE TABLE messages_videos(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	unique_file_id TEXT NOT NULL
,	duration SMALLINT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




/*Создание таблицы с информацией по документам*/
DROP TABLE IF EXISTS messages_documents CASCADE;
CREATE TABLE messages_documents(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	unique_file_id TEXT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




/*Создание таблицы с информацией по гифкам*/
DROP TABLE IF EXISTS messages_animations CASCADE;
CREATE TABLE messages_animations(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	unique_file_id TEXT NOT NULL
,	duration SMALLINT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);



/*Создание таблицы с информацией по аудиофайлам*/
DROP TABLE IF EXISTS messages_audios CASCADE;
CREATE TABLE messages_audios(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	unique_file_id TEXT NOT NULL
,	duration SMALLINT NOT NULL
,	performer TEXT DEFAULT NULL
,	title TEXT DEFAULT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);



/*Создание таблицы с голосовухами*/
DROP TABLE IF EXISTS messages_voices CASCADE;
CREATE TABLE messages_voices(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	unique_file_id TEXT NULL
,	duration SMALLINT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




/*Создание таблицы с информацией со стикерами*/
DROP TABLE IF EXISTS messages_stickers CASCADE;
CREATE TABLE messages_stickers(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	unique_file_id TEXT NOT NULL
,	type TEXT NOT NULL
,	is_animated BOOL NOT NULL
,	is_video BOOL NOT NULL
,	set_name TEXT DEFAULT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);



/*Создание таблицы с опросами*/
DROP TABLE IF EXISTS messages_polls CASCADE;
CREATE TABLE messages_polls(
	message_id INTEGER
,	poll_id TEXT NOT NULL
,	question TEXT NOT NULL
,	options TEXT[] NOT NULL
,	is_anonymous BOOL NOT NULL
,	allows_multiple_answers BOOL NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);