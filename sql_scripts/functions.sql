CREATE OR REPLACE FUNCTION insert_into_message_sticker(
	message_id INTEGER
,	sticker_part JSON
) RETURNS void AS $$

	INSERT INTO message_sticker
	VALUES(
		message_id
	,	(sticker_part->>'file_id')
	,	(sticker_part->>'file_unique_id')
	,	(sticker_part->>'type')
	,	(sticker_part->>'is_animated')::BOOL
	,	(sticker_part->>'is_video')::BOOL
	,	(sticker_part->>'emoji')
	,	(sticker_part->>'set_name')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_message_poll(
	message_id INTEGER
,	poll_part JSON
) RETURNS void AS $$

	INSERT INTO message_poll
	VALUES(
		message_id
	,	(poll_part->>'id')
	,	(poll_part->>'question')
	,	(SELECT array_agg(ary)::TEXT[] FROM json_array_elements_text(poll_part->'options') AS ary)
	,	(poll_part->>'is_anonymous')::BOOL
	,	(poll_part->>'allows_multiple_answers')::BOOL
	,	(poll_part->>'type')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_message_photo(
	message_id INTEGER
,	photo_part JSON
) RETURNS void AS $$
	
	INSERT INTO message_photo
	VALUES(
		message_id
	,	(photo_part->>'file_id')
	,	(photo_part->>'file_unique_id')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_message_link(
	message_id INTEGER
,	text_part JSON
) RETURNS void AS $$
	DECLARE 
		_link TEXT;
		_links TEXT[];
	BEGIN
		SELECT array_agg(ary)::TEXT[] FROM json_array_elements_text(text_part->'links') AS ary INTO _links;

		FOREACH _link IN ARRAY _links LOOP
			INSERT INTO message_link
			VALUES(
				message_id
			,	_link::TEXT
			);
		END LOOP;
	END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION insert_into_message_document(
	message_id INTEGER
,	document_part JSON
) RETURNS void AS $$

	INSERT INTO message_document
	VALUES(
		message_id
	,	(document_part->>'file_id')
	,	(document_part->>'file_unique_id')
	,	(document_part->>'file_name')
	,	(document_part->>'mime_type')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_message_animation(
	message_id INTEGER
,	animation_part JSON
) RETURNS void AS $$

	INSERT INTO message_animation
	VALUES(
		message_id
	,	(animation_part->>'file_id')
	,	(animation_part->>'file_unique_id')
	,	(animation_part->>'duration')::SMALLINT
	,	(animation_part->>'file_name')
	,	(animation_part->>'mime_type')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_message_audio(
	message_id INTEGER
,	audio_part JSON
) RETURNS void AS $$

	INSERT INTO message_audio
	VALUES(
		message_id
	,	(audio_part->>'file_id')
	,	(audio_part->>'file_unique_id')
	,	(audio_part->>'duration')::SMALLINT
	,	(audio_part->>'performer')
	,	(audio_part->>'title')
	,	(audio_part->>'file_name')
	,	(audio_part->>'mime_type')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_message_video(
	message_id INTEGER
,	video_part JSON
) RETURNS void AS $$

	INSERT INTO message_video
	VALUES(
		message_id
	,	(video_part->>'file_id')
	,	(video_part->>'file_unique_id')
	,	(video_part->>'duration')::SMALLINT
	,	(video_part->>'file_name')
	,	(video_part->>'mime_type')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_message_voice(
	message_id INTEGER
,	voice_part JSON
) RETURNS void AS $$
	
	INSERT INTO message_voice
	VALUES(
		message_id
	,	(voice_part->>'file_id')
	,	(voice_part->>'file_unique_id')
	,	(voice_part->>'duration')::SMALLINT
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_message_text(
	message_id INTEGER
,	text_part JSON
) RETURNS void AS $$

	INSERT INTO message_text
	VALUES(
		message_id
	,	(text_part->>'text')
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_message_word(
	message_id INTEGER
,	text_part JSON
) RETURNS void AS $$

	INSERT INTO message_word
	VALUES(
		message_id
	,	(SELECT array_agg(ary)::TEXT[] FROM json_array_elements_text(text_part->'words') AS ary)
	,	(text_part->>'words_count')::SMALLINT
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_users(
	user_part JSON
) RETURNS void AS $$
	DECLARE
		_user_id_tg INTEGER;
		_is_bot BOOL;
		_username TEXT;
		_first_name TEXT;
		_last_name TEXT;
		_full_name TEXT;
	BEGIN
		SELECT (user_part->>'id'):: INTEGER INTO _user_id_tg;
		SELECT (user_part->>'is_bot')::BOOL INTO _is_bot;
		SELECT (user_part->>'username') INTO _username;
		SELECT (user_part->>'first_name') INTO _first_name;
		SELECT (user_part->>'last_name') INTO _last_name;
		SELECT (user_part->>'full_name') INTO _full_name;
		
		IF (SELECT user_id_tg FROM users WHERE user_id_tg = _user_id_tg) IS NULL
		THEN
			INSERT INTO users
			VALUES(
				_user_id_tg
			,	_is_bot
			,	_username
			,	_first_name
			,	_last_name
			,	_full_name
			);
		ELSE
			UPDATE users
			SET
				is_bot = _is_bot
			,	username = _username
			,	first_name = _first_name
			,	last_name = _last_name
			,	full_name = _full_name
			WHERE
				user_id_tg = _user_id_tg;
		END IF;
	END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION insert_into_chats(
	chat_part JSON
) RETURNS void AS $$
	DECLARE
		_chat_id BIGINT;
		_type TEXT;
		_title TEXT;
		_username TEXT;
		_first_name TEXT;
		_last_name TEXT;
		_full_name TEXT;
		
	BEGIN
		SELECT (chat_part->>'id')::BIGINT INTO _chat_id;
		SELECT (chat_part->>'type') INTO _type;
		SELECT (chat_part->>'title') INTO _title;
		SELECT (chat_part->>'username') INTO _username;
		SELECT (chat_part->>'first_name') INTO _first_name;
		SELECT (chat_part->>'last_name') INTO _last_name;
		SELECT (chat_part->>'full_name') INTO _full_name;
		
		IF (SELECT chat_id FROM chats WHERE chat_id = _chat_id) IS NULL 
		THEN
			INSERT INTO chats
			VALUES(
				_chat_id
			,	_type
			,	_title
			,	_username
			,	_first_name
			,	_last_name
			,	_full_name
			);
		ELSE
			UPDATE chats
			SET
				type = _type
			,	title = _title
			,	username = _username
			,	first_name = _username
			,	last_name = _last_name
			,	full_name = _full_name
			WHERE
				chat_id = _chat_id;
		END IF;
	END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION insert_into_reply_to_message(
	message_id INTEGER
,	reply_to_message_part JSON
) RETURNS void AS $$
	INSERT INTO reply_to_message
	VALUES(
		message_id
	,	(reply_to_message_part->'message'->>'id')::INTEGER
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_messages(
	message_part JSON
,	user_part JSON
) RETURNS INTEGER AS $$
	DECLARE
		_message_id INTEGER;
	BEGIN
		PERFORM insert_into_users(user_part);
		
		INSERT INTO messages(message_id_tg, user_id_tg, date, type_id, content_type_id)
		VALUES(
			(message_part->>'id')::INTEGER
		,	(user_part->>'id')::INTEGER
		,	(message_part->>'date')::TIMESTAMP
		,	(SELECT type_id FROM message_types AS mt WHERE mt.type = (message_part->>'type'))
		,	(SELECT content_type_id FROM message_content_types WHERE content_type = (message_part->>'content_type'))
		) RETURNING message_id INTO _message_id;
		
	RETURN _message_id;
	
	END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION insert_into_forward_from_chat(
	message_id INTEGER
,	forward_from_chat_part JSON
) RETURNS void AS $$
	
	SELECT insert_into_chats(forward_from_chat_part);
	
	INSERT INTO forward_from_chat
	VALUES(
		message_id
	,	(forward_from_chat_part->>'id')::BIGINT
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_into_forward_from_user(
	message_id INTEGER
,	user_part JSON
) RETURNS void AS $$
	
	INSERT INTO forward_from_user
	VALUES(
		message_id
	,	(user_part->>'id')::BIGINT
	);
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION insert_message(
	data JSON
) RETURNS void AS $$
	DECLARE
		_message_id INTEGER;
		_message_part JSON;
		_user_part JSON;
		_forward_from_chat_part JSON;
		_forward_from_user_part JSON;
		_reply_to_message_part JSON;
		_text_part JSON;
		_photo_part JSON;
		_video_part JSON;
		_document_part JSON;
		_animation_part JSON;
		_audio_part JSON;
		_voice_part JSON;
		_sticker_part JSON;
		_poll_part JSON;
		
	BEGIN
		SELECT (data->'message') INTO _message_part;
		SELECT (data->'user') INTO _user_part;
		SELECT (data->'forward_from_chat') INTO _forward_from_chat_part;
		SELECT (data->'forward_from_user') INTO _forward_from_user_part;
		SELECT (data->'reply_to_message') INTO _reply_to_message_part;
		SELECT (data->'text') INTO _text_part;
		SELECT (data->'photo') INTO _photo_part;
		SELECT (data->'video') INTO _video_part;
		SELECT (data->'document') INTO _document_part;
		SELECT (data->'animation') INTO _animation_part;
		SELECT (data->'audio') INTO _audio_part;
		SELECT (data->'voice') INTO _voice_part;
		SELECT (data->'sticker') INTO _sticker_part;
		SELECT (data->'poll') INTO _poll_part;
		
		_message_id := insert_into_messages(_message_part, _user_part);
		
		IF json_typeof(_forward_from_chat_part) != 'null' 
			THEN PERFORM insert_into_forward_from_chat(_message_id, _forward_from_chat_part);
		END IF;
		
		IF json_typeof(_forward_from_user_part) != 'null' 
			THEN PERFORM insert_into_forward_from_user(_message_id, _forward_from_user_part);
		END IF;
		
		IF json_typeof(_reply_to_message_part) != 'null' 
			THEN PERFORM insert_into_reply_to_message(_message_id, _reply_to_message_part);
		END IF;
		
		IF json_typeof(_text_part) != 'null' 
			THEN PERFORM insert_into_message_text(_message_id, _text_part);
		END IF;
			
		IF json_typeof(_text_part->'words_count') != 'null' 
			THEN PERFORM insert_into_message_word(_message_id, _text_part);
		END IF;

		IF json_typeof(_text_part->'links') != 'null'
			THEN PERFORM insert_into_message_link(_message_id, _text_part);
		END IF;
		
		IF json_typeof(_photo_part) != 'null' 
			THEN PERFORM insert_into_message_photo(_message_id, _photo_part);
		END IF;
		
		IF json_typeof(_video_part) != 'null' 
			THEN PERFORM insert_into_message_video(_message_id, _video_part);
		END IF;
		
		IF json_typeof(_document_part) != 'null' 
			THEN PERFORM insert_into_message_document(_message_id, _document_part);
		END IF;
		
		IF json_typeof(_animation_part) != 'null' 
			THEN PERFORM insert_into_message_animation(_message_id, _animation_part);
		END IF;
		
		IF json_typeof(_audio_part) != 'null' 
			THEN PERFORM insert_into_message_audio(_message_id, _audio_part);
		END IF;
		
		IF json_typeof(_voice_part) != 'null' 
			THEN PERFORM insert_into_message_voice(_message_id, _voice_part);
		END IF;
		
		IF json_typeof(_sticker_part) != 'null' 
			THEN PERFORM insert_into_message_sticker(_message_id, _sticker_part);
		END IF;
		
		IF json_typeof(_poll_part) != 'null' 
			THEN PERFORM insert_into_message_poll(_message_id, _poll_part);
		END IF;
	END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION set_birthday(
	data JSON
) RETURNS void AS $$
	
	UPDATE users
	SET
		birthday = (data->'text'->>'text')::DATE
	WHERE
		user_id_tg = (data->'reply_to_message'->'user'->>'id')::INTEGER;
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION return_user_timeoff()
RETURNS json AS $$

	SELECT
		json_agg(row_to_json(row))
	FROM (
		SELECT
			full_name
		,	CASE
				WHEN timeoff_minutes <= 60 THEN CONCAT(timeoff_minutes, ' ', 'минут назад')
				ELSE CONCAT(ROUND(timeoff_minutes/60)::TEXT, ' ', 'часов назад')
			END AS timeoff
		FROM (
			SELECT
				full_name
			,	ROUND(EXTRACT(EPOCH FROM NOW() - last_update)/60) AS timeoff_minutes
			FROM
				users
			ORDER BY timeoff_minutes
		) AS t
	) AS row
$$ LANGUAGE SQL;




CREATE OR REPLACE FUNCTION return_birthday_customers()
RETURNS json AS $$

	SELECT
		json_agg(full_name) 
	FROM
		users
	WHERE
		EXTRACT(DAY FROM birthday) = EXTRACT(DAY FROM CURRENT_DATE)
		AND EXTRACT(MONTH FROM birthday) = EXTRACT(MONTH FROM CURRENT_DATE);
		
$$ LANGUAGE SQL;