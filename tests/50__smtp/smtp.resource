*** Settings ***
Library    SSHLibrary
Library    DateTime
Library    String
Library    Collections
Resource    ../api.resource

*** Keywords ***
Send SMTP message to
    [Arguments]    ${to}    ${from}=default@example.org    ${credentials}=    ${expect_curl_exitcode}=0    ${mail_server}=${PUBLIC_ADDRESS}
    ${username} =    Fetch From Left    ${credentials}    :
    ${LAST_TIMESTAMP} =    Get Current Date
    Set Test Variable    ${LAST_TIMESTAMP}
    IF    r'${credentials}' == ''
        ${out}  ${err}  ${rc} =    Execute Command
        ...    MAIL_SERVER=${mail_server} bash /tmp/test-mta.sh ${to} ${from}
        ...    return_rc=True    return_stderr=True
    ELSE
        ${out}  ${err}  ${rc} =    Execute Command
        ...    MAIL_SERVER=${mail_server} bash /tmp/test-msa.sh ${to} ${from} ${credentials}
        ...    return_rc=True    return_stderr=True
    END
    Set Test Variable    ${LAST_CURL_EXITCODE}  ${rc}
    Set Test Variable    ${LAST_CURL_ERROR}     ${err}
    Set Test Variable    ${LAST_QUEUE_ID}    ${EMPTY}
    IF    r'${expect_curl_exitcode}' == '0'
        Should Be Equal As Integers    ${rc}  0  Unexpected curl exit code ${rc}
        ${LAST_QUEUE_ID} =    Get Queue ID From Output    ${err}
        Should Not Be Empty    ${LAST_QUEUE_ID}    Error: queue ID not set
    ELSE IF     r'${expect_curl_exitcode}' != ''
        Should Be Equal As Integers    ${rc}  ${expect_curl_exitcode}  Unexpected curl exit code ${rc}
    END

Get Queue ID From Output
    [Arguments]    ${text}
    ${group_matches} =    Get Regexp Matches    ${text}    queued as (\\w+)    1
    Should Not Be Empty    ${group_matches}    Queue ID not found in output
    ${queue_id} =       Get From List    ${group_matches}    0
    RETURN    ${queue_id}

Should be relayed via SMTP
    [Tags]    outbound
    [Arguments]    ${port}=10001    ${smtp_user}=
    Sleep    500ms
    Wait Until Keyword Succeeds    3    1s
    ...    Check SMTP delivery by journal    ${port}    ${smtp_user}

Should return SMTP error
    [Arguments]    ${pattern}
    Should Match    ${LAST_CURL_ERROR}    *${pattern}*    msg=Error from curl doesn't match pattern `${pattern}`: `${LAST_CURL_ERROR}`.

Check SMTP delivery by journal
    [Documentation]    Check if the journal contents since last keyword run
    ...                match the password lookup and delivery patterns.
    [Arguments]    ${rport}    ${ruser}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    journalctl -o cat -t postfix/smtp -S '${LAST_TIMESTAMP}'
    ...    return_rc=True    return_stderr=True
    ${queue_id_pattern} =    Set Variable    ${LAST_QUEUE_ID}: to\=<*>, relay\=127.0.0.1[[]127.0.0.1[]]:${rport}, * status\=sent (250 2.0.0 Ok)
    Should Not Be Empty    ${out}    Journal returned no contents for relay user ${ruser}, relay port ${rport}, queue ID ${LAST_QUEUE_ID}, and curl error ${LAST_CURL_ERROR}
    IF    bool(r'${ruser}')
        Should Match    ${out}    *smtp_sasl_passwd_lookup: host `127.0.0.1' user `${ruser}' pass `${ruser}-pass'*${queue_id_pattern}*
        ...    postfix/smtp credentials and delivery pattern do not match
    ELSE
        Should Not Match    ${out}    *smtp_sasl_passwd_lookup: host `127.0.0.1' user * pass *
        ...    postfix/smtp should not use credentials
        Should Match    ${out}    *${queue_id_pattern}*
        ...    postfix/smtp delivery pattern does not match
    END

Should be delivered via LMTP to
    [Tags]    inbound
    [Documentation]  Check if the message was passed to Dovecot via LMTP.
    ...              If ${rcpt} argument is specified, ensure it matches the expected user name.
    [Arguments]    ${rcpt}=*
    Sleep    500ms
    Wait Until Keyword Succeeds    3    1s
    ...    Check LMTP delivery by journal    ${rcpt}

Should not be delivered via LMTP to
    [Tags]    inbound
    [Arguments]    ${rcpt}
    Run Keyword And Expect Error
    ...    *: postfix/lmtp delivery record for message * not found:*
    ...    Should be delivered via LMTP to  ${rcpt}

Check LMTP delivery by journal
    [Arguments]    ${rcpt}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    journalctl -o cat -t postfix/lmtp -S '${LAST_TIMESTAMP}'
    ...    return_rc=True    return_stderr=True
    Should Match    ${out}    *${LAST_QUEUE_ID}: to\=<${rcpt}@*status\=sent (250 2.0.0 * Saved)*
    ...    postfix/lmtp delivery record for message ${LAST_QUEUE_ID} not found

Add relay rule
    [Arguments]    ${rtype}    ${rsubject}    ${rhost}    ${rport}    ${rusername}
    Run task    module/${MID}/add-relay-rule    {"rule_type":"${rtype}","rule_subject":"${rsubject}","host":"${rhost}","port":${rport},"mandatory_tls":false,"username":"","password":"","enabled":true}
    IF    r'$rusername' != ""
        Execute Command    runagent -m ${MID} podman exec -w /srv postfix sqlite3 pcdb.sqlite "UPDATE relayrules SET username='${rusername}', password='${rusername}-pass' WHERE rule_subject LIKE '${rsubject}' AND rule_type == '${rtype}'"
    END

Cleanup relay rules
    Execute Command    runagent -m ${MID} podman exec -w /srv postfix sqlite3 pcdb.sqlite 'DELETE FROM relayrules;'
