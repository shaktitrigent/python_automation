import random


def get_random_number():
    """
    It generates random number in a given range.
    :return: Random number
    """
    number = random.randint(0, 11111)
    return number

def get_random_emailID():
    """
    It generates random emailID
    :return: Random emailID
    """
    email_id = get_random_number()
    return "Postman" + str(email_id) + "@gmail.com"
