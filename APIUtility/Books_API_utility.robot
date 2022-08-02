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
     ${response}    POST on session     url     orders      json=${req_body}    headers=${header}
     log      ${response.json()}

     #convert to string to status code
     ${status}      convert to string       ${response.status_code}
     should be equal    ${status}       201
     should contain     '${response.status_code}'   201

     # Validation of Content-Type of headers using get from dictionary metthod
     ${headers_validation}      Get from Dictionary     ${response.headers}     Content-Type
     should be equal    ${headers_validation}      application/json; charset=utf-8


Create Book order
    TRY
        Ordering the required book
    EXCEPT
       log to console   ${BookId}

    END

