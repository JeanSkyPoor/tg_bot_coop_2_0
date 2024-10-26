from apscheduler.schedulers.asyncio import AsyncIOScheduler
from handlers.commands import return_user_timeoff
from backup import make_backup
from init_variables import modules, bot
from config.env import ENV




scheduler = AsyncIOScheduler()




async def notify_about_birthday_customers():

    birthday_customers = modules.database.return_birthday_customers()

    if birthday_customers:

        if len(birthday_customers) > 1:
            
            end = 'ов'
        else:

            end = 'а' 

        text = f"Сегодня у пиздюк{end} {' и '.join(birthday_customers)} день рождения!"

        await bot.send_message(
            ENV.chat_id,
            text
        )




async def send_message_info_day_before():

    message_info = modules.database.return_message_info_day_before()

    text = "Упс. Вчера никто ничего не писал. Возможно, оно и к лучшему"

    if message_info:

        text = ""

        for user in message_info:
 
            text = text + f"""Юзверь {user.get("full_name")} отправил {user.get("day_messages")} сообщений на {user.get("day_words")} слов\n"""

    await bot.send_message(
        ENV.chat_id,
        text
    )



scheduler.add_job(
    return_user_timeoff, 
    'cron', 
    day_of_week = 'mon-sun', 
    hour = 21, 
    minute = 0
)

scheduler.add_job(
    make_backup,
    "cron",
    day_of_week = 'mon-sun',
    hour = 5,
    minute = 0
)

scheduler.add_job(
    notify_about_birthday_customers,
    "cron",
    day_of_week = 'mon-sun',
    hour = 6,
    minute = 0
)

scheduler.add_job(
    send_message_info_day_before,
    "cron",
    day_of_week = 'mon-sun',
    hour = 17,
    minute = 30
)