*** Settings ***

Resource    ../Library/CommonResources.robot

Suite Setup    Initial Setup

*** Variables ***

*** Test Cases ***
To get Access_Token
    [Documentation]  This Keyword is used to give Bearer token authentication
    [Tags]      Smoke
    Bearer Token Authentication

Create Book order
    [Documentation]     This keyword is used for ordering book and shows orderId
    [Tags]      Regression
    Create Book order

list all books
    [Documentation]  This Keyword is used to get details of all the books
    [Tags]      Regression  smoke
    Get all books details

list of only fiction books
    [Documentation]  This Keyword is used to get details of only fiction books
    [Tags]     Regression  smoke
    Get only fiction books

list of only non-fiction books
    [Documentation]  This Keyword is used to get details of only non-fiction books
    [Tags]     Regression  smoke
    Get only non-fiction books

Specific book details
    [Documentation]  This keyword retrieves the detailed information about a book.
    [Tags]  Smoke Regression
    Getting a required book

New Book order
    [Documentation]     This keyword is used to order a new book
    [Tags]      Regression  smoke
    Create Book order

Details of orders
    [Documentation]     This keyword is used to get details of all the ordered books
    [Tags]      Regression
    Get All ordered books details

Details of specific order
    [Documentation]     This keyword is used to get details of a specific order
    [Tags]  Regression
    Get a single or specific order

delete the given BookId
    [Documentation]  This Testcase is used for deleting the ordered book details
    [Tags]     sanity   Regrassion
    Delete an order

*** Keywords ***
Initial Setup
    start session