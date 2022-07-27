*** Settings ***

#Resource    ../Library/Commonresourse.robot
Resource  ../Api_Utility/Books_Api_Helper.robot

Suite Setup  Initial setup


*** Test Cases ***
Gettinging auth
    Api Authentication

List all book details
    details of all the books

Required book
    getting a required book

order data
    sumbit an order


List of all orders
    Get all orders

changing the order details

    Update an order

Removing an existing order
    Delete an order

#Deleted order
#    get deleted order details


*** Keywords ***
Initial setup
    start session


