from classes.database import Database
from aiogram.types import Message
from classes.exception import PassException, AdminException
from config.env import ENV



class Modules():

    def __init__(self) -> None:
        
        self.database = Database()


    def check_chat_id(
            self,
            message: Message
    ) -> None|PassException:
        
        if message.chat.id != ENV.chat_id:

            raise PassException
        
    

    def check_admin_id(
            self,
            message: Message
    ) -> None|AdminException:
        
        if message.from_user.id != ENV.admin_id:

            raise AdminException
