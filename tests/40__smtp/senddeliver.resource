*** Settings ***
Library    SSHLibrary
Library    String
Library    Collections
Resource    ../api.resource
Resource    ../keywords.resource

*** Variables ***
${U1CREDS}    u1:Nethesis,1234
${U3CREDS}    u3:Nethesis,1234

*** Keywords ***
Send message MTA
    [Arguments]    ${from}    ${to}    ${rc_expected}=0
    ${out}  ${err}  ${rc} =    Execute Command
    ...    MAIL_SERVER=${MAIL_SERVER} bash /tmp/test-mta.sh ${to} ${from}
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  ${rc_expected}  Unexpected exit code
    ${queue_id}=    Get Queue ID From Output    ${err}
    Log    Queue ID: ${queue_id}
    RETURN    ${queue_id}

Get Queue ID From Output
    [Arguments]    ${text}
    ${matches}=    Get Regexp Matches    ${text}    queued as (\\w+)
    Should Not Be Empty    ${matches}    Queue ID not found in output
    ${queue_id}=    Get From List    ${matches}    1
    RETURN    ${queue_id}

Send message as MTA and check delivery
    [Arguments]    ${from}    ${to}    ${credentials}    ${delivery_status}=delivered    ${imap_folder}=INBOX    ${rc_expected}=0
    ${queue_id}=    Send message MTA    ${from}    ${to}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    curl -u '${credentials}' -v -X 'SEARCH HEADER Received ${queue_id}' imap://127.0.0.1/${imap_folder}
    ...    return_rc=True    return_stderr=True
    ${matches}=    Get Regexp Matches    ${err}    ^\\* SEARCH 1
    IF    $delivery_status == "delivered"
        Should Not Be Empty    ${matches}    Message ID not found in ${imap_folder}
    ELSE
        Should Be Empty    ${matches}    Message ID found in ${imap_folder}
    END

Assign public IP address
    ${out}=    Execute Command    bash -c "ip -o route get 255.0 2>/dev/null | sed -e 's/.*src \\([^ ]*\\) .*/\\1/'"
    Set Global Variable    $MAIL_SERVER    ${out}

Create mail domains
    Run task     module/${MID}/add-domain
    ...            {"domain":"mta-users.test","addusers":true,"addgroups":false}
    Run task     module/${MID}/add-domain
    ...            {"domain":"mta-groups.test","addusers":false,"addgroups":true}
    Run task     module/${MID}/add-domain
    ...            {"domain":"mta-ug.test","addusers":true,"addgroups":true}

Destroy mail domains
    Run task     module/${MID}/remove-domain
    ...            {"domain":"mta-users.test"}
    Run task     module/${MID}/remove-domain
    ...            {"domain":"mta-groups.test"}
    Run task     module/${MID}/remove-domain
    ...            {"domain":"mta-ug.test"}
Switch user domain
    [Arguments]     ${udom}
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"${udom}","mail_domain":"domain.test"}