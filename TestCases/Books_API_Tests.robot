*** Settings ***
Resource    ../Library/CommonResources.robot
Suite Setup    Initial Setup

*** Variables ***

*** Test Cases ***
List all Books
    get all books details

To get details of a single book
    get single book details

To get Access_Token
    Bearer Token Authentication

Single Book Order
    Ordering a book

Get the ordered details
    Get all the orders

Get single ordered book
    Get order by ID

To Update an order by PATCH
    Update an order

Deleting an ordered book
    Delete an order

To check whether order is deleted or not
    Get all the orders after deletion


*** Keywords ***
Initial Setup
    start session