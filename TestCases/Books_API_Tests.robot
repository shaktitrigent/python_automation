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



*** Keywords ***
Initial Setup
    start session