*** Settings ***
Resource    ../Library/CommonResources.robot

*** Variables ***

*** Keywords ***

Start Session
    Create Session      url     ${baseurl}

Get all books details
    [Tags]      API

    &{req_body}=     Create Dictionary       type=non-fiction
    &{header}=      Create Dictionary       Content-Type=application/json
    ${response}=  Get On Session    url     books?${req_body}   headers=${header}
    log     ${response.status_code}
    ${status_code}      convert to string   ${response.status_code}


    Should Contain      ${status_code}    20
    Should be equal      ${status_code}   200

    should contain      '${response.content}'   Just as I Am
    should contain      ${response.content}   ${response.content}[5]
    should contain      '${response.content}'   id
    log to console      ${response.json()}[5]
    log to console     ${response.json()}

Bearer Token Authentication
    [Documentation]   This keyword is used to give bearer token Authentictation
    [Tags]      API
    ${var}  get_random_number
    &{req_body}=     Create Dictionary      clientName=lilly      clientEmail=${var}
    &{header}=      Create Dictionary       Content-Type=application/json
    ${response}=    POST on session     url     api-clients     json=${req_body}    headers=${header}
    log to console  ${response.status_code}
    log to console  ${response.json()}
    ${status}   convert to string   ${response.status_code}
    should be equal     ${status}    201
    should contain      '${response.status_code}'   20
    ${token}    get from dictionary     ${response.json()}  accessToken
    log to console      ${token}
    log     ${token}
    set suite variable      ${token}


Ordering books
    [Documentation]    This keyword is used to order books.
    [Tags]      API
    &{req_body}=    Create Dictionary       bookId=3    customerName=lilly
    &{header}=      Create Dictionary       Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     POST on session    url    orders     json=${req_body}      headers=${header}
    log to console      ${response.json()}
    ${orderID}  get from dictionary     ${response.json()}  orderId
    log to console      ${orderID}
    set suite variable  ${orderID}
    ${status_code}     convert to string    ${response.status_code}
    should be equal     ${status_code}      201
    should contain      '${response.json()}'    ${orderID}

To get details of single book
    [Documentation]   This keyword is used to get the details of single book
    [Tags]      API
    ${response}     GET On Session      url  books/3
    log to console  ${response.json()}

To get details of all ordered books
    [Documentation]   This keyword is used to get the details of ordered books
    [Tags]      API
    &{header}=      Create Dictionary       Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     GET On Session      url     orders/     headers=${header}
    log to console  ${response.json()}


To get the details of an order
    [Documentation]   This keyword is used to get the details of ordered books
    [Tags]      API
    &{header}=      Create Dictionary       Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     GET On Session      url     orders/${orderID}   headers=${header}
    log to console  ${response.json()}


To update an order
    [Documentation]   This keyword is used to update an order
    [Tags]      API
    &{req_body}     create dictionary       customerName=kee
    &{header}=      Create Dictionary       Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     PATCH On Session        url     orders/${orderID}     json=${req_body}    headers=${header}
    log to console  ${response}

To delete an order
    [Documentation]   This keyword is used to delete an order
    [Tags]      API
    &{header}=      Create Dictionary       Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     DELETE On Session    url     orders/${orderID}         headers=${header}
    log to console  ${response}

Get all the order after deletion
    [Documentation]   This keyword is used to get the details of ordered books
    [Tags]      API
    &{header}=      Create Dictionary       Content-Type=application/json    Authorization=Bearer ${token}
    ${response}     GET On Session      url     orders/    headers=${header}
    log to console  ${response.json()}
