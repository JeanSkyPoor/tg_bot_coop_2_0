from classes.database import Database
import threading
import asyncio
db = Database()
def run_db():
    with db.get_cursor() as cur:
        print("before execute")
        cur.execute("SELECT custom_sleep()")
        print("db closed")
tread_1 = threading.Thread(target = run_db)

asyncio.run(tread_1.run())
print("after tread 1")

