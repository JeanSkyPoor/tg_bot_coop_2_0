import psycopg2
import psycopg2.pool
from contextlib import contextmanager
import logging
from config.env import ENV




class Database():

    def __init__(self) -> None:
        
        # self.read_creds()
        self.connection_pool = psycopg2.pool.SimpleConnectionPool(
            1,
            10,
            **ENV.db_params
        )




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
            data: str
    ) -> None|str:

        with self.get_cursor() as cursor:
            
            try:
                cursor.execute("SELECT insert_message(%s)", (data,))
            except Exception as error:

                logging.exception(error)

                return 'error'




    def set_birthday(
            self,
            data: str
    ) -> None|str:
        
        with self.get_cursor() as cursor:
            
            try:
                cursor.execute("SELECT set_birthday(%s)", (data,))
            except Exception as error:

                logging.exception(error)

                return 'error'




    def return_user_timeoff(self) -> str:

        with self.get_cursor() as cursor:
            
            try:
                cursor.execute("SELECT return_user_timeoff()")

                return cursor.fetchone()[0]
            
            except Exception as error:

                logging.exception(error)

                return 'error'

