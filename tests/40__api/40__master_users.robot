*** Settings ***
Resource    ../api.resource

*** Test Cases ***
Get the initial list of master users
    ${jpayload} =    Run task    module/${MID}/get-master-users    ""    decode_json=${FALSE}
    Set Suite Variable    ${mulorig}    ${jpayload}

Check u3 has no master user IMAP privilege
    Run task    module/${MID}/set-master-users    {"master_users":[]}
    Wait Until Keyword Succeeds    20 seconds    1 second
    ...    Master user login fails    u2*u3

Set u1 as master user
    Run task    module/${MID}/set-master-users    {"master_users":["u1"]}

Check u1 is in the master user list
    ${getresp} =     Run task    module/${MID}/get-master-users    ""
    Should Contain    ${getresp}[master_users]    u1

Check u1 has master user IMAP privilege
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 9 curl -v -f -u u2*u1:Nethesis,1234 imap://127.0.0.1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0
    Should Contain    ${out}    * LIST (\\HasNoChildren) "/" INBOX

Check u3 is not a master user
    Master user login fails    u2*u3

Clean up the master user list
    Run task    module/${MID}/set-master-users    ${mulorig}

*** Keywords ***
Master user login fails
    [Arguments]    ${login}
    [Documentation]    u3's password is good, but u3 is not a master user
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 9 curl -v -f -u ${login}:Nethesis,1234 imap://127.0.0.1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  67
    Should Contain    ${err}    AUTHENTICATIONFAILED
