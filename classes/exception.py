class PassException(Exception):
    """
    Метка того, что ничего не делаем
    """
    pass


class AdminException(Exception):
    """
    Метка того, что юзер не админ
    """
    pass