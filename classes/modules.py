from classes.database import Database
from classes.check import Check




class Modules():

    def __init__(self) -> None:
        
        self.database = Database()

        self.check = Check