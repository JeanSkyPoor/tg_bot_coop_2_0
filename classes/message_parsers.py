from aiogram.types import Message
from classes.custom_classes import *
import json




class MessageParser():

    def __init__(
            self,
            message: Message
    ) -> None:
        
        self.message = CustomMessage(message).data

        self.user = CustomUser(message.from_user).data

        self.forward_from_chat = CustomChat(message.forward_from_chat).data

        self.forward_from_user = CustomUser(message.forward_from).data

        self.reply_to_message = None
        if message.reply_to_message:

            self.reply_to_message = CustomReplyToMessage(message.reply_to_message).data

        self.text = CustomText(message).data

        self.photo = CustomPhoto(message.photo).data

        self.video = CustomVideo(message.video).data

        self.document = CustomDocument(message.document).data

        self.animation = CustomAnimation(message.animation).data

        self.audio = CustomAudio(message.audio).data

        self.voice = CustomVoice(message.voice).data

        self.sticker = CustomSticker(message.sticker).data

        self.poll = CustomPoll(message.poll).data




    @property
    def json_to_function_insert_message(self) -> str:

        keys = [
            "message",
            "user",
            "forward_from_chat",
            "forward_from_user",
            "reply_to_message",
            "text",
            "photo",
            "video",
            "document",
            "animation",
            "audio",
            "voice",
            "sticker",
            "poll"
        ]

        attr_dict = {
            key: value for key, value in self.__dict__.items() if key in keys
        }

        return json.dumps(attr_dict, ensure_ascii = False)
    


    @property
    def json_to_set_birthday(self):

        keys = [
            "reply_to_message",
            "text"
        ]

        attr_dict = {
            key: value for key, value in self.__dict__.items() if key in keys
        }

        attr_dict["text"]["text"] = attr_dict["text"]["text"].split()[1]

        return json.dumps(attr_dict, ensure_ascii = False)