*** Settings ***
Documentation    A disabled mailbox gets no mail. Its user and LDAP mail addresses
...              are unknown, like any address that is not assigned: they are
...              rejected during the SMTP session, or go to the catch-all
...              (NethServer/dev#8185). Copies that come through aliases, groups
...              and the catch-all are dropped without a bounce, and its forward
...              does not apply (NethServer/dev#8205)
Resource    smtp.resource
Suite Setup       Run keywords
...                    Initialize LDAP reference    ldap.dom.test
...                    AND    Set mailbox u2 enabled    false
...                    AND    Set mailbox MixedCaseUser enabled    false
...                    AND    Set u2 LDAP mail attribute    ldapd2@inbound.test
...                    AND    Create aliases with a disabled destination
Suite Teardown    Run keywords
...                    Remove aliases with a disabled destination
...                    AND    Set u2 LDAP mail attribute    ldapa2@noaddflag.test
...                    AND    Set mailbox MixedCaseUser enabled    true
...                    AND    Set mailbox u2 enabled    true
...                    AND    Delete leftover bounces
Test Tags    disabled    mailbox

*** Test Cases ***
Disabled mailbox address is rejected with AD
    [Setup]       Switch user domain    ad.dom.test
    [Teardown]    Switch user domain    ldap.dom.test
    Should return SMTP unknown user error    u2@inbound.test

Disabled mailbox address is rejected with OpenLDAP
    Should return SMTP unknown user error    u2@inbound.test

Disabled mailbox address with an extension is rejected
    Should return SMTP unknown user error    u2+tag@inbound.test

Disabled mailbox address in another case is rejected
    Should return SMTP unknown user error    U2@Inbound.Test

Hidden AD accounts are rejected
    [Setup]       Switch user domain    ad.dom.test
    [Teardown]    Switch user domain    ldap.dom.test
    Should return SMTP unknown user error    krbtgt@inbound.test
    Should return SMTP unknown user error    ldapservice@inbound.test

Disabled mailbox in a domain without user addresses
    Should return SMTP unknown user error    u2@noaddflag.test

LDAP mail address of a disabled mailbox is rejected
    Should return SMTP unknown user error    ldapd2@inbound.test

Authenticated sender gets an immediate rejection
    [Documentation]    A local user writing to a disabled mailbox gets the error
    ...                during the session, not a bounce later
    Send SMTP message to  u2@inbound.test
    ...                   from=u1@inbound.test
    ...                   credentials=u1:Nethesis,1234
    ...                   expect_curl_exitcode=
    Should return SMTP error    550 5.1.1 <u2@inbound.test>: Recipient address rejected

Enabled mailbox address is accepted
    Send SMTP message to    u1@inbound.test
    Should be delivered via LMTP to  u1

Forward of a disabled mailbox does not apply
    [Documentation]    Neither to its address, nor to copies that come through a group
    [Setup]       Run task    module/${MID}/alter-user-mailbox    {"user":"u2","forward":{"keepcopy":false,"destinations":[{"dtype":"user","name":"u3"}]}}
    [Teardown]    Run task    module/${MID}/alter-user-mailbox    {"user":"u2","forward":{"destinations":[]}}
    Should return SMTP unknown user error    u2@inbound.test
    Send SMTP message to    g1@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u3
    Should not be delivered via LMTP to  u2
    Should not send bounce

Alias with a disabled destination
    Send SMTP message to    d3@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not send bounce

Disabled destination with a mixed case name
    Send SMTP message to    d4@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  MixedCaseUser
    Should not send bounce

Group with a disabled member
    Send SMTP message to    g1@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not send bounce

Group with a disabled member with AD
    [Documentation]    AD resolves group members by DN, OpenLDAP by user name
    [Setup]       Switch user domain    ad.dom.test
    [Teardown]    Switch user domain    ldap.dom.test
    Send SMTP message to    g1@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not send bounce

Alias with a group that has a disabled member
    [Documentation]    a2@* goes to u1 and g2, g2 has members u2 and u3
    Send SMTP message to    a2@inbound.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u3
    Should not be delivered via LMTP to  u2
    Should not send bounce

Forward to a group with a disabled member
    [Setup]       Run task    module/${MID}/alter-user-mailbox    {"user":"u3","forward":{"keepcopy":false,"destinations":[{"dtype":"group","name":"g1"}]}}
    [Teardown]    Run task    module/${MID}/alter-user-mailbox    {"user":"u3","forward":{"destinations":[]}}
    Send SMTP message to    u3@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not send bounce

Forward with copy to a disabled mailbox
    [Setup]       Run task    module/${MID}/alter-user-mailbox    {"user":"u3","forward":{"keepcopy":true,"destinations":[{"dtype":"user","name":"u2"}]}}
    [Teardown]    Run task    module/${MID}/alter-user-mailbox    {"user":"u3","forward":{"destinations":[]}}
    Send SMTP message to    u3@inbound.test
    Should be delivered via LMTP to  u3
    Should not be delivered via LMTP to  u2
    Should not send bounce

Shared LDAP mail with a disabled mailbox
    [Documentation]    The user with an enabled mailbox still receives the message
    [Setup]       Run keywords
    ...                Set u1 LDAP mail attribute    ldapshared2@inbound.test
    ...                AND    Set u2 LDAP mail attribute    ldapshared2@inbound.test
    [Teardown]    Run keywords
    ...                Set u1 LDAP mail attribute    ldapa1@inbound.test
    ...                AND    Set u2 LDAP mail attribute    ldapd2@inbound.test
    Send SMTP message to    ldapshared2@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not send bounce

Catch-all gets the disabled mailbox address
    [Documentation]    The address is unknown, like any other that is not assigned
    [Setup]       Set inbound.test catchall to    u1
    [Teardown]    Reset inbound.test catchall
    Send SMTP message to    u2@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2

Address that leads only to disabled mailboxes is dropped silently
    [Documentation]    Known limit: Postfix cannot tell at RCPT time that every
    ...                destination is disabled, so the message is accepted and dropped
    [Template]    Should be dropped silently
    d1@inbound.test
    d5@inbound.test

Group whose members are all disabled is dropped silently
    [Setup]       Set mailbox u3 enabled    false
    [Teardown]    Set mailbox u3 enabled    true
    Send SMTP message to    g2@inbound.test
    Should not be delivered via LMTP to  u2
    Should not be delivered via LMTP to  u3
    Should not send bounce

Catch-all to a disabled mailbox is dropped silently
    [Setup]       Set inbound.test catchall to    u2
    [Teardown]    Reset inbound.test catchall
    Should be dropped silently    nobody8185@inbound.test

Alias named like a disabled mailbox is delivered
    [Documentation]    SQL aliases are not filtered and win as on enabled mailboxes
    [Setup]       Add u2 alias to u1    inbound.test
    [Teardown]    Remove u2 alias    inbound.test
    Send SMTP message to    u2@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2

Wildcard alias named like a disabled mailbox is delivered
    [Setup]       Add u2 alias to u1    *
    [Teardown]    Remove u2 alias    *
    Send SMTP message to    u2@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2

Public mailbox named like a disabled mailbox is delivered
    [Setup]       Run task    module/${MID}/add-public-mailbox    {"mailbox":"u2","acls":[]}
    [Teardown]    Run task    module/${MID}/remove-public-mailbox    {"mailbox":"u2"}
    Send SMTP message to    u2@inbound.test
    Should be delivered via LMTP to  vmail+u2

Mailbox enabled again is accepted
    [Documentation]    Postfix is reloaded when the mailbox state changes
    [Setup]       Set mailbox u2 enabled    true
    [Teardown]    Set mailbox u2 enabled    false
    Send SMTP message to    u2@inbound.test
    Should be delivered via LMTP to  u2

*** Keywords ***
Add u2 alias to u1
    [Arguments]    ${domain}
    IF    '${domain}' == '*'
        Run task    module/${MID}/add-address    {"atype":"wildcard","local":"u2","destinations":[{"dtype":"user","name":"u1"}]}
    ELSE
        Run task    module/${MID}/add-address    {"atype":"domain","local":"u2","domain":"${domain}","destinations":[{"dtype":"user","name":"u1"}]}
    END

Remove u2 alias
    [Arguments]    ${domain}
    IF    '${domain}' == '*'
        Run task    module/${MID}/remove-address    {"atype":"wildcard","local":"u2"}
    ELSE
        Run task    module/${MID}/remove-address    {"atype":"domain","local":"u2","domain":"${domain}"}
    END

Create aliases with a disabled destination
    Run task    module/${MID}/add-address    {"atype":"domain","local":"d1","domain":"inbound.test","destinations":[{"dtype":"user","name":"u2"}]}
    Run task    module/${MID}/add-address    {"atype":"wildcard","local":"d5","destinations":[{"dtype":"user","name":"u2"}]}
    Run task    module/${MID}/add-address    {"atype":"domain","local":"d3","domain":"inbound.test","destinations":[{"dtype":"user","name":"u1"},{"dtype":"user","name":"u2"}]}
    Run task    module/${MID}/add-address    {"atype":"domain","local":"d4","domain":"inbound.test","destinations":[{"dtype":"user","name":"u1"},{"dtype":"user","name":"MixedCaseUser"}]}

Remove aliases with a disabled destination
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"d1","domain":"inbound.test"}
    Run task    module/${MID}/remove-address    {"atype":"wildcard","local":"d5"}
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"d3","domain":"inbound.test"}
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"d4","domain":"inbound.test"}

Set inbound.test catchall to
    [Arguments]    ${user}
    Run task     module/${MID}/alter-domain
    ...            {"domain":"inbound.test","catchall":{"dtype":"user","name":"${user}"}}

Reset inbound.test catchall
    Run task     module/${MID}/alter-domain
    ...            {"domain":"inbound.test","catchall":null}

Should be dropped silently
    [Arguments]    ${address}
    Send SMTP message to    ${address}
    Should not be delivered via LMTP to  u2
    Should not send bounce

Delete leftover bounces
    [Documentation]    Bounces to the test sender cannot be delivered and would stay in the queue
    Execute Command    runagent -m ${MID} podman exec postfix postsuper -d ALL deferred
