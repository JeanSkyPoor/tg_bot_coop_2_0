from aiogram import Router, F
from aiogram.types import Message
from init_variables import modules
from config.env import ENV
from classes.exception import PassException
import logging
from classes.message_parsers import MessageParser




router = Router(
    name = "Messages"
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
        modules.check.check_chat_id(message)

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