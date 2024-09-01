from aiogram.types import Message
from classes.message_parsers import *




class CustomMessage():

    def __init__(self, message: Message) -> None:
        
        self.message_info = ParserMessageInfo(message).data

        type = self.message_info.get("type")

        self.forward_from_chat = ParserForwardFromChat(
            message,
            type
        ).data

        self.forward_from_user = ParserForwardFromUser(
            message,
            type
        ).data

        self.text = ParserText(message).data

        self.links = ParserLinks(self.text).data

        self.words = ParserWords(self.text).data

        content_type = self.message_info.get("content_type")

        self.photo = ParserPhoto(
            message,
            content_type
        ).data

        self.video = ParserVideo(
            message,
            content_type
        ).data

        self.document = ParserDocument(
            message,
            content_type
        ).data

        self.animation = ParserAnimation(
            message,
            content_type
        ).data

        self.audio = ParserAudio(
            message,
            content_type
        ).data

        self.voice = ParserVoice(
            message,
            content_type
        ).data

        self.sticker = ParserSticker(
            message,
            content_type
        ).data

        self.poll = ParserPoll(
            message,
            content_type
        ).data