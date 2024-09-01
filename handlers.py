from aiogram import F, Router
from aiogram.types import Message
from aiogram import Bot
from classes.database import Database
from config.bot_config import TOKEN, CHAT_ID


database = Database()

router = Router()

bot =  Bot(token = TOKEN)




@router.message(
        F.content_type.in_(
            {
                "text",
                "photo",
                "video",
                "poll",
                "document",
                "sticker",
                "audio",
                "voice",
                "animation"
            }
        )
)
async def insert_message(message: Message):

    if message.chat.id != CHAT_ID:
        return
    
    result = database.insert_message(message)
    
    if result:
        await message.reply(text = f"Упс. Ошибка: \n {result}")
