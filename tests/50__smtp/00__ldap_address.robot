*** Settings ***
Documentation    Delivery through LDAP mail address to users
Resource    smtp.resource
Suite Setup       Run keywords
...                    Initialize LDAP reference    ldap.dom.test
...                    AND    Set u1 LDAP mail attribute    ldapa1@inbound.test
Suite Teardown    Reset LDAP mail attributes
Test Tags    address  feat-7545

*** Variables ***
${mid_ldap}    openldap0

*** Test Cases ***
LDAP alias against enabled domain flag
    [Documentation]    LDAP mail attribute expands to single user
    Send SMTP message to    ldapa1@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not be delivered via LMTP to  u3

LDAP alias against disabled domain flag
    [Documentation]    LDAP mail attribute ignored if domain flag is disabled
    Should return SMTP unknown user error  ldapa2@noaddflag.test

LDAP alias priority is lower than SQLite address alias
    [Documentation]    An exact-domain SQLite alias wins over an LDAP mail-attribute alias
    ...                for the same address
    [Setup]       Run keywords
    ...                Add aprio alias to u2
    ...                AND    Set u1 LDAP mail attribute  aprio@inbound.test
    [Teardown]    Run keywords
    ...                Set u1 LDAP mail attribute  ldapa1@inbound.test
    ...                AND    Remove aprio alias
    Send SMTP message to    aprio@inbound.test
    Should be delivered via LMTP to  u2
    Should not be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u3

LDAP alias priority is lower than wildcard SQLite alias
    [Documentation]    A wildcard SQLite alias is resolved by the same sqlite:aliases.cf map as an
    ...                exact-domain one, before proxy:ldap:laddaliases.cf is ever queried, so it
    ...                also wins over an LDAP mail-attribute alias for the same address
    [Setup]       Run keywords
    ...                Add awild wildcard alias to u2
    ...                AND    Set u1 LDAP mail attribute  awild@inbound.test
    [Teardown]    Run keywords
    ...                Set u1 LDAP mail attribute    ldapa1@inbound.test
    ...                AND    Remove awild wildcard alias
    Send SMTP message to    awild@inbound.test
    Should be delivered via LMTP to  u2
    Should not be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u3

LDAP alias stops working once mail attribute is cleared
    [Documentation]    A removed mail attribute must not leave a stale alias behind
    [Setup]       Set u1 LDAP mail attribute    ${EMPTY}
    [Teardown]    Set u1 LDAP mail attribute    ldapa1@inbound.test
    Should return SMTP unknown user error    ldapa1@inbound.test

LDAP alias matches mail attribute case-insensitively
    [Documentation]    RFC 5321 domain/local-part lookups against directory data are case-insensitive
    [Setup]       Set u1 LDAP mail attribute    LdapMixed@Inbound.Test
    [Teardown]    Set u1 LDAP mail attribute    ldapa1@inbound.test
    Send SMTP message to    ldapmixed@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not be delivered via LMTP to  u3

LDAP alias ignored when addusers flag is enabled without addaliases
    [Documentation]    The mail attribute alias is gated by its own addaliases flag, independently
    ...                of addusers
    [Setup]       Set u1 LDAP mail attribute    ldapa3@addusers.test
    [Teardown]    Set u1 LDAP mail attribute    ldapa1@inbound.test
    Should return SMTP unknown user error    ldapa3@addusers.test

LDAP alias delivers to every user sharing the same mail attribute
    [Documentation]    All users whose mail attribute matches the address must receive the message
    [Setup]       Run keywords
    ...                Set u1 LDAP mail attribute    ldapshared@inbound.test
    ...                AND    Set u3 LDAP mail attribute    ldapshared@inbound.test
    [Teardown]    Run keywords
    ...                Set u1 LDAP mail attribute    ldapa1@inbound.test
    ...                AND    Set u3 LDAP mail attribute    ${EMPTY}
    Send SMTP message to    ldapshared@inbound.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u3
    Should not be delivered via LMTP to  u2

*** Keywords ***
Add aprio alias to u2
    Run Task    module/${MID}/add-address    {"atype":"domain","local":"aprio","domain":"inbound.test","destinations":[{"dtype":"user","name":"u2"}]}

Remove aprio alias
    Run Task    module/${MID}/remove-address    {"atype":"domain","local":"aprio","domain":"inbound.test"}

Add awild wildcard alias to u2
    Run Task    module/${MID}/add-address    {"atype":"wildcard","local":"awild","destinations":[{"dtype":"user","name":"u2"}]}

Remove awild wildcard alias
    Run Task    module/${MID}/remove-address    {"atype":"wildcard","local":"awild"}

Reset LDAP mail attributes
    Run Keyword    Run Task    module/${mid_ldap}/alter-user    {"user":"u1","mail":"ldapa1@inbound.test"}
    Run Keyword    Run Task    module/${mid_ldap}/alter-user    {"user":"u2","mail":"ldapa2@noaddflag.test"}
