*** Settings ***
Documentation    A bounce/DSN addressed to a genuine SRS0 recipient (its
...              signature verified by postsrsd against its own secret,
...              via a check_recipient_access pipemap) is accepted and
...              routed to the real original sender. An address that only
...              looks like an SRS0 recipient, but does not verify, is
...              still rejected as unlisted (NethServer/dev#7741).
Resource    smtp.resource
Suite Setup        Add relay rule    wildcard    *    127.0.0.1    10001    ${EMPTY}
Suite Teardown     Cleanup relay rules
Test Tags    srs    outbound

*** Test Cases ***
Genuine SRS0 recipient is accepted and routed back
    Send SMTP message to    somebody@wildcard.test
    ...                     credentials=u3:Nethesis,1234
    Should be relayed via SMTP    10001
    ${srs_address} =    Get SRS rewritten sender
    Send SMTP message to    ${srs_address}
    Should be relayed via SMTP    10001

Forged SRS0 recipient is rejected
    Send SMTP message to    SRS0=deadbeef=99=example.org=nobody@inbound.test
    ...                     expect_curl_exitcode=
    Should return SMTP error
    ...    550 5.1.1 <SRS0=deadbeef=99=example.org=nobody@inbound.test>: Recipient address rejected: User unknown in virtual alias table
