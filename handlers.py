from aiogram import F, Router
from aiogram.types import Message
from aiogram import Bot
from classes.database import Database
from config.bot_config import TOKEN, CHAT_ID


database = Database()

router = Router()

bot =  Bot(token = TOKEN)




@router.message()
async def insert_message(message: Message):

    if message.chat.id != CHAT_ID:
        return
    
    database.insert_message(message)
