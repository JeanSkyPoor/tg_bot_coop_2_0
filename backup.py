import os
import datetime
from config.env import ENV




def make_backup():

    filename = datetime.datetime.today().strftime("%Y-%m-%d") + '.dump'

    if not os.path.isdir(ENV.backups_path):

        os.mkdir(ENV.backups_path)
    
    files = os.listdir(ENV.backups_path)

    if any(files):

        for file in files:
            os.remove(f"{ENV.backups_path}/{file}")


    command = f"""pg_dump postgresql://{ENV.db_params.get('user')}\
:{ENV.db_params.get('password')}\
@{ENV.db_params.get('host')}\
:{ENV.db_params.get('port')}\
/{ENV.db_params.get('database')} \
> {ENV.backups_path}/{filename}"""

    os.system(command)