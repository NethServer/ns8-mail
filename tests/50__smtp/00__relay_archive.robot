*** Settings ***
Documentation    Piler/Archive scenario based on always_bcc. The archive
...              copy keeps the original envelope sender, even if SRS
...              rewrites it (NethServer/dev#7741).
Resource    smtp.resource
Suite Setup        Run keywords
...                Force SRS enabled
...                AND    Add Piler relay rule
Suite Teardown     Run keywords
...                Remove Piler relay rule
...                AND    Reset SRS setting
Test Tags    alwaysbcc

*** Test Cases ***
Inbound message archive
    Send SMTP message to    u1@inbound.test
    Should be relayed via SMTP  port=10002
    Should be delivered via LMTP to  u1
    Envelope sender should be SRS-rewritten    default    example.org
    SMTP envelope sender should be    10002    default@example.org

Outbound message archive
    Send SMTP message to  someone@wildcard.test
    ...                   from=u1@inbound.test
    ...                   credentials=u1:Nethesis,1234
    Should be relayed via SMTP  port=10001
    Should be relayed via SMTP  port=10002

*** Keywords ***
Add Piler relay rule
    Add relay rule    wildcard      *                 127.0.0.1    10001    ${EMPTY}
    Add relay rule    always-bcc    archive@piler1    127.0.0.1    10002    ${EMPTY}
    Run task    module/${MID}/set-always-bcc    {"bcc": "archive@piler1"}

Remove Piler relay rule
    Run task    module/${MID}/set-always-bcc    {"bcc": ""}
    Cleanup relay rules

