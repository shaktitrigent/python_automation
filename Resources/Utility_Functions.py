import random
import urllib3
urllib3.disable_warnings()


def get_random_number(start, end):
    """
    It generates a random number in a given range
    :param start: integer: start value
    :param end: integer: end value
    :return: random number
    """
    number = random.randint(start, end)
    return number


def get_random_email_id():
    """
    It generates random email_id
    :return: Random email_id
    """
    email_id = get_random_number(0, 122222)
    return "Postman" + str(email_id) + "@gmail.com"


def get_user_id():
    """
    It generates random bookID
    :return: random bookID
    """
    book_number = int(input("enter the bookId: "))
    return book_number


def get_user_name():
    """
    Create userName using the input methods
    :return: username
    """
    user_name = input("enter the user name: ")
    return user_name


def get_books_limit():
    """
    It generates limitation number for a book as per the user input
    :return: limitation number
    """
    number = int(input("enter the limitation: "))
    return number


def get_single_book_id():
    """
    This function gives the specific book id
    :return: specific book id
    """
    specific_book_id = int(input("Enter a book Id: "))
    return specific_book_id
