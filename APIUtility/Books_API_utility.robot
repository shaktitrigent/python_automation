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

