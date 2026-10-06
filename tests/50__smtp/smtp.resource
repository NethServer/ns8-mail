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
        Should Be Equal As Integers    ${rc}  0  Unexpected curl exit code ${rc}: ${err}
        ${LAST_QUEUE_ID} =    Get Queue ID From Output    ${err}
        Should Not Be Empty    ${LAST_QUEUE_ID}    Error: queue ID not set, ${err}
    ELSE IF     r'${expect_curl_exitcode}' != ''
        Should Be Equal As Integers    ${rc}  ${expect_curl_exitcode}  Unexpected curl exit code ${rc}: ${err}
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

Should return SMTP unknown user error
    [Arguments]    ${address}
    Send SMTP message to  ${address}
    ...                   expect_curl_exitcode=
    Should return SMTP error    550 5.1.1 <${address}>: Recipient address rejected: User unknown in virtual alias table

Should not send bounce
    [Documentation]    Check that no non-delivery report was sent back for the last message
    Sleep    2s
    ${out} =    Execute Command
    ...    journalctl -o cat -t postfix/bounce -S '${LAST_TIMESTAMP}'
    Should Not Contain    ${out}    ${LAST_QUEUE_ID}: sender non-delivery notification
    ...    a bounce was sent for message ${LAST_QUEUE_ID}

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

Force SRS enabled
    [Documentation]    Force POSTFIX_SRS=2 so SRS stays active even when a
    ...                relay rule needed for the test harness itself (e.g.
    ...                a wildcard rule routing to a local SMTP sink) would
    ...                otherwise look like a smarthost and automatically
    ...                disable SRS (NethServer/dev#7741).
    Execute Command    runagent -m ${MID} python3 -c 'import agent ; agent.set_env("POSTFIX_SRS", "2")'
    Execute Command    runagent -m ${MID} systemctl --user reload postfix

Reset SRS setting
    Execute Command    runagent -m ${MID} python3 -c 'import agent ; agent.unset_env("POSTFIX_SRS")'
    Execute Command    runagent -m ${MID} systemctl --user reload postfix

Envelope sender should be SRS-rewritten
    [Tags]    outbound
    [Documentation]    Check the last queued message's envelope sender was
    ...                rewritten by postsrsd (NethServer/dev#7741), from
    ...                ${orig_local}@${orig_domain} to a SRS0=...@... address.
    [Arguments]    ${orig_local}    ${orig_domain}
    Sleep    500ms
    Wait Until Keyword Succeeds    3    1s
    ...    Check SRS rewritten sender by journal    ${orig_local}    ${orig_domain}

Check SRS rewritten sender by journal
    [Arguments]    ${orig_local}    ${orig_domain}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    journalctl -o cat -t postfix/qmgr -S '${LAST_TIMESTAMP}'
    ...    return_rc=True    return_stderr=True
    Should Match    ${out}    *${LAST_QUEUE_ID}: from=<SRS0=*=*=${orig_domain}=${orig_local}@*>*
    ...    postfix/qmgr envelope sender for ${LAST_QUEUE_ID} was not rewritten by SRS: ${out}

Get SRS rewritten sender
    [Documentation]    Return the SRS0=...@... envelope sender postsrsd
    ...                assigned to the last queued message, as recorded by
    ...                postfix/qmgr (NethServer/dev#7741).
    Sleep    500ms
    ${address} =    Wait Until Keyword Succeeds    3    1s
    ...    Get SRS rewritten sender from journal
    RETURN    ${address}

Get SRS rewritten sender from journal
    ${out}  ${err}  ${rc} =    Execute Command
    ...    journalctl -o cat -t postfix/qmgr -S '${LAST_TIMESTAMP}'
    ...    return_rc=True    return_stderr=True
    ${matches} =    Get Regexp Matches    ${out}    ${LAST_QUEUE_ID}: from=<(SRS0=[^>]+)>    1
    Should Not Be Empty    ${matches}
    ...    postfix/qmgr envelope sender for ${LAST_QUEUE_ID} was not SRS-rewritten: ${out}
    RETURN    ${matches}[0]

Set mailbox ${user} enabled
    [Arguments]    ${enabled}
    Run task    module/${MID}/set-mailbox-enabled    {"user":"${user}","enabled":${enabled}}

Initialize LDAP reference
    [Documentation]    The mail smtp test suites run isolated from tests/ldap_providers.resource,
    ...                so ${mid_ldap} must be looked up again here via service discovery instead of
    ...                relying on the suite variable set by "Configure LDAP user domain". This must
    ...                match the user domain currently bound to ${MID} (see "Switch to OpenLDAP user
    ...                domain" in 50__smtp/__init__.robot), since Postfix only queries that domain.
    [Arguments]    ${domain}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    runagent python3 -c 'import agent ; print(agent.list_service_providers(agent.redis_connect(), "ldap", "tcp", filters={"domain":"${domain}"})[0]["module_id"])'
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    Failed to look up LDAP provider module_id: ${err}
    Should Not Be Empty    ${out}    LDAP provider module_id not found in service discovery
    VAR    ${mid_ldap}    ${out}    scope=SUITES

Set ${user} LDAP mail attribute
    [Arguments]    ${mail}
    Run Keyword    Run Task    module/${mid_ldap}/alter-user    {"user":"${user}","mail":"${mail}"}
