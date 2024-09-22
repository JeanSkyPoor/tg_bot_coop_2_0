from aiogram import F, Router
from aiogram.types import Message
from aiogram import Bot
from classes.modules import Modules
from config.env import ENV
from aiogram.filters import Command
from classes.message_parsers import MessageParser


router = Router()

bot = Bot(token = ENV.bot_token)

modules = Modules()





@router.message(
          Command("timeoff")
)
async def return_user_timeoff():
     
    raw_data = modules.database.return_user_timeoff()

    if raw_data == 'error':

        await bot.send_message(
            ENV.chat_id,
            "@Jean_Sky_Poor, не получилось посмотреть адыхающих"
        )


    fast_dict = {}

    for user in raw_data:
        fast_dict[user.get("full_name")] = user.get("timeoff")

    text = "Итак, адыхающие: \n\n"

    for key, value in fast_dict.items():
        
        text = text + f"{key}: {value}\n\n"

    await bot.send_message(
        ENV.chat_id,
        text = text
    )




@router.message(
        Command("birthday")
)
async def set_birthday(message: Message):

    if message.chat.id != ENV.chat_id:
            return
    
    if message.from_user.id != ENV.admin_id:
         
        await bot.send_message(
            ENV.chat_id,
            "Не для тебя моя роза цвела!!!!"
        )
    
    data = MessageParser(message).json_to_set_birthday

    result = modules.database.set_birthday(data)

    if result == "error":

        await bot.send_message(
            ENV.chat_id,
            "Не удалось обновить др!"
        )

    else:
        
        await bot.send_message(
            ENV.chat_id,
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

    if message.chat.id != ENV.chat_id:
        return
    
    if message.content_type.split()[0] == "voice":
        
        await message.reply(
            "Фу, пидор"
        )

    data = MessageParser(message).json_to_function_insert_message

    result = modules.database.insert_message(data)

    if result == "error":

        await message.reply(
            "@Jean_Sky_Poor не удалось вставить это сообщение"
        )