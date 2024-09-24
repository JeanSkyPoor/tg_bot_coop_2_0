import asyncio
from aiogram import Dispatcher
from init_variables import bot
from handlers.commands import router as command_router
from handlers.messages import router as message_router

dp = Dispatcher()




async def main():

    dp.include_router(command_router)
    dp.include_router(message_router)

    await dp.start_polling(bot)




if __name__ == "__main__":

    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("Exit")