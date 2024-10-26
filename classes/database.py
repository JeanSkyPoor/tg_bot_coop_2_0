import psycopg2
import psycopg2.pool
from contextlib import contextmanager
from config.env import ENV




class Database():

    def __init__(self) -> None:
        
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
    ) -> None:

        with self.get_cursor() as cursor:
            
            cursor.execute("SELECT insert_message(%s)", (data,))





    def set_birthday(
            self,
            data: str
    ) -> None:
        
        with self.get_cursor() as cursor:
            
            cursor.execute("SELECT set_birthday(%s)", (data,))




    def return_user_timeoff(self) -> list:

        with self.get_cursor() as cursor:
            
            cursor.execute("SELECT return_user_timeoff()")

            return cursor.fetchone()[0]
    



    def return_birthday_customers(self) -> list | None:

        with self.get_cursor() as cursor:
            
            cursor.execute("SELECT return_birthday_customers()")

            return cursor.fetchone()[0]




    def return_message_info_day_before(self) -> list | None:

        with self.get_cursor() as cursor:

            cursor.execute("SELECT return_message_info_day_before()")

            return cursor.fetchone()[0]