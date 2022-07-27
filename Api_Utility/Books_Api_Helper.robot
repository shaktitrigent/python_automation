*** Settings ***
Resource  ../Library/Commonresourse.robot

*** Variables ***

*** Keywords ***
Start Session
    Create Session      url     ${base_url}

Api Authentication
    [Documentation]  This Auth is required for the submit or view an order and mandatory to register API client.
    start session
    ${var}  get_r_n
    &{req_body}     create dictionary   clientName=randomName   clientEmail=${var}
    &{header}   create dictionary   Content-Type=application/json
    ${response}     POST On Session   url   /api-clients    json=${req_body}   headers=${header}
    log to console  ${response.json()}
    ${token}    get from dictionary  ${response.json()}   accessToken

    log to console  ${token}

    set suite variable  ${token}



details of all the books
    [Documentation]  This gives the details about the available books on application
    &{header}   create dictionary  Content-Type=application/json; charset=utf-8
    ${response}     GET On Session    url    /books     headers=${header}
    log to console  ${response.status_code}
    should be equal  '${response.status_code}'    '200'
    should contain  '${response.json()}'    The Russian


getting a required book
    [Documentation]  This keyword logs the perticular book details
    &{req}  create dictionary   bookId=1
    &{header}   create dictionary  Content-Type=application/json; charset=utf-8     Authorization=Bearer ${token}
    ${response}     GET On Session    url    /books?${req}   headers=${header}
    log to console  ${response.status_code}
    should be equal   '${response.status_code}'   '200'

    should contain    '${response.json()}'   The Russian

    should contain  '${response.json()}'     fiction


Sumbit an order
    [Documentation]  This keyword creates an order
    &{req}  create dictionary  bookId=1  customerName=mohan
    &{header}   create dictionary  Content-Type=application/json       Authorization=Bearer ${token}
    ${response}     POST On Session  url  /orders   json=${req}   headers=${header}
    log to console  ${response.status_code}
    log to console  ${response.json()}
    ${orderId}  get from dictionary  ${response.json()}     orderId
    set suite variable  ${orderId}



Sumbit an order 2
    [Documentation]  This keyword creates an another order
    &{req}  create dictionary  bookId=2  customerName=
    &{header}   create dictionary  Content-Type=application/json       Authorization=Bearer ${token}
    ${response}     POST On Session  url  /orders   json=${req}   headers=${header}
    log to console  ${response.status_code}
    log to console  ${response.json()}
    ${orderId}  get from dictionary  ${response.json()}     orderId
    set suite variable  ${orderId}


Get all orders
    [Documentation]  This keyword logs the order details
    &{header}   create dictionary  Content-Type=application/json       Authorization=Bearer ${token}
    ${response}     GET On Session  url  /orders       headers=${header}
    log to console  ${response.status_code}


Get an order
    [Documentation]  This keyword gives the particular order information
    &{req}  create dictionary  orderId=${orderId}
    &{header}   create dictionary  Content-Type=application/json       Authorization=Bearer ${token}
    ${response}     GET On Session  url  /orders?${req}     headers=${header}
    log to console  ${response.status_code}



Update an order
    [Documentation]  This keyword modify the existing data
    &{req}  create dictionary  customerName=chinni
    &{header}   create dictionary   Content-Type=application/json   Authorization=Bearer ${token}
    ${response}     PATCH On Session   url   /orders/${orderId}     json=${req}    headers=${header}
    log to console  ${response}
#    should contain  ${response.json()}  chinni


Delete an order
    [Documentation]  This keyword removes the created order
#    &{req}      create dictionary  orderId=${orderId}
    &{header}   create dictionary   Content-Type=application/json   Authorization=Bearer ${token}
    ${response}     DELETE On Session   url  /orders/${orderId}   headers=${header}
    log to console  ${response}


#get deleted order details
#    &{header}   create dictionary   Content-Type=application/json   Authorization=Bearer ${token}
#    ${response}     GET On Session   url  /orders/${orderId}   headers=${header}
#    log to console  ${response.json()}

