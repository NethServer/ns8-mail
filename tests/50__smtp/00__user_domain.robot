*** Settings ***
Documentation    If a mail domain with the same name of the user domain exists,
...              it is accessible like any other domain, including aliases and forwards.
...              This scenario is typical with an OpenLDAP user domain because it reflects default settings.
Resource    smtp.resource
Suite Setup        Create aliases, forwards, and domains
Suite Teardown     Remove aliases, forwards, and domains
Test Tags    address    domain    userdomain

*** Test Cases ***
User alias address
    Send SMTP message to    a2@ldap.dom.test
    Should be delivered via LMTP to  u1

Internal address
    Send SMTP message to    i1@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <i1@ldap.dom.test>: Recipient address rejected: access denied

User is public, group and vmail are internal
    [Tags]    internal    bug-7552
    Send SMTP message to    u1@ldap.dom.test
    Should be delivered via LMTP to  u1
    Send SMTP message to    g1@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <g1@ldap.dom.test>: Recipient address rejected: access denied
    Send SMTP message to    vmail@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <vmail@ldap.dom.test>: Recipient address rejected: access denied

Group is public, user and vmail are internal
    [Tags]    internal    bug-7552
    [Setup]       Run task    module/${MID}/alter-domain    {"domain":"ldap.dom.test","addusers":false,"addgroups":true}
    [Teardown]    Run task    module/${MID}/alter-domain    {"domain":"ldap.dom.test","addusers":true,"addgroups":false}
    Send SMTP message to    g1@ldap.dom.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2
    Send SMTP message to    u1@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <u1@ldap.dom.test>: Recipient address rejected: access denied
    Send SMTP message to    vmail@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <vmail@ldap.dom.test>: Recipient address rejected: access denied

Group and user are public, vmail is internal
    [Tags]    internal    bug-7552
    [Setup]       Run task    module/${MID}/alter-domain    {"domain":"ldap.dom.test","addusers":true,"addgroups":true}
    [Teardown]    Run task    module/${MID}/alter-domain    {"domain":"ldap.dom.test","addusers":true,"addgroups":false}
    Send SMTP message to    g1@ldap.dom.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2
    Send SMTP message to    u1@ldap.dom.test
    Should be delivered via LMTP to  u1
    Send SMTP message to    vmail@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <vmail@ldap.dom.test>: Recipient address rejected: access denied

Group alias address is expanded
    Send SMTP message to    a4@ldap.dom.test
    Should be delivered via LMTP to  u3
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2

Public mailbox alias with LDAP user domain
    [Setup]    Create public mailbox
    [Teardown]    Remove public mailbox
    Send SMTP message to    pub1@ldap.dom.test
    Should be delivered via LMTP to  vmail+pub1

Forward to user (userdomain)
    [Tags]    bug-7553    userforward
    [Setup]            Configure forward for user  u3  to=u1  dtype=user
    [Teardown]         Cleanup forward for u3
    Send SMTP message to    u3@ldap.dom.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u3

Forward to user with copy (userdomain)
    [Tags]    bug-7553    userforward
    [Setup]            Configure forward for user  u3  to=u1  dtype=user  keepcopy=true
    [Teardown]         Cleanup forward for u3
    Send SMTP message to    u3@ldap.dom.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u3

Forward to group (userdomain)
    [Tags]    bug-7553    userforward
    [Setup]            Configure forward for user  u3  to=g1  dtype=group
    [Teardown]         Cleanup forward for u3
    Send SMTP message to    u3@ldap.dom.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2
    Should not be delivered via LMTP to  u3

Forward to external address (userdomain)
    [Tags]    bug-7553    userforward
    [Setup]            Configure forward for user  u3  to=forward@wildcard.test  dtype=external
    [Teardown]         Cleanup forward for u3
    Send SMTP message to    u3@ldap.dom.test
    Should be relayed via SMTP  10001  usr_relay
    Should not be delivered via LMTP to  u3

*** Keywords ***
Create aliases, forwards, and domains
    Run task     module/${MID}/add-domain       {"domain":"ldap.dom.test","addusers":true,"addgroups":false}
    Run task     module/${MID}/add-address      {"internal":true,"atype":"domain","local":"i1","domain":"ldap.dom.test","destinations":[{"dtype":"user","name":"u1"}]}
    Run task     module/${MID}/add-address      {"atype":"domain","local":"a4","domain":"ldap.dom.test","destinations":[{"dtype":"user","name":"u3"},{"dtype":"group","name":"g1"}]}
    Enable wildcard relay rule

Remove aliases, forwards, and domains
    Run task     module/${MID}/remove-address   {"atype":"domain","local":"i1","domain":"ldap.dom.test"}
    Run task     module/${MID}/remove-address   {"atype":"domain","local":"a4","domain":"ldap.dom.test"}
    Run task     module/${MID}/remove-domain    {"domain":"ldap.dom.test"}
    Cleanup relay rules

Configure forward for user
    [Arguments]  ${user}    ${to}    ${dtype}=user    ${keepcopy}=false
    Run task    module/${MID}/alter-user-mailbox    {"user":"${user}","forward":{"keepcopy":${keepcopy},"destinations":[{"dtype":"${dtype}","name":"${to}"}]}}

Cleanup forward for ${user}
    Run task    module/${MID}/alter-user-mailbox    {"user":"${user}","forward":{"destinations":[]}}

Enable wildcard relay rule
    Add relay rule    wildcard    *    127.0.0.1    10001    usr_relay

Create public mailbox
    Run task    module/${MID}/add-public-mailbox    {"mailbox":"pub1","acls":[]}

Remove public mailbox
    Run task    module/${MID}/remove-public-mailbox    {"mailbox":"pub1"}
