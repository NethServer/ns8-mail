*** Settings ***
Documentation    General switch for always bcc
Resource    smtp.resource
Suite Setup        Set alwaysbcc
Suite Teardown     Reset alwaysbcc
Test Tags    alwaysbcc

*** Test Cases ***
Inbound message Bcc
    Send SMTP message to    u1@inbound.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2

Outbound message Bcc
    Send SMTP message to  someone@wildcard.test
    ...                   from=u1@inbound.test
    ...                   credentials=u1:Nethesis,1234
    Should be relayed via SMTP
    Should be delivered via LMTP to  u2

*** Keywords ***
Set alwaysbcc
    Add relay rule    wildcard    *    127.0.0.1    10001    ${EMPTY}
    Run task    module/${MID}/set-always-bcc    {"bcc": "u2@addusers.test"}

Reset alwaysbcc
    Run task    module/${MID}/set-always-bcc    {"bcc": ""}
    Cleanup relay rules
