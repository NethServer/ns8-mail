*** Settings ***
Documentation    An address that leads only to disabled mailboxes is rejected
...              during the SMTP session, so no bounce goes back to a possibly
...              forged sender (NethServer/dev#8185)
Resource    smtp.resource
Suite Setup       Run keywords
...                    Initialize LDAP reference    ldap.dom.test
...                    AND    Set mailbox u2 enabled    false
...                    AND    Set u2 LDAP mail attribute    ldapd2@inbound.test
...                    AND    Create aliases to u2
Suite Teardown    Run keywords
...                    Remove aliases to u2
...                    AND    Set u2 LDAP mail attribute    ldapa2@noaddflag.test
...                    AND    Set mailbox u2 enabled    true
Test Tags    disabled    mailbox    address

*** Test Cases ***
Disabled mailbox address is rejected with AD
    [Setup]       Switch user domain    ad.dom.test
    [Teardown]    Switch user domain    ldap.dom.test
    Should return SMTP unknown user error    u2@inbound.test

Disabled mailbox address is rejected with OpenLDAP
    Should return SMTP unknown user error    u2@inbound.test

Hidden AD accounts are rejected
    [Setup]       Switch user domain    ad.dom.test
    [Teardown]    Switch user domain    ldap.dom.test
    Should return SMTP unknown user error    krbtgt@inbound.test
    Should return SMTP unknown user error    ldapservice@inbound.test

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

Disabled mailbox address in another case is rejected
    Should return SMTP unknown user error    U2@Inbound.Test

LDAP alias of a disabled mailbox is rejected
    Should return SMTP unknown user error    ldapd2@inbound.test

Alias to a disabled mailbox is rejected
    Should return SMTP recipient rejected error    d1@inbound.test

Wildcard alias to a disabled mailbox is rejected
    Should return SMTP recipient rejected error    d5@inbound.test

Catch-all to a disabled mailbox is rejected
    [Setup]       Set inbound.test catchall to u2
    [Teardown]    Reset inbound.test catchall
    Should return SMTP recipient rejected error    nobody8185@inbound.test

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

Forward of a disabled mailbox still works
    [Setup]       Configure u2 forward to u1    keepcopy=false
    [Teardown]    Cleanup u2 forward
    Send SMTP message to    u2@inbound.test
    Should be delivered via LMTP to  u1
    Should not send bounce

Forward with copy of a disabled mailbox drops the copy
    [Setup]       Configure u2 forward to u1    keepcopy=true
    [Teardown]    Cleanup u2 forward
    Send SMTP message to    u2@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not send bounce

Mailbox enabled again is accepted
    [Documentation]    Postfix is reloaded when the mailbox state changes
    [Setup]       Set mailbox u2 enabled    true
    [Teardown]    Set mailbox u2 enabled    false
    Send SMTP message to    u2@inbound.test
    Should be delivered via LMTP to  u2

*** Keywords ***
Switch user domain
    [Arguments]     ${udom}
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"${udom}"}

Create aliases to u2
    Run task    module/${MID}/add-address    {"atype":"domain","local":"d1","domain":"inbound.test","destinations":[{"dtype":"user","name":"u2"}]}
    Run task    module/${MID}/add-address    {"atype":"wildcard","local":"d5","destinations":[{"dtype":"user","name":"u2"}]}

Remove aliases to u2
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"d1","domain":"inbound.test"}
    Run task    module/${MID}/remove-address    {"atype":"wildcard","local":"d5"}

Set inbound.test catchall to u2
    Run task     module/${MID}/alter-domain
    ...            {"domain":"inbound.test","catchall":{"dtype":"user","name":"u2"}}

Reset inbound.test catchall
    Run task     module/${MID}/alter-domain
    ...            {"domain":"inbound.test","catchall":null}

Configure u2 forward to u1
    [Arguments]    ${keepcopy}
    Run task    module/${MID}/alter-user-mailbox    {"user":"u2","forward":{"keepcopy":${keepcopy},"destinations":[{"dtype":"user","name":"u1"}]}}

Cleanup u2 forward
    Run task    module/${MID}/alter-user-mailbox    {"user":"u2","forward":{"destinations":[]}}

Should return SMTP recipient rejected error
    [Documentation]    The exact reason text depends on the Postfix table that rejects the address
    [Arguments]    ${address}
    Send SMTP message to  ${address}
    ...                   expect_curl_exitcode=
    Should return SMTP error    550 5.1.1 <${address}>: Recipient address rejected
