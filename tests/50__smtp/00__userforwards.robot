*** Settings ***
Documentation    Message for user with forward address is sent with or without copy
Resource    smtp.resource
Suite Setup     Enable wildcard relay rule
Suite Teardown  Cleanup relay rules
Test Tags    userforward    outbound

*** Test Cases ***
Forward to user
    [Setup]            Configure forward for user  u3  to=u1  dtype=user
    [Teardown]         Cleanup forward for u3
    Send SMTP message to    u3@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u3

Forward to user with copy
    [Setup]            Configure forward for user  u3  to=u1  dtype=user  keepcopy=true
    [Teardown]         Cleanup forward for u3
    Send SMTP message to    u3@inbound.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u3

Forward to group
    [Setup]            Configure forward for user  u3  to=g1  dtype=group
    [Teardown]         Cleanup forward for u3
    Send SMTP message to    u3@inbound.test
    Should not be delivered via LMTP to  u3
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2

Forward to external address
    [Setup]            Configure forward for user  u3  to=forward@wildcard.test  dtype=external
    [Teardown]         Cleanup forward for u3
    Send SMTP message to    u3@inbound.test
    Should be relayed via SMTP  10001  usr_relay
    Should not be delivered via LMTP to  u3

*** Keywords ***
Configure forward for user
    [Arguments]  ${user}    ${to}    ${dtype}=user    ${keepcopy}=false
    Run task    module/${MID}/alter-user-mailbox    {"user":"${user}","forward":{"keepcopy":${keepcopy},"destinations":[{"dtype":"${dtype}","name":"${to}"}]}}

Cleanup forward for ${user}
    Run task    module/${MID}/alter-user-mailbox    {"user":"${user}","forward":{"destinations":[]}}

Enable wildcard relay rule
    Add relay rule    wildcard    *    127.0.0.1    10001    usr_relay
