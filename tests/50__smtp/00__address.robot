*** Settings ***
Documentation    Delivery through mail address with different destination types
Resource    smtp.resource
Suite Setup        Create aliases and domains
Suite Teardown     Remove aliases and domains
Test Tags    address

*** Test Cases ***
Single user destination
    [Documentation]    Address expanded to a single user
    Send SMTP message to    a1@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not be delivered via LMTP to  u3

Multiple user destinations
    [Documentation]    Address expanded to multiple users
    Send SMTP message to    a3@inbound.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2
    Should be delivered via LMTP to  u3

Multiple user and group destinations
    [Documentation]    Destinations can be both user and groups at the same time
    Send SMTP message to    a4@inbound.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2
    Should be delivered via LMTP to  u3

Wildcard domain alias
    [Documentation]    Wildcard address matches each defined domain
    Send SMTP message to    a2@inbound.test
    Should be delivered via LMTP to  u1
    Send SMTP message to    a2@addusers.test
    Should be delivered via LMTP to  u1
    Send SMTP message to    a2@addgroups.test
    Should be delivered via LMTP to  u1

Mixing internal and external destinations
    [Documentation]    If the address has also an external destination, an outbound message is sent to it.
    [Setup]    Add relay rule    wildcard    *    127.0.0.1    10001    ${EMPTY}
    [Teardown]    Cleanup relay rules
    Send SMTP message to    a5@inbound.test
    Should be relayed via SMTP
    Should be delivered via LMTP to  u1

Address not found
    [Template]  Should return SMTP unknown user error
    unknown@addusers.test
    unknown@addgroups.test
    unknown@inbound.test

*** Keywords ***
Create aliases and domains
    # a1, a2 are defined by the parent suite
    Run task    module/${MID}/add-address    {"atype":"domain","local":"a3","domain":"inbound.test","destinations":[{"dtype":"user","name":"u1"},{"dtype":"user","name":"u2"},{"dtype":"user","name":"u3"}]}
    Run task    module/${MID}/add-address    {"atype":"domain","local":"a4","domain":"inbound.test","destinations":[{"dtype":"user","name":"u3"},{"dtype":"group","name":"g1"}]}
    Run task    module/${MID}/add-address    {"atype":"domain","local":"a5","domain":"inbound.test","destinations":[{"dtype":"user","name":"u1"},{"dtype":"external","name":"external@wildcard.test"}]}

Remove aliases and domains
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"a3","domain":"inbound.test"}
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"a4","domain":"inbound.test"}
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"a5","domain":"inbound.test"}

Should return SMTP unknown user error
    [Arguments]    ${address}
    Send SMTP message to  ${address}
    ...                   expect_curl_exitcode=
    Should return SMTP error    550 5.1.1 <${address}>: Recipient address rejected: User unknown in virtual alias table
