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

Get all books details
    [Tags]      API
    [Documentation]     This keyword is used to get details of all the books
    &{header}=      Create Dictionary       Content-Type=application/json
    ${response}=  Get On Session    url     books   headers=${header}
    log     ${response.status_code}
    log  ${response.json()}
    Should Contain      '${response.status_code}'    20    Fail    Test Failed: Expected Response  200,got ${response.status_code} for Get all books details
    Should be equal as strings  ${response.status_code}   200
    should contain  '${response.json()}'    id
    should contain  '${response.json()}'    name

Get only fiction books
    [Tags]      API
    [Documentation]     This keyword is used to get details of only fiction books
    ${fiction_limit}    get_books_limit
    &{req_body}=     Create Dictionary       type=fiction    limit=${fiction_limit}
    &{header}=      Create Dictionary       Content-Type=application/json
    ${response}=  Get On Session    url     books   params=${req_body}   headers=${header}
    log     ${response.status_code}
    Should Contain      '${response.status_code}'    20    Fail    Test Failed: Expected Response  200,got ${response.status_code} for Get all books details
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
    Should Contain      '${response.status_code}'    20    Fail    Test Failed: Expected Response  200,got ${response.status_code} for Get all books details
    Should be equal as strings  ${response.status_code}   200
    should contain   '${response.content}'  non-fiction
    log    ${response.json()}

Required book
    [Documentation]  This keyword is used for  getting a specific book
    ${Book_Id}  get_single_book_id
    &{header}   create dictionary  Content-Type=application/json; charset=utf-8
    ${response}     GET On Session    url    /books/${Book_Id}  headers=${header}
    log   ${response.status_code}
    log to console  ${response.json()}

    IF  ${Book_Id}>0 and ${Book_Id}<7
        log to console  Book details found
    END

    should be equal as strings   ${response.status_code}   200
    should contain  ${response.json()}  type
    should contain  ${response.json()}  id
    should contain  ${response.json()}  name
    should contain  ${response.json()}  available
    should contain  ${response.json()}  author
    should contain  ${response.json()}  price
    should contain  ${response.json()}  current-stock

Getting a required book
        [Documentation]  This keyword logs the particular book details
...        if 'Getting a required book' keyword fails it will give a certain message

        TRY
            Required book
        EXCEPT
            log to console  Enter a valid Book Id
        END

Ordering New Book
    [Documentation]     This Keyword is used to order New book
    [Tags]  API
    ${New_Book_Id}      get_user_id
    ${New_username}     get_user_name
    set suite variable      ${New_Book_Id}

    IF  ${New_Book_Id}==2
        log to console      Out of stock for this BookId
    ELSE IF   ${New_Book_Id}>6
        log to console      Enter valid BookId, entered BookId:
    ELSE
        log to console      Book is Ordered

    END

    &{req_body}     Create Dictionary   bookId=${New_Book_Id}   clientName=${New_username}
    &{header}       Create Dictionary    Content-Type=application/json   Authorization=Bearer ${token}
    ${response}     POST on session     url     orders      json=${req_body}    headers=${header}
    log     ${response.json()}

    ${OrderId}      get from dictionary     ${response.json()}    orderId
    log     ${OrderId}
    set suite variable      ${OrderId}

    should be equal as strings      ${response.status_code}     201
    should contain      '${response.status_code}'   20  Fail    Test Failed:Expected Response 201, got  for Ordering New Book
    should contain       '${response.json()}'   True

Create New Book_Order
    TRY
        Ordering New Book
    EXCEPT
        log to console      ${New_Book_Id}

    END
