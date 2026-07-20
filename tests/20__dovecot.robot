*** Settings ***
Resource    api.resource
Resource    user_domain.resource
Resource    keywords.resource
Library     SSHLibrary

*** Variables ***
${SCENARIO}              install

*** Test Cases ***
Bind to LDAP user domain
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"ldap.dom.test","mail_domain":"domain.test"}

Check module update
    Log  Scenario ${SCENARIO} with ${IMAGE_URL}  console=${True}
    IF    r'${SCENARIO}' == 'update'
        ${out}  ${rc} =  Execute Command  api-cli run update-module --data '{"force":true,"module_url":"${IMAGE_URL}","instances":["${MID}"]}'  return_rc=${True}
        Should Be Equal As Integers  ${rc}  0  action update-module ${IMAGE_URL} failed
    END

TCP ports are open
    [Template]    Retry until TCP port is open
    110
    143
    # 587
    993
    995
    # 465
    9288
    9289
    2000
    4190

API HTTP endpoint
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 10 curl -f http://127.0.0.1:9288/doveadm/v1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  22
    Should Contain    ${err}    : 401

Metrics HTTP endpoint (stats)
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 10 curl -f http://127.0.0.1:9289/metrics
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0

Login TLS policy
    [Template]    Retry test
    TLS required on non-secure IMAP connections
    IMAPs endpoint login

LDAP Login checks
    [Template]    Retry test
    IMAP login good credentials
    IMAP login bad credentials
    AD user credentials are bad with LDAP

Default mailbox folders are created
    [Documentation]    Sent/Drafts/Junk/Trash must exist and be subscribed at first
    ...                mailbox access, without any message being sent (issue dev#8104).
    Wait Until Keyword Succeeds    20 seconds    1 second
    ...    Default folders exist and are subscribed    u1

Switch to AD user domain
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"ad.dom.test","mail_domain":"domain.test"}

Active Directory Login checks
    [Template]    Retry test
    IMAP login good credentials
    IMAP login bad credentials
    LDAP user credentials are bad with AD

*** Keywords ***
Default folders exist and are subscribed
    [Arguments]    ${user}
    # Force namespace init so auto=subscribe mailboxes are materialized
    Execute Command    timeout ${curl_timeout} curl -s -f -u u1:Nethesis,1234 imap://127.0.0.1 || true
    ${out}  ${err}  ${rc} =    Execute Command
    ...    runagent -m ${MID} podman exec dovecot doveadm mailbox list -s -u ${user}
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0
    Should Contain    ${out}    Drafts
    Should Contain    ${out}    Sent
    Should Contain    ${out}    Junk
    Should Contain    ${out}    Trash

LDAP user credentials are bad with AD
    [Documentation]    When bad credentials are issued the server replies with
    ...                a few seconds of delay.
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 9 curl -v -f -u u2:LdapPass,1234 imap://127.0.0.1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  67
    Should Contain    ${err}    AUTHENTICATIONFAILED

AD user credentials are bad with LDAP
    [Documentation]    When bad credentials are issued the server replies with
    ...                a few seconds of delay.
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 9 curl -v -f -u u2:AdPass,1234 imap://127.0.0.1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  67
    Should Contain    ${err}    AUTHENTICATIONFAILED
