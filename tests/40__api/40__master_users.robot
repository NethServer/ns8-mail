*** Settings ***
Resource    ../api.resource

*** Test Cases ***
Get the initial list of master users
    ${jpayload} =    Run task    module/${MID}/get-master-users    ""    decode_json=${FALSE}
    Set Suite Variable    ${mulorig}    ${jpayload}

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

Clean up the master user list
    Run task    module/${MID}/set-master-users    ${mulorig}
