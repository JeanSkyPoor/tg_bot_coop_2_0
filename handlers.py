from aiogram import F, Router
from aiogram.types import Message
from aiogram import Bot
from classes.modules import Modules
from config.bot_config import TOKEN, CHAT_ID, ADMIN_ID
from aiogram.filters import Command
from classes.message_parsers import MessageParser


router = Router()

bot =  Bot(token = TOKEN)




modules = Modules()




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

    data = MessageParser(message).json_to_function_insert_message

    result = modules.database.insert_message(data)

    if result == "error":

        await message.reply(
            "@Jean_Sky_Poor не удалось вставить это сообщение"
        )