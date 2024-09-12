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
          Command("timeoff")
)
async def return_user_timeoff(message: Message):
     
    raw_data = modules.database.return_user_timeoff()

    fast_dict = {}

    for user in raw_data:
        fast_dict[user.get("user_name")] = user.get("timeoff")

    text = "Итак, адыхающие: \n"

    for key, value in fast_dict.items():
        
        text = text + f"{key}: {value} часа назад\n"

    await bot.send_message(
        CHAT_ID,
        text = text
    )



@router.message(
        Command("birthday")
)
async def set_birthday(message: Message):

    if message.chat.id != CHAT_ID:
            return
    
    if message.from_user.id != ADMIN_ID:
         
        await bot.send_message(
            CHAT_ID,
            "Не для тебя моя роза цвела!!!!"
        )
    
    data = MessageParser(message).json_to_set_birthday

    result = modules.database.set_birthday(data)

    if result == "error":

        await bot.send_message(
            CHAT_ID,
            "Не удалось обновить др!"
        )

    else:
        
        await bot.send_message(
            CHAT_ID,
            "Успех!"
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

    data = MessageParser(message).json_to_function_insert_message

    result = modules.database.insert_message(data)

    if result == "error":

        await message.reply(
            "@Jean_Sky_Poor не удалось вставить это сообщение"
        )