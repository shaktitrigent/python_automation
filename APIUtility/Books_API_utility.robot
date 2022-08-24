*** Settings ***
Resource  ../Library/commonResources.robot

*** Variables ***

*** Keywords ***

start session
    create session      url     ${baseUrl}

Bearer Token Authentication
    [Documentation]  This Keyword is used to give Bearer token authentication
    [Tags]  SMOKE   API
    ${Email}    get_random_emailID
    &{req_body}=   Create Dictionary    clientName=Thomas Shelby   clientEmail=${Email}
    &{header}=    create dictionary    Content-Type=application/json
    ${response}     POST On Session     url     api-clients     json=${req_body}    headers=${header}
    log      ${response.status_code}
    log      ${response.json()}
    ${status}   convert to string   ${response.status_code}
    should be equal     ${status}   201
    ${token}    get from dictionary     ${response.json()}  accessToken
    log     ${token}
    set suite variable      ${token}

Ordering the required book
    [Documentation]    This keyword contain user input name and user input bookId
...                     By using inputs we can order the books, some books are out of stock if
...                     customer order that book it raises an error

    [Tags]       API
    ${BookId}       get_user_id
    ${User_name}    get_user_name
    set suite variable      ${BookId}


     IF     ${BookId}==2
            log to console      Out of stock for this BookId:
     ELSE IF         ${BookId}>6
        log to console      Enter a valid BookId, entered BookId:
     ELSE
          log to console      book is ordered

     END

    # creating the dictionary
     &{req_body}=   Create Dictionary   bookId=${bookId}    clientName=${User_name}
     &{header}=     Create Dictionary   Content-Type=application/json   Authorization=Bearer ${token}
     # Making post request
     ${response}    POST on Session      url     orders      json=${req_body}    headers=${header}
     log      ${response.json()}

     #convert to string to status code
     ${status}      convert to string       ${response.status_code}
     should be equal    ${status}       201
     should contain     '${response.status_code}'   201

     # Validation of Content-Type of headers using get from dictionary metthod
     ${headers_validation}      Get from Dictionary     ${response.headers}     Content-Type
     should be equal    ${headers_validation}      application/json; charset=utf-8
     # Here we created the suite variable for accessing the OrderId
     ${order_ID}       get from Dictionary     ${response.json()}    orderId
     set suite variable     ${order_ID}
     log to console     ${order_ID}

    # getting an order id
    ${orderId}  get from dictionary  ${response.json()}  orderId
    log  ${orderId}
    set suite variable  ${orderId}

Create Book order
    TRY
        Ordering the required book
    EXCEPT
       log to console   ${BookId}

    END

Get all books details
    [Tags]      API
    [Documentation]     This keyword is used to get details of all the books
    &{header}=      Create Dictionary       Content-Type=application/json
    ${response}=  Get On Session    url     books   headers=${header}

    # Getting the google sheets data using python function and validating the response data
    ${googlesheets}     get_googlesheets_data
    set suite variable  ${googlesheets}
    log    ${response.status_code}
    Should Contain      '${response.status_code}'    20    Fail    Test Failed: Expected Response  200,
...                                                 got ${response.status_code} for Get all books details
    Should be equal as strings  ${response.status_code}   200
    should contain  '${response.json()}'    id
    should contain  '${response.json()}'    name
    # validating the Spread sheets response and return  the List of dictionaries
    should not be equal as strings    ${response.json()}[${bookId}]        ${googlesheets}[3]

Get only fiction books
    [Tags]      API
    [Documentation]     This keyword is used to get details of only fiction books
    ${fiction_limit}    get_books_limit
    &{req_body}=     Create Dictionary       type=fiction    limit=${fiction_limit}
    &{header}=      Create Dictionary       Content-Type=application/json
    ${response}=  Get On Session    url     books   params=${req_body}   headers=${header}
    log     ${response.status_code}
    Should Contain      '${response.status_code}'    20    Fail    Test Failed: Expected Response  200,
...                                                  ${response.status_code} for Get all books details
    Should be equal as strings  ${response.status_code}   200
    should contain      '${response.content}'   fiction
    should not contain   '${response.content}'  non-fiction
    log    ${response.json()}

Get only non-fiction books
    [Tags]      API
    [Documentation]     This keyword is used to get details of only non-fiction books
    ${non_fiction_limit}    get_books_limit
    &{req_body}=     Create Dictionary       type=non-fiction    limit=${non_fiction_limit}
    &{header}=      Create Dictionary       Content-Type=application/json
    ${response}=  Get On Session    url     books   params=${req_body}   headers=${header}
    log     ${response.status_code}
    Should Contain      '${response.status_code}'    20    Fail    Test Failed: Expected Response  200,
