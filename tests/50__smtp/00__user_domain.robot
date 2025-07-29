*** Settings ***
Documentation    If a mail domain has the same name of the user domain,
...              addresses and forwards must work as usual.
...              This scenario is typical with an OpenLDAP user domain because 
...              default Mail settings leads to it.
...              This test suite must cover all combinations of Postfix
...              virtual_alias_maps and smtpd_relay_restrictions, summarizing the
...              tests implemented by other test suites.
Resource    smtp.resource
Suite Setup        Create aliases and domains
Suite Teardown     Remove aliases and domains
Test Tags    address    domain    userdomain    bug-7552    bug-7553

*** Test Cases ***
Everything but defined addresses is internal
    [Tags]     robot:continue-on-failure
    [Setup]    Run task    module/${MID}/alter-domain
    ...        {"domain":"ldap.dom.test","addusers":false,"addgroups":false}
    User name gets access denied
    Group name gets access denied
    Vmail gets access denied
    Addresses are accessible
    Check different forward settings
    Address overrides user name

User is public, group and vmail are internal
    [Tags]     robot:continue-on-failure
    [Setup]    Run task    module/${MID}/alter-domain
    ...        {"domain":"ldap.dom.test","addusers":true,"addgroups":false}
    User name is accessible
    Group name gets access denied
    Vmail gets access denied
    Addresses are accessible
    Check different forward settings
    Address overrides user name

Group is public, user and vmail are internal
    [Tags]     robot:continue-on-failure
    [Setup]    Run task    module/${MID}/alter-domain
    ...        {"domain":"ldap.dom.test","addusers":false,"addgroups":true}
    Group name is accessible
    User name gets access denied
    Vmail gets access denied
    Addresses are accessible
    Check different forward settings
    Address overrides user name

Group and user are public, vmail is internal
    [Tags]     robot:continue-on-failure
    [Setup]    Run task    module/${MID}/alter-domain
    ...        {"domain":"ldap.dom.test","addusers":true,"addgroups":true}
    Group name is accessible
    User name is accessible
    Vmail gets access denied
    Addresses are accessible
    Check different forward settings
    Address overrides user name


*** Keywords ***
Create aliases and domains
    Log To Console    Create mail domain ldap.dom.test
    Run task     module/${MID}/add-domain       {"domain":"ldap.dom.test","addusers":false,"addgroups":false}
    Log To Console    Address i1 -> u1 (internal)
    Run task     module/${MID}/add-address      {"internal":true,"atype":"domain","local":"i1","domain":"ldap.dom.test","destinations":[{"dtype":"user","name":"u1"}]}
    Log To Console    Address a4 -> u3,g1
    Run task     module/${MID}/add-address      {"atype":"domain","local":"a4","domain":"ldap.dom.test","destinations":[{"dtype":"user","name":"u3"},{"dtype":"group","name":"g1"}]}
    Enable wildcard relay rule
    Create public mailbox

Remove aliases and domains
    Run task     module/${MID}/remove-address   {"atype":"domain","local":"i1","domain":"ldap.dom.test"}
    Run task     module/${MID}/remove-address   {"atype":"domain","local":"a4","domain":"ldap.dom.test"}
    Run task     module/${MID}/remove-domain    {"domain":"ldap.dom.test"}
    Cleanup relay rules
    Remove public mailbox

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

###

Address overrides user name
    [Documentation]    Corner case where the user name corresponds to an address.
    ...                The address must have precedence.
    [Setup]        Run task     module/${MID}/add-address
    ...            {"atype":"domain","local":"u1","domain":"ldap.dom.test","destinations":[{"dtype":"user","name":"u1"}]}
    [Teardown]     Run task     module/${MID}/remove-address
    ...            {"atype":"domain","local":"u1","domain":"ldap.dom.test"}
    [Tags]     robot:continue-on-failure
    Address overrides user name, destination is equal to user name
    Address overrides user name, and has priority over user forward
    Address overrides user name, and has priority over group forward
    Address overrides user name, destination is another user
    Address overrides user name, destination is a group
    Address overrides user name, destination is an external address

Address overrides user name, destination is equal to user name
    # [Setup] from parent keyword is enough for this test
    Send SMTP message to    u1@ldap.dom.test    mail_server=127.0.0.1
    Should be delivered via LMTP to  u1

Address overrides user name, and has priority over user forward
    [Setup]            Configure forward for user  u1  to=u2  dtype=user
    [Teardown]         Cleanup forward for u1
    Send SMTP message to    u1@ldap.dom.test    mail_server=127.0.0.1
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2

