CREATE OR REPLACE FUNCTION insert_into_messages(
	data JSON
) RETURNS INTEGER
AS $$
	DECLARE _message_id INTEGER;
	
	BEGIN
		INSERT INTO messages(message_id_tg)
		VALUES((data->>'message_id_tg')::INTEGER) RETURNING message_id INTO _message_id;
		
		RETURN _message_id;
	END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION insert_into_messages_info(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_info
	VALUES(
		message_id
	,	(data->>'date')::TIMESTAMP
	,	(SELECT type_id FROM message_type AS mt WHERE mt.type = data->>'type')
	,	(SELECT content_type_id FROM message_content_type AS mct WHERE mct.content_type = data->>'content_type')
	,	(data->>'user_id_tg')::INTEGER
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_forward_from_chat(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_forward_from_chat
	VALUES(
		message_id
	,	(data->>'chat_id')::BIGINT
	,	(data->>'type')
	,	(data->>'title')
	,	(data->>'username')
	,	(data->>'first_name')
	,	(data->>'last_name')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_forward_from_user(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_forward_from_user
	VALUES(
		message_id
	,	(data->>'user_id')::INTEGER
	,	(data->>'is_bot')::BOOL
	,	(data->>'username')
	,	(data->>'first_name')
	,	(data->>'last_name')
	,	(data->>'full_name')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_text(
	message_id INTEGER
,	data TEXT
) RETURNS void
AS $$
	INSERT INTO messages_text
	VALUES(
		message_id
	,	data
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_links(
	message_id INTEGER
,	links JSON
) RETURNS void
AS $$
	DECLARE 
		_link TEXT;
		_links TEXT[];
	BEGIN
		SELECT array_agg(ary)::TEXT[] FROM json_array_elements_text(links) AS ary INTO _links;

		FOREACH _link IN ARRAY _links LOOP
			INSERT INTO messages_links
			VALUES(
				message_id
			,	_link::TEXT
			);
		END LOOP;
	END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION insert_into_messages_words(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_words
	VALUES(
		message_id
	,	(data->>'word_count')::SMALLINT
	,	(SELECT array_agg(ary)::TEXT[] FROM json_array_elements_text(data->'words') AS ary)
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_photos(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_photos
	VALUES(
		message_id
	,	(data->>'file_id')
	,	(data->>'unique_file_id')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_videos(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_videos
	VALUES(
		message_id
	,	(data->>'file_id')
	,	(data->>'unique_file_id')
	,	(data->>'duration')::SMALLINT
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_documents(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_documents
	VALUES(
		message_id
	,	(data->>'file_id')
	,	(data->>'unique_file_id')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_animations(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_animations
	VALUES(
		message_id
	,	(data->>'file_id')
	,	(data->>'unique_file_id')
	,	(data->>'duration')::SMALLINT
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_audios(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_audios
	VALUES(
		message_id
	,	(data->>'file_id')
	,	(data->>'unique_file_id')
	,	(data->>'duration')::SMALLINT
	,	(data->>'performer')
	,	(data->>'title')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_voices(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_voices
	VALUES(
		message_id
	,	(data->>'file_id')
	,	(data->>'unique_file_id')
	,	(data->>'duration')::SMALLINT
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_stickers(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_stickers
	VALUES(
		message_id
	,	(data->>'file_id')
	,	(data->>'unique_file_id')
	,	(data->>'type')
	,	(data->>'is_animated')::BOOL
	,	(data->>'is_video')::BOOL
	,	(data->>'set_name')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages_polls(
	message_id INTEGER
,	data JSON
) RETURNS void
AS $$
	INSERT INTO messages_polls
	VALUES(
		message_id
	,	(data->>'poll_id')
	,	(data->>'question')
	,	(SELECT array_agg(ary)::TEXT[] FROM json_array_elements_text(data->'options') AS ary)
	,	(data->>'is_anonymous')::BOOL
	,	(data->>'allows_multiple_answers')::BOOL
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_message(
	data JSON
) RETURNS void
AS $$
	DECLARE
		_message_id INTEGER;
		_message_info JSON;
		_forward_from_chat JSON;
		_forward_from_user JSON;
		_text TEXT;
		_links JSON;
		_words JSON;
		_photo JSON;
		_video JSON;
		_document JSON;
		_animation JSON;
		_audio JSON;
		_voice JSON;
		_sticker JSON;
		_poll JSON;
		
	BEGIN
		SELECT data->'message_info' INTO _message_info;
		SELECT data->'forward_from_chat' INTO _forward_from_chat;
		SELECT data->'forward_from_user' INTO _forward_from_user;
		SELECT data->>'text' INTO _text;
		SELECT data->'links' INTO _links;
		SELECT data->'words' INTO _words;
		SELECT data->'photo' INTO _photo;
		SELECT data->'video' INTO _video;
		SELECT data->'document' INTO _document;
		SELECT data->'animation' INTO _animation;
		SELECT data->'audio' INTO _audio;
		SELECT data->'voice' INTO _voice;
		SELECT data->'sticker' INTO _sticker;
		SELECT data->'poll' INTO _poll;
		
		_message_id:= insert_into_messages(_message_info);
		
		PERFORM insert_into_messages_info(_message_id, _message_info);

		IF json_typeof(_forward_from_chat) != 'null' THEN
			PERFORM insert_into_messages_forward_from_chat(_message_id, _forward_from_chat);
		END IF;
		
		IF json_typeof(_forward_from_user) != 'null' THEN
			PERFORM insert_into_messages_forward_from_user(_message_id, _forward_from_user);
		END IF;
		
		IF _text IS NOT NULL THEN
			PERFORM insert_into_messages_text(_message_id, _text);
		END IF;
		
		IF json_typeof(_links) != 'null' THEN
			PERFORM insert_into_messages_links(_message_id, _links);
		END IF;
		
		IF json_typeof(_words) != 'null' THEN
			PERFORM insert_into_messages_words(_message_id, _words);
		END IF;
		
		IF json_typeof(_photo) != 'null' THEN
			PERFORM insert_into_messages_photos(_message_id, _photo);
		END IF;
		
		IF json_typeof(_video) != 'null' THEN
			PERFORM insert_into_messages_videos(_message_id, _video);
		END IF;
		
		IF json_typeof(_document) != 'null' THEN
			PERFORM insert_into_messages_documents(_message_id, _document);
		END IF;
		
		IF json_typeof(_animation) != 'null' THEN
			PERFORM insert_into_messages_animations(_message_id, _animation);
		END IF;
		
		IF json_typeof(_audio) != 'null' THEN
			PERFORM insert_into_messages_audios(_message_id, _audio);
		END IF;
		
		IF json_typeof(_voice) != 'null' THEN
			PERFORM insert_into_messages_voices(_message_id, _voice);
		END IF;
		
		IF json_typeof(_sticker) != 'null' THEN
			PERFORM insert_into_messages_stickers(_message_id, _sticker);
		END IF;
		
		IF json_typeof(_poll) != 'null' THEN
			PERFORM insert_into_messages_polls(_message_id, _poll);
		END IF;
	END;
	
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION set_user(
	data JSON
) RETURNS void
AS $$
	
	DECLARE 
		_user_id_tg INTEGER;
		_username TEXT;
		_first_name TEXT;
		_last_name TEXT;
		_full_name TEXT;
		_birthday DATE;
	BEGIN
		SELECT (data->>'user_id_tg')::INTEGER INTO _user_id_tg;
		SELECT (data->>'username') INTO _username;
		SELECT (data->>'first_name') INTO _first_name;
		SELECT (data->>'last_name') INTO _last_name;
		SELECT (data->>'full_name') INTO _full_name;
		SELECT (data->>'birthday')::DATE INTO _birthday;

		IF _birthday IS NULL THEN
			INSERT INTO users(user_id_tg, username, first_name, last_name, full_name)
			VALUES (
				_user_id_tg
			,	_username
			,	_first_name
			,   _last_name
			,	_full_name
			) ON CONFLICT(user_id_tg) DO UPDATE SET
					username = _username
				,	first_name = _first_name
				,	last_name = _last_name
				,	full_name = _full_name;
		ELSE
			INSERT INTO users(user_id_tg, username, first_name, last_name, full_name, birthday)
			VALUES (
				_user_id_tg
			,	_username
			,	_first_name
			,   _last_name
			,	_full_name
			,	_birthday
			) ON CONFLICT(user_id_tg) DO UPDATE SET
					username = _username
				,	first_name = _first_name
				,	last_name = _last_name
				,	full_name = _full_name
				,	birthday = _birthday;
		END IF;
	END;
$$ LANGUAGE plpgsql;