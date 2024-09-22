from aiogram import F, Router
from aiogram.types import Message
from aiogram import Bot
from classes.modules import Modules
from config.env import ENV
from aiogram.filters import Command
from classes.message_parsers import MessageParser
from classes.exception import PassException, AdminException
import logging


router = Router()

bot = Bot(token = ENV.bot_token)

modules = Modules()





@router.message(
          Command("timeoff")
)
async def return_user_timeoff(message: Message):

    try:
        modules.check_chat_id(message)
     
        raw_data = modules.database.return_user_timeoff()

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

    except PassException:
        return
    
    except Exception as e:

        logging.exception(
            e
        )

        bot.send_message(
            ENV.chat_id,
            f"{ENV.admin_username}, что-то пошло не так, чекай логи"
        )




@router.message(
        Command("birthday")
)
async def set_birthday(message: Message):

    try:
        modules.check_chat_id(message)
        
        modules.check_admin_id(message)
        
        data = MessageParser(message).json_to_set_birthday

        modules.database.set_birthday(data)

        await bot.send_message(
            ENV.chat_id,
            "Успех!"
        )

    except PassException:
        return

    except AdminException:

        await bot.send_message(
            ENV.chat_id,
            "Не для тебя моя роза цвела!!"
        )
    
    except Exception as e:
        logging.exception(
            e
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

    try:
        modules.check_chat_id(message)

        data = MessageParser(message).json_to_function_insert_message

        modules.database.insert_message(data)
    
    except PassException:
        return

    except Exception as e:

        logging.exception(
            e
        )

        message.reply(
            f"{ENV.admin_username}, не удалось вставить сообщение. чекай логи"
        )
