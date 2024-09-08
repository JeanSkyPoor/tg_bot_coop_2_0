from aiogram.types import Video, PhotoSize, Poll, Document, Audio, Animation, Sticker, Voice, User, Message, Chat
from datetime import timedelta
import re




class Base():

    @property
    def data(self):

        return self.__dict__ or None




class CustomVideo(Base):

    "https://docs.aiogram.dev/en/dev-3.x/api/types/video.html#aiogram.types.video.Video"

    def __init__(
            self,
            video: Video
    ) -> None:
        
        if video:

            self.file_id: str = video.file_id

            self.file_unique_id: str = video.file_unique_id

            self.duration: int = video.duration

            self.file_name: str|None = video.file_name

            self.mime_type: str|None = video.mime_type




class CustomPhoto(Base):

    "https://docs.aiogram.dev/en/dev-3.x/api/types/photo_size.html#aiogram.types.photo_size.PhotoSize"

    def __init__(
            self,
            photo: PhotoSize
    ) -> None:

        if photo:

            photo = photo[-1]

            self.file_id: str = photo.file_id

            self.file_unique_id: str = photo.file_unique_id




class CustomPoll(Base):

    "https://docs.aiogram.dev/en/dev-3.x/api/types/poll.html#aiogram.types.poll.Poll"

    def __init__(
            self,
            poll: Poll
    ) -> None:
        
        if poll:

            self.id: str = poll.id

            self.question: str = poll.question

            self.options: list[str] = [option.text for option in poll.options]

            self.is_anonymous: bool = poll.is_anonymous

            self.type: str = poll.type

            self.allows_multiple_answers: bool = poll.allows_multiple_answers




class CustomDocument(Base):
    
    "https://docs.aiogram.dev/en/dev-3.x/api/types/document.html#aiogram.types.document.Document"

    def __init__(
            self,
            document: Document
    ) -> None:
        
        if document:

            self.file_id: str = document.file_id

            self.file_unique_id: str = document.file_unique_id

            self.file_name: str|None = document.file_name

            self.mime_type: str|None = document.mime_type




class CustomAudio(Base):

    "https://docs.aiogram.dev/en/dev-3.x/api/types/audio.html#aiogram.types.audio.Audio"

    def __init__(
            self,
            audio: Audio
    ) -> None:
        
        if audio:

            self.file_id: str = audio.file_id

            self.file_unique_id: str = audio.file_unique_id

            self.duration: int = audio.duration

            self.performer: str|None = audio.performer

            self.title: str|None = audio.title

            self.file_name: str|None = audio.file_name

            self.mime_type: str|None = audio.mime_type




class CustomAnimation(Base):

    "https://docs.aiogram.dev/en/dev-3.x/api/types/animation.html#aiogram.types.animation.Animation"

    def __init__(
            self,
            animation: Animation
    ) -> None:
        
        if animation:

            self.file_id: str = animation.file_id

            self.file_unique_id: str = animation.file_unique_id

            self.duration: int = animation.duration

            self.file_name: str|None = animation.file_name

            self.mime_type: str|None = animation.mime_type




class CustomSticker(Base):

    "https://docs.aiogram.dev/en/dev-3.x/api/types/sticker.html#aiogram.types.sticker.Sticker"

    def __init__(
            self,
            sticker: Sticker
    ) -> None:
        
        if sticker:

            self.file_id: str = sticker.file_id

            self.file_unique_id: str = sticker.file_unique_id

            self.type: str = sticker.type

            self.is_animated: bool = sticker.is_animated

            self.is_video: bool = sticker.is_video

            self.emoji: str|None = sticker.emoji

            self.set_name: str|None = sticker.set_name




class CustomVoice(Base):

    "https://docs.aiogram.dev/en/dev-3.x/api/types/voice.html#aiogram.types.voice.Voice"

    def __init__(
            self,
            voice: Voice
    ) -> None:
        
        if voice:

            self.file_id: str = voice.file_id

            self.file_unique_id: str = voice.file_unique_id

            self.duration: int = voice.duration




class CustomUser(Base):

    "https://docs.aiogram.dev/en/dev-3.x/api/types/user.html#aiogram.types.user.User"

    def __init__(
            self,
            user: User
    ) -> None:
        
        if user:

            self.id: int = user.id

            self.is_bot: bool = user.is_bot

            self.first_name: str = user.first_name

            self.last_name: str|None = user.last_name

            self.username: str|None = user.username

            self.full_name: str = user.full_name




class CustomChat(Base):

    "https://docs.aiogram.dev/en/dev-3.x/api/types/chat.html#aiogram.types.chat.Chat"
    
    def __init__(
            self,
            chat: Chat
    ) -> None:
        
        if chat:

            self.id: int = chat.id

            self.type: str = chat.type

            self.title: str|None = chat.title

            self.username: str|None = chat.username

            self.first_name: str|None = chat.first_name

            self.last_name: str|None = chat.last_name

            self.full_name: str = chat.full_name




class CustomMessage(Base):

    def __init__(
            self,
            message: Message
    ) -> None:
        
        if message:

            self.id: int = message.message_id

            self.date: str = str(message.date.replace(tzinfo = None) + timedelta(hours = 3))

            self.type: str = self.parse_message_type(message)

            self.content_type: str = message.content_type.split(".")[0]




    def parse_message_type(
            self,
            message: Message
    ) -> str:

        if message.forward_from_chat:

            return "forward_from_chat"

        if message.forward_from:

            return "forward_from_user"
        
        if message.reply_to_message:
            
            return "reply_to_message"

        return "regular_message"




class CustomText(Base):

    def __init__(
            self,
            message: Message
    ) -> None:
        
        text = message.text or message.caption

        if text:

            self.text: str = re.sub("\s{1,}", " ", text)
            
            self.links: list|None = re.findall("http:|https:[^\s]+", self.text) or None

            text_without_links = self.text

            if self.links:

                for link in self.links:

                    text_without_links = text_without_links.replace(link, "").strip()

            replaced_text: str = re.sub("""[\[\]!#$%^*=–(){}+<>'~`,.?"№_\-—:\\\|/:;\d]""", "", text_without_links).lower().strip()

            self.words = None

            self.words_count = None

            if replaced_text:

                self.words = replaced_text.split()

                self.words_count: int = len(self.words)