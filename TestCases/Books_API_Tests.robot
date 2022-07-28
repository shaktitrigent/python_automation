*** Settings ***
Resource  ../Library/CommonResources.robot
Suite Setup     Initial Setup


*** Variables ***

*** Test Cases ***
list all books
    Get all books details

To get access token
    Bearer Token Authentication

To order book
    Ordering books

To get single book
    To get details of single book

To get all ordered books
    To get details of all ordered books

To get an order
    To get the details of an order

update an order by PATCH
    To update an order

delete an ordered book
    To delete an order

To check if the order is deleted or not
    Get all the order after deletion

*** Keywords ***
Initial Setup
    start session