...                                                  got ${response.status_code} for Get all books details
    Should be equal as strings  ${response.status_code}   200
    should contain   '${response.content}'  non-fiction
    log    ${response.json()}

Required book
    [Documentation]  This keyword is used for  getting a specific book
    ${Book_Id}  get_single_book_id
    &{header}   create dictionary  Content-Type=application/json; charset=utf-8
    ${response}     GET On Session    url    /books/${Book_Id}  headers=${header}
    log   ${response.status_code}
    log   ${response.json()}

    IF  ${Book_Id}>0 and ${Book_Id}<7
        log to console  Book details found
    END

    should be equal as strings   ${response.status_code}   200
    should not be equal as strings    ${response.json()}[bookId]      ${googlesheets}[3]

Getting a required book
        [Documentation]  This keyword logs the particular book details
...        if 'Getting a required book' keyword fails it will give a certain message

        TRY
            Required book
        EXCEPT
            log to console  Enter a valid Book Id
        END

Get All ordered books details
    [Documentation]     This keyword is used to get details of all the ordered books
    [Tags]      API

    &{header}   Create Dictionary   Content-Type=application/json   Authorization=Bearer ${token}
    ${response}    GET on session    url    orders      headers=${header}
    log   ${response.json()}
    log   ${response.status_code}

    should be equal as strings   ${response.status_code}    200
    should contain     '${response.status_code}'      20     Test Failed: Expected Response 200,
...                                                  got ${response.status_code} for get All ordered books details

Get a single or specific order
    [Documentation]  This keyword is used to get details of specific order
    [Tags]      API
    @{values}   get_googlesheets_data
    log  ${values}
    ${list_index}   get_data
    &{header}   Create Dictionary   Content-Type=application/json   Authorization=Bearer ${token}
    ${response}     Get on session      url     orders/${order_ID}    headers=${header}
    log   ${response.json()}
    log   ${response.status_code}
    should be equal as integers      ${response.status_code}     200
    should contain      '${response.status_code}'   20    Test Failed: Expected Response 200,
    ...                                            got ${response.status_code} for get a single or specific order

    ${list_values}  get from list   ${values}   ${list_index}
    should be equal as strings   ${response.json()}[bookId]     ${list_values}[id]

Update an order
    [Documentation]  This keyword modifies the ordered data
    ${customer_name}  update_name
    &{req_body}    create dictionary    customerName=${customer_name}
    &{header}   create dictionary   Content-Type=application/json   Authorization=Bearer ${token}
    ${response}     PATCH On Session   url   /orders/${orderId}     json=${req_body}    headers=${header}
    log   ${response}

    # validations
    should be equal as strings   ${response.status_code}   204

Check whether the order is updated or not
    [Documentation]  This keyword verifies order is updated or not
    &{header}   create dictionary   Content-Type=application/json   Authorization=Bearer ${token}
    ${response}   GET On Session  url   /orders/${orderId}        headers=${header}
    log  ${response.json()}
    log  ${response.status_code}

#    validations
    should be equal as integers  ${response.status_code}    200
    should not be equal as strings    ${response.json()}[bookId]        ${googlesheets}[3]

Delete an order
    [Documentation]  this keyword used to deleting the user ordered book
    [Tags]   API

    # Making DELETE request
    &{header}=     Create Dictionary   Content-Type=application/json   Authorization=Bearer ${token}
    ${response}    DELETE on session     url     orders/${order_ID}       headers=${header}

     # Validation of Content-Type of headers using get from dictionary metthod
    ${headers_validation}      Get from Dictionary     ${response.headers}     Connection
    should be equal    ${headers_validation}      keep-alive
    log     ${response.headers}

    # Validating the status code
    should be equal as strings   ${response.status_code}   204

checking the order deleted or not

    [Documentation]     In this keyword is returns and validate  the ordered book is delete or not
...                    And also, It returns the empty body
    [Tags]      API

    # Making the GET request and checking the deleted order
    &{header}=     Create Dictionary   Content-Type=application/json   Authorization=Bearer ${token}
    ${response}     GET on session      url     orders      headers=${header}
    # It retruns the empty content because after delete an order it gives empty body
    log to console      ${response.json()}
    ${headers_validation}      Get from Dictionary     ${response.headers}     Connection
    should be equal    ${headers_validation}      keep-alive

    # Validating the status_code
    should be equal as strings   ${response.status_code}   200