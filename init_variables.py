from config.env import ENV
from aiogram import Bot
from classes.modules import Modules




bot = Bot(token = ENV.bot_token)

modules = Modules()