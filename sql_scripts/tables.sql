DROP TABLE IF EXISTS chats CASCADE;
CREATE TABLE chats(
	chat_id BIGINT
,	type TEXT NOT NULL
,	title TEXT
,	username TEXT
,	first_name TEXT
,	last_name TEXT
,	full_name TEXT NOT NULL
,	last_update TIMESTAMP
,	CONSTRAINT pk_chat_id PRIMARY KEY(chat_id)
);




DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users(
	user_id_tg INTEGER
,	is_bot BOOL NOT NULL
,	username TEXT
,	first_name TEXT
,	last_name TEXT
,	full_name TEXT NOT NULL
,	birthday DATE
,	last_update TIMESTAMP
,	CONSTRAINT pk_user_id_tg PRIMARY KEY(user_id_tg)
);




DROP TABLE IF EXISTS message_types CASCADE;
CREATE TABLE message_types(
	type_id SMALLSERIAL
,	type TEXT UNIQUE NOT NULL
,	CONSTRAINT pk_type_id PRIMARY KEY(type_id)
);
INSERT INTO message_types(type)
VALUES 
	('regular_message')
,   ('reply_to_message')
,	('forward_from_chat')
,	('forward_from_user');




DROP TABLE IF EXISTS message_content_types CASCADE;
CREATE TABLE message_content_types(
	content_type_id SMALLSERIAL
,	content_type TEXT UNIQUE NOT NULL
,	CONSTRAINT pk_content_type_id PRIMARY KEY(content_type_id)
);
INSERT INTO message_content_types(content_type)
VALUES
	('text')
,	('photo')
,	('video')
,	('document')
,	('animation')
,	('sticker')
,	('audio')
,	('poll')
,	('voice');




DROP TABLE IF EXISTS messages CASCADE;
CREATE TABLE messages(
	message_id SERIAL
,	message_id_tg INTEGER NOT NULL
,	user_id_tg INTEGER NOT NULL
,	date TIMESTAMP NOT NULL
,	type_id SMALLINT NOT NULL
,	content_type_id SMALLINT NOT NULL
,	CONSTRAINT pk_message_id PRIMARY KEY(message_id)
,	CONSTRAINT fk_type_id FOREIGN KEY(type_id) REFERENCES message_types(type_id)
,	CONSTRAINT fk_content_type_id FOREIGN KEY(content_type_id) REFERENCES message_content_types(content_type_id)
);




DROP TABLE IF EXISTS message_text CASCADE;
CREATE TABLE message_text(
	message_id INTEGER
,	text TEXT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS message_link CASCADE;
CREATE TABLE message_link(
	message_id INTEGER
,	link TEXT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS message_word CASCADE;
CREATE TABLE message_word(
	message_id INTEGER
,	words TEXT[] NOT NULL
,	word_count SMALLINT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS forward_from_user CASCADE;
CREATE TABLE forward_from_user(
	message_id INTEGER
,	user_id_tg BIGINT
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
,	CONSTRAINT fk_user_id_tg FOREIGN KEY(user_id_tg) REFERENCES users(user_id_tg)
);




DROP TABLE IF EXISTS forward_from_chat CASCADE;
CREATE TABLE forward_from_chat(
	message_id INTEGER
,	chat_id BIGINT
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
,	CONSTRAINT fk_chat_id FOREIGN KEY(chat_id) REFERENCES chats(chat_id)
);




DROP TABLE IF EXISTS reply_to_message CASCADE;
CREATE TABLE reply_to_message(
	message_id INTEGER
,	reply_to_message_id_tg INTEGER NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS message_photo CASCADE;
CREATE TABLE message_photo(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	file_unique_id TEXT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS message_video CASCADE;
CREATE TABLE message_video(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	file_unique_id TEXT NOT NULL
,	duration SMALLINT NOT NULL
,	file_name TEXT
,	mime_type TEXT
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS message_sticker CASCADE;
CREATE TABLE message_sticker(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	file_unique_id TEXT NOT NULL
,	type TEXT NOT NULL
,	is_animated BOOL NOT NULL
,	is_video BOOL NOT NULL
,	emoji TEXT
,	set_name TEXT
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS message_animation CASCADE;
CREATE TABLE message_animation(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	file_unique_id TEXT NOT NULL
,	duration SMALLINT NOT NULL
,	file_name TEXT
,	mime_type TEXT
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS message_poll CASCADE;
CREATE TABLE message_poll(
	message_id INTEGER
,	poll_id TEXT NOT NULL
,	question TEXT NOT NULL
,	options TEXT[] NOT NULL
,	is_anonymous BOOL NOT NULL
,	allows_multiple_answers BOOL NOT NULL
,	type TEXT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS message_document CASCADE;
CREATE TABLE message_document(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	file_unique_id TEXT NOT NULL
,	file_name TEXT
,	mime_type TEXT
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS message_audio CASCADE;
CREATE TABLE message_audio(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	file_unique_id TEXT NOT NULL
,	duration SMALLINT NOT NULL
,	performer TEXT
,	title TEXT
,	file_name TEXT
,	mime_type TEXT
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);




DROP TABLE IF EXISTS message_voice CASCADE;
CREATE TABLE message_voice(
	message_id INTEGER
,	file_id TEXT NOT NULL
,	file_unique_id TEXT NOT NULL
,	duration SMALLINT NOT NULL
,	CONSTRAINT fk_message_id FOREIGN KEY(message_id) REFERENCES messages(message_id)
);