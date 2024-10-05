from apscheduler.schedulers.asyncio import AsyncIOScheduler
from handlers.commands import return_user_timeoff
from backup import make_backup

scheduler = AsyncIOScheduler()




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