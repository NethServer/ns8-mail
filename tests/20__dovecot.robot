*** Settings ***
Resource    api.resource
Resource    user_domain.resource
Library     SSHLibrary

*** Test Cases ***
Bind to Active Directory user domain
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"ad.dom.test","mailbox_quota_mb":100}

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

Active Directory Login checks
    [Template]    Retry test
    IMAP login good credentials
    IMAP login bad credentials
    LDAP user credentials are bad with AD

Switch to LDAP user domain
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"ldap.dom.test","mailbox_quota_mb":100}

LDAP Login checks
    [Template]    Retry test
    IMAP login good credentials
    IMAP login bad credentials
    AD user credentials are bad with LDAP

*** Keywords ***
Retry test
    [Arguments]    ${keyword}
    Wait Until Keyword Succeeds    20 seconds    0.5 seconds    ${keyword}

TCP port is open
    [Arguments]    ${port}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    exec 3<>/dev/tcp/127.0.0.1/${port}
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0

Retry until TCP port is open
    [Arguments]    ${port}
    Wait Until Keyword Succeeds    10 seconds    0.2 seconds
    ...    TCP port is open    ${port}
    

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
