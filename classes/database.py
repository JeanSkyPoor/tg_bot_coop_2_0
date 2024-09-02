import json
import psycopg2
from configparser import ConfigParser
from aiogram.types import Message
import psycopg2.pool
from classes.custom_message import CustomMessage
from contextlib import contextmanager


class Database():

    def __init__(self) -> None:
        
        self.read_creds()
        self.connection_pool = psycopg2.pool.SimpleConnectionPool(
            1,
            10,
            **self.creds
        )




    def read_creds(self):

        parser = ConfigParser()

        #Поменять на полный путь на малинке
        parser.read("config/database.ini")

        self.creds = {}

        params = parser.items("postgresql")

        for param in params:
            self.creds[param[0]] = param[1]




    @contextmanager
    def get_cursor(self):

        con = self.connection_pool.getconn()
        con.autocommit = True

        try:
            yield con.cursor()
        finally:
            self.connection_pool.putconn(con)




    def insert_message(
            self,
            message: Message
    ) -> None|Exception:

        with self.get_cursor() as cursor:
            
            data = CustomMessage(message).data

            data = json.dumps(
                data,
                ensure_ascii = False
            )

            try:
                cursor.execute("SELECT insert_message(%s)", (data,))
            except Exception as e:
                return e