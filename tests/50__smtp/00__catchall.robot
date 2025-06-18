*** Settings ***
Documentation    Messages to non-existing addresses are accepted and delivered to domain catchall
Resource    smtp.resource
Suite Teardown     Reset domain.test catchall
Test Tags    catchall

*** Test Cases ***
Existing user
    [Documentation]    Message for valid user does not go to catchall
    [Setup]    Set domain.test catchall to    user    u2
    Send SMTP message to    u1@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2

Existing group
    [Documentation]    Message for valid group does not go to catchall
    [Setup]    Set domain.test catchall to    group    g1
    Send SMTP message to    u3@inbound.test
    Should be delivered via LMTP to  u3
    Should not be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2

Non-existing address to catchall user
    [Setup]    Set domain.test catchall to    user    u2
    Send SMTP message to  unknown@inbound.test
    Should be delivered via LMTP to  u2

Non-existing address to catchall group
    [Setup]    Set domain.test catchall to    group    g1
    Send SMTP message to  unknown@inbound.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2


*** Keywords ***
Set domain.test catchall to
    [Arguments]    ${dtype}    ${name}
    Run task     module/${MID}/alter-domain
    ...            {"domain":"inbound.test","catchall":{"dtype":"${dtype}","name":"${name}"}}

Reset domain.test catchall
    Run task     module/${MID}/alter-domain
    ...            {"domain":"inbound.test","catchall":null}
