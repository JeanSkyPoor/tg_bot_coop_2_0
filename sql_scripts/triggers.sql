CREATE OR REPLACE FUNCTION new_last_update_value()
RETURNS TRIGGER AS $$
	BEGIN
		new.last_update := NOW();
		RETURN new;
	END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE TRIGGER bui_last_update
BEFORE INSERT OR UPDATE ON chats
FOR EACH ROW
EXECUTE PROCEDURE new_last_update_value();




CREATE OR REPLACE TRIGGER bui_last_update
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE PROCEDURE new_last_update_value();