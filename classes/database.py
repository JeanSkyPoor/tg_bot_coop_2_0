import json
import psycopg2
from configparser import ConfigParser
from aiogram.types import Message
from classes.custom_message import CustomMessage


class Database():

    def __init__(self) -> None:
        
        self.read_creds()
        self.connect = psycopg2.connect(**self.creds)
        self.connect.autocommit = True




    def read_creds(self):

        parser = ConfigParser()

        parser.read("config/database.ini")

        self.creds = {}

        params = parser.items("postgresql")

        for param in params:
            self.creds[param[0]] = param[1]




    def insert_message(
            self,
            message: Message
    ) -> None:

        with self.connect.cursor() as cur:
            
            message = CustomMessage(message)

            message = json.dumps(
                message.__dict__,
                ensure_ascii = False
            )
            
            cur.execute("SELECT insert_message(%s)", (message,))