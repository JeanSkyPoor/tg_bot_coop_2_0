from aiogram.types import Message
from datetime import timedelta
import re


class ParserMessageInfo():

    def __init__(self, message: Message) -> None:

        self.message_id_tg = message.message_id

        self.date = str(message.date.replace(tzinfo = None) + timedelta(hours = 3))

        self.type = self.parse_message_type(message)

        self.content_type = message.content_type.split(".")[0].upper()

        self.user_id_tg = message.from_user.id




    def parse_message_type(self, message: Message):

        if message.forward_from_chat:

            return "forward_from_chat"

        if message.forward_from:

            return "forward_from_user"

        return "regular_message"        




    @property
    def data(self) -> dict:

        fast_dict = {
            "message_id_tg": self.message_id_tg,
            "date": self.date,
            "type": self.type,
            "content_type": self.content_type,
            "user_id_tg": self.user_id_tg
        }

        return fast_dict




class ParserForwardFromChat():

    def __init__(
            self, 
            message: Message, 
            type: str
        ) -> None:
        
        self.attr = {}

        if type == "forward_from_chat":
            
            forward_from_chat = message.forward_from_chat

            self.attr["chat_id"] = forward_from_chat.id

            self.attr["type"] = forward_from_chat.type

            self.attr["title"] = forward_from_chat.title

            self.attr["username"] = forward_from_chat.username

            self.attr["first_name"] = forward_from_chat.first_name

            self.attr["last_name"] = forward_from_chat.last_name




    @property
    def data(self) -> dict| None:

        return self.attr or None




class ParserForwardFromUser():

    def __init__(
            self,
            message: Message,
            type: str
    ) -> None:
        
        self.attr = {}

        if type == "forward_from_user":

            forward_from = message.forward_from

            self.attr["user_id"] = forward_from.id

            self.attr["is_bot"] = forward_from.is_bot

            self.attr["username"] = forward_from.username

            self.attr["first_name"] = forward_from.first_name

            self.attr["last_name"] = forward_from.last_name

            self.attr["full_name"] = forward_from.full_name




    @property
    def data(self) -> dict|None:

        return self.attr or None




class ParserText():

    def __init__(
            self,
            message: Message
    ) -> None:
        
        self.text = message.text or message.caption

        if self.text:

            self.text = re.sub("\s{1,}", " ", self.text)



        
    @property
    def data(self) -> str|None:

        return self.text




class ParserLinks():

    def __init__(
            self,
            text: str|None
    ) -> None:

        self.links = None

        if text:

            self.links = re.findall("http:|https:[^\s]+", text)



    
    @property
    def data(self) -> list|None:

        return self.links or None




class ParserWords():

    def __init__(
            self,
            text: str|None
    ) -> None:
        
        self.attr = {}

        if text:

            text = re.sub("""[\[\]!#$%^*=–(){}+<>'~`,.?"№_\-—:\\\|/:;]""", "", text).lower().strip()

        if text:

            self.attr["words"] = text.split()

            self.attr["word_count"] = len(self.attr["words"])




    @property
    def data(self) -> dict|None:

        return self.attr or None




class ParserPhoto():
    
    def __init__(
            self,
            message: Message,
            content_type: str
    ) -> None:
        
        self.attr = {}

        if content_type == "PHOTO":
            
            photo = message.photo[-1]

            self.attr["file_id"] = photo.file_id

            self.attr["unique_file_id"] = photo.file_unique_id




    @property
    def data(self) -> dict|None:

        return self.attr or None




class ParserVideo():
    
    def __init__(
            self,
            message: Message,
            content_type: str
    ) -> None:
        
        self.attr = {}

        if content_type == "VIDEO":
            
            video = message.video

            self.attr["file_id"] = video.file_id

            self.attr["unique_file_id"] = video.file_unique_id

            self.attr["duration"] = video.duration




    @property
    def data(self) -> dict|None:

        return self.attr or None




class ParserDocument():
    
    def __init__(
            self,
            message: Message,
            content_type: str
    ) -> None:
        
        self.attr = {}

        if content_type == "DOCUMENT":
            
            document = message.document

            self.attr["file_id"] = document.file_id

            self.attr["unique_file_id"] = document.file_unique_id




    @property
    def data(self) -> dict|None:

        return self.attr or None




class ParserAnimation():
    
    def __init__(
            self,
            message: Message,
            content_type: str
    ) -> None:
        
        self.attr = {}

        if content_type == "ANIMATION":
            
            animation = message.animation

            self.attr["file_id"] = animation.file_id

            self.attr["unique_file_id"] = animation.file_unique_id

            self.attr["duration"] = animation.duration




    @property
    def data(self) -> dict|None:

        return self.attr or None




class ParserAudio():
    
    def __init__(
            self,
            message: Message,
            content_type: str
    ) -> None:
        
        self.attr = {}

        if content_type == "AUDIO":
            
            audio = message.audio

            self.attr["file_id"] = audio.file_id

            self.attr["unique_file_id"] = audio.file_unique_id

            self.attr["duration"] = audio.duration

            self.attr["performer"] = audio.performer

            self.attr["title"] = audio.title




    @property
    def data(self) -> dict|None:

        return self.attr or None




class ParserVoice():
    
    def __init__(
            self,
            message: Message,
            content_type: str
    ) -> None:
        
        self.attr = {}

        if content_type == "VOICE":
            
            voice = message.voice

            self.attr["file_id"] = voice.file_id

            self.attr["unique_file_id"] = voice.file_unique_id

            self.attr["duration"] = voice.duration




    @property
    def data(self) -> dict|None:

        return self.attr or None




class ParserSticker():
    
    def __init__(
            self,
            message: Message,
            content_type: str
    ) -> None:
        
        self.attr = {}

        if content_type == "STICKER":
            
            sticker = message.sticker

            self.attr["file_id"] = sticker.file_id

            self.attr["unique_file_id"] = sticker.file_unique_id

            self.attr["type"] = sticker.type

            self.attr["is_animated"] = sticker.is_animated

            self.attr["is_video"] = sticker.is_video

            self.attr["set_name"] = sticker.set_name




    @property
    def data(self) -> dict|None:

        return self.attr or None




class ParserPoll():
    
    def __init__(
            self,
            message: Message,
            content_type: str
    ) -> None:
        
        self.attr = {}

        if content_type == "POLL":
            
            poll = message.poll

            self.attr["poll_id"] = poll.id

            self.attr["question"] = poll.question

            self.attr["options"] = [i.text for i in poll.options]

            self.attr["is_anonymous"] = poll.is_anonymous

            self.attr["allows_multiple_answers"] = poll.allows_multiple_answers




    @property
    def data(self) -> dict|None:

        return self.attr or None




class SetUserParser():

    def __init__(
            self,
            message: Message
    ) -> None:
        
        self.attr = {}


        try:
            self.attr["birthday"] = message.text.split()[1]
        except IndexError:
            self.attr["birthday"] = None
        
        from_user = message.reply_to_message.from_user

        self.attr["user_id_tg"] = from_user.id

        self.attr["username"] = from_user.username

        self.attr["first_name"] = from_user.first_name

        self.attr["last_name"] = from_user.last_name

        self.attr["full_name"] = from_user.full_name




    @property
    def data(self) -> dict:

        return self.attr