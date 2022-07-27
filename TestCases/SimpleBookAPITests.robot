*** Settings ***
Resource  ../Library/CommonResources.robot
Suite Setup  Initial Setup



*** Test Cases ***
#List all users details
#    [Tags]  Sanity      Regression      Smoke
#    Get all users details

Creating The Bearer Token
    [Tags]      smoke
    Creating accessToken

Ordering the Books
    [Tags]      Regression
    Order a book

Geting the all order details
    [Tags]      Sanity
    Get all order details



*** Keywords ***
Initial Setup
    Start Session