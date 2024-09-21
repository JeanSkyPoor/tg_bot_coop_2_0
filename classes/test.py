from apscheduler.schedulers.asyncio import AsyncIOScheduler
from config.bot_config import CHAT_ID
from handlers import bot


class ScheduleTask():

    def __init__(self) -> None:
        
        self.scheduler = AsyncIOScheduler()

        self.scheduler.add_job(self.test, 'interval', seconds=3)


    async def test(self):

        await bot.send_message(
            CHAT_ID,
            "test run"
        )
