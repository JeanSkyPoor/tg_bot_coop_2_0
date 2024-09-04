from aiogram import F, Router
from aiogram.types import Message
from aiogram import Bot
from classes.database import Database
from config.bot_config import TOKEN, CHAT_ID, ADMIN_ID
from aiogram.filters import Command
import json
from classes.custom_message import CustomMessage
from classes.message_parsers import SetUserParser

database = Database()

router = Router()

bot =  Bot(token = TOKEN)



@router.message(
        Command(commands="set_user")
)
async def set_user(message: Message):

    if message.chat.id != CHAT_ID:
        return
    
    if message.from_user.id != ADMIN_ID:

        await bot.send_message(
            chat_id = CHAT_ID,
            text = "Не для тебя моя роза цвела!"
        )

        return
    
    data = SetUserParser(message).data

    data = json.dumps(
        data,
        ensure_ascii = False
    )

    result = database.set_user(data)

    if result:
        
        message_id = message.message_id

        await bot.send_message(
            chat_id = CHAT_ID,
            reply_to_message_id = message_id,
            text = "Не удалось обновить юзверя. Чекай логи"
        )




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
    
    data = CustomMessage(message).data

    data = json.dumps(
        data,
        ensure_ascii = False
    )

    result = database.insert_message(data)

    if result:

        message_id = message.message_id

        await bot.send_message(
            chat_id = CHAT_ID,
            reply_to_message_id = message_id,
            text = "@Jean_Sky_Poor, Не удалось сохранить это сообщение. Чекай логи"
        )