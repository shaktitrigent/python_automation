import random
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import urllib3
import gspread
from oauth2client.service_account import ServiceAccountCredentials

urllib3.disable_warnings()


def get_googlesheets_data():
    """
    This keyword is used to get the GoogleSheets data from the  spreadsheets
    :return: It returns the list of dictionaries
    """
    scope = ["https://spreadsheets.google.com/feeds", "https://www.googleapis.com/auth/spreadsheets",
             "https://www.googleapis.com/auth/drive.file", "https://www.googleapis.com/auth/drive"]

    creds = ServiceAccountCredentials.from_json_keyfile_name(
        'C:/Users/mohan_h/Desktop/Python-Automation/api_books/python_automation/creds.json', scope)
    client = gspread.authorize(creds)
    sheet = client.open('TestAutomationData')
    worksheet = sheet.sheet1

    # Returns the  list of dictionaries
    get_values = worksheet.get_all_records()
    return get_values


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

def get_data():
    """
     This function is used to get the specific value of bookId
    which is validated with the Google sheet data
    :return:
    """
    data = get_user_id() - 1
    return data

def update_name():
    """
    This function gives user input name, i.e., updated name for the
    purpose for updating an order
    :return:
    """
    customer_name_updated = input("Enter the customer name: ")
    return customer_name_updated
