*** Settings ***
Resource  ../Library/CommonResources.robot

*** Variables ***

*** Keywords ***
Start Session
    create session      url     ${base_url}     verify=True

Creating accessToken
    [Documentation]     creating the random email ID to creating the bearer Token
    [Tags]      API
    ${random_email}     get_random_email
    &{req_body}     Create Dictionary   clientName=sunil    clientEmail=${random_email}
    &{header}       Create Dictionary   Content-Type=application/json
    ${response}     Post On Session     url     api-clients     json=${req_body}    headers=${header}
    log to console   ${response}
    ${token}    get from dictionary    ${response.json()}      accessToken
    set suite variable      ${token}

Get all users details
    [Tags]  API
    &{header}=      Create Dictionary       Content-Tpye=application/json
    ${response}     Get On Session  url     books   headers=${header}
    ${body}     convert to string       ${response.json()}
    ${log}  log to console      ${response.status_code}
    should contain        '${response.status_code}'    200
    ${header_validate}      Get from Dictionary       ${response.headers}   Content-Length
    should contain      ${response.headers}   Content-Length
    should be equal     ${header_validate}      417

Order a book
    [Tags]      API
    &{req_body}     create dictionary       bookId=3    clientName=lilly
    &{header}=      Create Dictionary       Content-Tpye=application/json    Authorization=Bearer ${token}
    ${response}     POST on session     url     orders      json=${req_body}    headers=${header}
    log to console      ${response.json()}

Get all order details
    [Tags]      API
    &{header}=      Create Dictionary       Content-Tpye=application/json    Authorization=Bearer ${token}
    ${response}     GET on session      url     orders      headers=${header}
    log to console      ${response.json()}


