*** Settings ***
Resource  ../Library/commonResources.robot

*** Variables ***

*** Keywords ***

start session
    create session      url     ${baseUrl}

get all books details
    [Tags]      SMOKE
    &{header}=    create dictionary    Content-Type=application/json
    ${response}     GET On Session     url     books       headers=${header}
    log     ${response.status_code}
    log to console      ${response.content}
    should contain   '${response.status_code}'     200
    should contain   '${response.json()}'       id
    should contain     ${response.content}      ${response.content}[5]
    should contain    '${response.json()}[5]'       id

get single book details
    [Tags]      SMOKE
    &{header}=    create dictionary    Content-Type=application/json
    ${response}     GET On Session     url     books/3       headers=${header}
    log to console      ${response.json()}

Bearer Token Authentication
    [Tags]  SMOKE   API
    ${Email}    get_random_mail
    &{req_body}=   Create Dictionary    clientName=Thomas Shelby   clientEmail=${Email}
    &{header}=    create dictionary    Content-Type=application/json
    ${response}     POST On Session     url     api-clients     json=${req_body}    headers=${header}
    log      ${response.status_code}
    log to console      ${response.json()}
    ${status}   convert to string   ${response.status_code}
    should be equal     ${status}   201
    ${token}    get from dictionary     ${response.json()}  accessToken
    log to console      ${token}
    set suite variable      ${token}

Ordering a book
    [Documentation]  This keyword generates an order for a book
    [Tags]  API
    &{req_body}=   Create Dictionary    bookId=5   customerName=Rutherford
    &{header}=    create dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     POST On Session     url     orders     json=${req_body}    headers=${header}
    log to console      ${response.json()}
    log to console      ${response.status_code}
    ${Order_id}     get from dictionary     ${response.json()}      orderId
    log to console      ${Order_id}
    set suite variable      ${Order_id}

Get all the orders
    [Tags]  API     Regression
    &{header}=    create dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     GET On Session     url     orders      headers=${header}
    log to console      ${response.json()}

Get order by ID
    [Tags]  API     Regression
    &{header}=    create dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     GET On Session     url     orders/${Order_id}     headers=${header}
    log to console      ${response.json()}
    ${data}     get from dictionary     ${response.json()}      id
    should be equal     ${Order_id}     ${data}

Update an order
    [Tags]  API     Regression
    &{req_body}=   Create Dictionary    customerName=Walter White
    &{header}=    create dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     PATCH On Session     url     orders/${Order_id}    json=${req_body}    headers=${header}
    log to console      ${response}

Delete an order
    [Tags]  API     Regression      Sanity
    &{header}=    create dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     DELETE On Session     url     orders/${Order_id}    headers=${header}
    log to console      ${response}

Get all the orders after deletion
    [Tags]  API     Sanity
    &{header}=    create dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     GET On Session     url     orders      headers=${header}
    log to console      ${response.json()}