from aiogram.types import Message
from classes.exception import PassException, AdminException
from config.env import ENV




class Check:
    
    @staticmethod
    def check_chat_id(
            message: Message
    ) -> None|PassException:
        
        if message.chat.id != ENV.chat_id:

            raise PassException




    @staticmethod
    def check_admin_id(
            message: Message
    ) -> None|AdminException:
        
        if message.from_user.id != ENV.admin_id:

            raise AdminException