Address overrides user name, and has priority over group forward
    [Setup]            Configure forward for user  u1  to=g2  dtype=group
    [Teardown]         Cleanup forward for u1
    Send SMTP message to    u1@ldap.dom.test    mail_server=127.0.0.1
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not be delivered via LMTP to  u3

Address overrides user name, destination is another user
    [Setup]        Run task     module/${MID}/alter-address
    ...            {"atype":"domain","local":"u1","domain":"ldap.dom.test","destinations":[{"dtype":"user","name":"u2"}]}
    Send SMTP message to    u1@ldap.dom.test    mail_server=127.0.0.1
    Should be delivered via LMTP to  u2

Address overrides user name, destination is a group
    [Setup]        Run task     module/${MID}/alter-address
    ...            {"atype":"domain","local":"u1","domain":"ldap.dom.test","destinations":[{"dtype":"group","name":"g2"}]}
    Send SMTP message to    u1@ldap.dom.test    mail_server=127.0.0.1
    Should not be delivered via LMTP to    u1
    Should be delivered via LMTP to  u2
    Should be delivered via LMTP to  u3

Address overrides user name, destination is an external address
    [Setup]        Run task     module/${MID}/alter-address
    ...            {"atype":"domain","local":"u1","domain":"ldap.dom.test","destinations":[{"dtype":"external","name":"somebody@wildcard.test"}]}
    Send SMTP message to    u1@ldap.dom.test    mail_server=127.0.0.1
    Should be relayed via SMTP  10001  usr_relay

###

Check different forward settings
    [Tags]    robot:continue-on-failure
    [Teardown]         Cleanup forward for u3
    Forward to user
    Forward to user with copy
    Forward to group
    Forward to external address

Forward to user
    [Setup]            Configure forward for user  u3  to=u1  dtype=user
    Send SMTP message to    u3@ldap.dom.test    mail_server=127.0.0.1
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u3

Forward to user with copy
    [Setup]            Configure forward for user  u3  to=u1  dtype=user  keepcopy=true
    Send SMTP message to    u3@ldap.dom.test    mail_server=127.0.0.1
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u3

Forward to group
    [Setup]            Configure forward for user  u3  to=g1  dtype=group
    Send SMTP message to    u3@ldap.dom.test    mail_server=127.0.0.1
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2
    Should not be delivered via LMTP to  u3

Forward to external address
    [Setup]            Configure forward for user  u3  to=forward@wildcard.test  dtype=external
    Send SMTP message to    u3@ldap.dom.test    mail_server=127.0.0.1
    Should be relayed via SMTP  10001  usr_relay
    Should not be delivered via LMTP to  u3

###

Addresses are accessible
    [Tags]    robot:continue-on-failure
    Public mailbox address is accessible
    User alias address is accessible
    Internal address gets access denied
    Internal domain user address gets access denied
    Mixed-destinations address with exact domain is accessible

User name is accessible
    Send SMTP message to    u1@ldap.dom.test
    Should be delivered via LMTP to  u1

Group name is accessible
    Send SMTP message to    g1@ldap.dom.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2

Mixed-destinations address with exact domain is accessible
    Send SMTP message to    a4@ldap.dom.test
    Should be delivered via LMTP to  u3
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2

Group name gets access denied
    Send SMTP message to    g1@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <g1@ldap.dom.test>: Recipient address rejected: access denied

User name gets access denied
    Send SMTP message to    u1@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <u1@ldap.dom.test>: Recipient address rejected: access denied

Vmail gets access denied
    Send SMTP message to    vmail@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <vmail@ldap.dom.test>: Recipient address rejected: access denied

Public mailbox address is accessible
    Send SMTP message to    pub1@ldap.dom.test
    Should be delivered via LMTP to  vmail+pub1

User alias address is accessible
    Send SMTP message to    a2@ldap.dom.test
    Should be delivered via LMTP to  u1

Internal address gets access denied
    [Tags]    robot:continue-on-failure
    [Documentation]    An address with internal flag is accessible only by trusted clients

    Send SMTP message to    i1@ldap.dom.test  expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <i1@ldap.dom.test>: Recipient address rejected: access denied

    Send SMTP message to    i1@ldap.dom.test  mail_server=127.0.0.1
    Should be delivered via LMTP to  u1

    Send SMTP message to    i1@ldap.dom.test  credentials=u3:Nethesis,1234
    Should be delivered via LMTP to  u1

Internal domain user address gets access denied
    [Setup]        Run task     module/${MID}/alter-address
    ...            {"atype":"adduser","local":"u2","internal":true}
    [Teardown]     Run task     module/${MID}/alter-address
    ...            {"atype":"adduser","local":"u2","internal":false}
    Send SMTP message to    u2@ldap.dom.test  expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <u2@ldap.dom.test>: Recipient address rejected: access denied
