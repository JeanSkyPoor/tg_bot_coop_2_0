import os
import datetime
from config.env import ENV




def make_backup():

    filename = datetime.datetime.today().strftime("%Y-%m-%d") + '.dump'

    if not os.path.isdir(ENV.backups_path):

        os.mkdir(ENV.backups_path)
    
    for _ in range(3):

        command = f"pg_dump postgresql://{ENV.db_params.get('user')}" + \
        f":{ENV.db_params.get('password')}" + \
        f"@{ENV.db_params.get('host')}" + \
        f":{ENV.db_params.get('port')}" + \
        f"/{ENV.db_params.get('database')} " + \
        f"> {ENV.backups_path}/{filename}"

        os.system(command)

        backup_files = sorted(os.listdir(ENV.backups_path))

        if filename not in backup_files:
            continue
        else:
            if len(backup_files) > 3:

                for _ in range(3):
                    backup_files.pop()

                for file in backup_files:

                    os.remove(f"{ENV.backups_path}/{file}")
            break