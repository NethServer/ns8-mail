*** Settings ***
Library    SSHLibrary
Library    String
Library    Collections
Library    DateTime
Resource    ../api.resource
Resource    ../keywords.resource

*** Variables ***
${U1CREDS}    u1:Nethesis,1234
${U3CREDS}    u3:Nethesis,1234

*** Keywords ***
Send SMTP message
    [Arguments]    ${from}    ${to}    ${credentials}=    ${rc_expected}=0    ${mail_server}=${MAIL_SERVER}
    ${username}=    Fetch From Left    ${credentials}    :
    IF    not r'${username}'
        ${out}  ${err}  ${rc} =    Execute Command
        ...    MAIL_SERVER=${mail_server} bash /tmp/test-mta.sh ${to} ${from}
        ...    return_rc=True    return_stderr=True
    ELSE
        ${out}  ${err}  ${rc} =    Execute Command
        ...    MAIL_SERVER=${mail_server} bash /tmp/test-msa.sh ${to} ${from} ${credentials}
        ...    return_rc=True    return_stderr=True
    END
    IF    ${rc_expected} == 0
        Should Be Equal As Integers    ${rc}  0  Unexpected curl exit code ${rc}
        ${queue_id}=    Get Queue ID From Output    ${err}
        RETURN    ${queue_id}
    ELSE IF     ${rc_expected} > 0
        Should Be Equal As Integers    ${rc}  ${rc_expected}  Unexpected curl exit code ${rc}
        RETURN    ${err}
    ELSE
        # Ignore exit code
        RETURN    ${err}
    END

Should fail because not logged in
    [Arguments]    ${from}    ${to}    ${credentials}=    ${mail_server}=${MAIL_SERVER}
    ${err}=    Send SMTP message    ${from}    ${to}    ${credentials}
    ...        rc_expected=-1    mail_server=${mail_server}
    Should Contain    ${err}    553 5.7.1 <${from}>: Sender address rejected: not logged in

Should fail sender/login policy
    [Arguments]    ${from}    ${credentials}    ${mail_server}=${MAIL_SERVER}
    ${user}=    Fetch From Left    ${credentials}    :
    ${err}=    Send SMTP message    ${from}    dude@wildcard.test    ${credentials}
    ...        rc_expected=-1    mail_server=${mail_server}
    Should Contain    ${err}    553 5.7.1 <${from}>: Sender address rejected: not owned by user ${user}

Should be user unknown
    [Arguments]    ${from}    ${to}    ${credentials}=
    ${err}=    Send SMTP message    ${from}    ${to}    ${credentials}    rc_expected=-1
    Should Contain    ${err}    550 5.1.1 <${to}>: Recipient address rejected: User unknown in virtual alias table

Should be relay access denied
    [Arguments]    ${from}    ${to}    ${credentials}=    ${mail_server}=${MAIL_SERVER}
    ${err}=    Send SMTP message    ${from}    ${to}    ${credentials}
    ...        rc_expected=-1    mail_server=${mail_server}
    Should Contain    ${err}    554 5.7.1 <${to}>: Relay access denied

Get Queue ID From Output
    [Arguments]    ${text}
    ${group_matches}=    Get Regexp Matches    ${text}    queued as (\\w+)    1
    Should Not Be Empty    ${group_matches}    Queue ID not found in output
    ${queue_id}=       Get From List    ${group_matches}    0
    RETURN    ${queue_id}

Send message as MTA and check delivery
    [Arguments]    ${from}    ${to}    ${imap_folder}=INBOX    @{delivery_args}
    ${queue_id}=    Send SMTP message    ${from}    ${to}
    ${count_delivery_checks}=    Get Length    ${delivery_args}
    FOR    ${counter}    IN RANGE    0    ${count_delivery_checks}    2
        ${credentials}=        Get From List    ${delivery_args}    ${counter}
        ${delivery_status}=    Get From List    ${delivery_args}    ${counter + 1}
        Check delivery by IMAP    ${queue_id}    ${imap_folder}    ${credentials}    ${delivery_status}
    END

Check delivery by IMAP
    [Arguments]    ${queue_id}    ${imap_folder}    ${credentials}    ${delivery_status}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    curl -u '${credentials}' -v -X 'SEARCH HEADER Received ${queue_id}' imap://127.0.0.1/${imap_folder}
    ...    return_rc=True    return_stderr=True
    ${matches}=    Get Regexp Matches    ${out}    ^\\* SEARCH \\d+
    IF    "${delivery_status}" == "delivered"
        Should Not Be Empty    ${matches}    Message queue ID ${queue_id} not found in ${imap_folder}
    ELSE
        Should Be Empty        ${matches}    Message queue ID found ${queue_id} in ${imap_folder}
    END

Should be sent via
    [Arguments]    ${ruser}    ${rport}    ${from}    ${to}    ${credentials}    ${mail_server}=${MAIL_SERVER}
    ${tstart}=    Get Current Date
    ${queue_id}=    Send SMTP message    ${from}    ${to}    ${credentials}    mail_server=${mail_server}
    Check delivery by journal    ${ruser}    ${rport}    ${queue_id}    ${tstart}

Check delivery by journal
    [Documentation]    Check if the journal contents since ${tstart} 
    ...                match the password lookup and delivery patterns.
    [Arguments]    ${ruser}    ${rport}    ${queue_id}    ${tstart}
    Sleep    500ms    Ensure journal data is flushed to disk
    ${out}  ${err}  ${rc} =    Execute Command
    ...    journalctl -o cat -t postfix/smtp --since '${tstart}'
    ...    return_rc=True    return_stderr=True
    ${queue_id_pattern}=    Set Variable    ${queue_id}: to=<*>, relay=127.0.0.1[[]127.0.0.1[]]:${rport}, * status=sent (250 2.0.0 Ok)
    IF    bool(r'${ruser}')
        Should Match    ${out}    *smtp_sasl_passwd_lookup: host `127.0.0.1' user `${ruser}' pass `rpass'*${queue_id_pattern}*
        ...    postfix/smtp credentials and delivery pattern do not match
    ELSE
        Should Not Match    ${out}    *smtp_sasl_passwd_lookup: host `127.0.0.1' user * pass *
        ...    postfix/smtp should not use credentials
        Should Match    ${out}    *${queue_id_pattern}*
        ...    postfix/smtp delivery pattern does not match
    END

Switch user domain
    [Arguments]     ${udom}
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"${udom}","mail_domain":"domain.test"}
