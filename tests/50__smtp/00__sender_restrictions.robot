*** Settings ***
Documentation    Sender/login match is enforced
Resource    smtp.resource
Suite Setup        Enable sender restriction
Suite Teardown     Disable sender restriction
Test Tags    sender    policy

*** Test Cases ***
Sender corresponds to user name
    Send SMTP message to  dest@remote.test
    ...                   from=u1@inbound.test
    ...                   credentials=u1:Nethesis,1234
    Should be relayed via SMTP

Sender corresponds to user's group name
    Send SMTP message to  dest@remote.test
    ...                   from=g1@inbound.test
    ...                   credentials=u1:Nethesis,1234
    Should be relayed via SMTP

Sender corresponds to user's address with exact domain
    Send SMTP message to  dest@remote.test
    ...                   from=a1@inbound.test
    ...                   credentials=u1:Nethesis,1234
    Should be relayed via SMTP

Sender corresponds to user's address with wildcard domain
    Send SMTP message to  dest@remote.test
    ...                   from=a2@inbound.test
    ...                   credentials=u1:Nethesis,1234
    Should be relayed via SMTP

Sender is the name of another user
    Send SMTP message to  dest@remote.test
    ...                   from=u2@inbound.test
    ...                   credentials=u1:Nethesis,1234
    ...                   expect_curl_exitcode=55
    Should return SMTP error    553 5.7.1 <u2@inbound.test>: Sender address rejected: not owned by user u1

Sender is an address owned by another user
    Send SMTP message to  dest@remote.test
    ...                   from=a1@inbound.test
    ...                   credentials=u3:Nethesis,1234
    ...                   expect_curl_exitcode=55
    Should return SMTP error    553 5.7.1 <a1@inbound.test>: Sender address rejected: not owned by user u3

Sender is the name of a group not containing the user
    Send SMTP message to  dest@remote.test
    ...                   from=g1@inbound.test
    ...                   credentials=u3:Nethesis,1234
    ...                   expect_curl_exitcode=55
    Should return SMTP error    553 5.7.1 <g1@inbound.test>: Sender address rejected: not owned by user u3

Sender is an unknown address
    Send SMTP message to  dest@remote.test
    ...                   from=invalid@inbound.test
    ...                   credentials=u1:Nethesis,1234
    ...                   expect_curl_exitcode=55
    Should return SMTP error    553 5.7.1 <invalid@inbound.test>: Sender address rejected: not owned by user u1

Sender is unrestricted on port 25
    Send SMTP message to  u1@inbound.test
    ...                   from=somebody@example.com
    Should be delivered via LMTP to  u1

Sender is unrestricted without SASL login
    Send SMTP message to  u2@inbound.test
    ...                   from=somebody@example.com
    ...                   mail_server=smtps://${PUBLIC_ADDRESS}
    Should be delivered via LMTP to  u2

*** Keywords ***
Enable sender restriction
    Add relay rule    wildcard    *    127.0.0.1    10001    ${EMPTY}
    Run task    module/${MID}/set-relay-configuration    {"postfix_restricted_sender":true}

Disable sender restriction
    Run task    module/${MID}/set-relay-configuration    {"postfix_restricted_sender":false}
    Cleanup relay rules
