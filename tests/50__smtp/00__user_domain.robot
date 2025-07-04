*** Settings ***
Documentation    If a mail domain with the same name of the user domain exists,
    ...          it is accessible like any other domain
Resource    smtp.resource
Suite Setup        Create aliases and domains
Suite Teardown     Remove aliases and domains
Test Tags    address    domain

*** Test Cases ***
User alias address
    Send SMTP message to    a2@ldap.dom.test
    Should be delivered via LMTP to  u1

Internal address
    Send SMTP message to    i1@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <i1@ldap.dom.test>: Recipient address rejected: access denied

Group address is available
    [Documentation]    The domain does not honor addgroups:false and group names are valid addresses.
    [Tags]    known-bug
    Send SMTP message to    g1@ldap.dom.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2

Group alias address is expanded
    Send SMTP message to    a4@ldap.dom.test
    Should be delivered via LMTP to  u3
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2

Vmail is not accessible
    Send SMTP message to    vmail+xxx@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <vmail+xxx@ldap.dom.test>: Recipient address rejected: access denied

*** Keywords ***
Create aliases and domains
    Run task     module/${MID}/add-domain       {"domain":"ldap.dom.test","addusers":true,"addgroups":false}
    Run task     module/${MID}/add-address      {"internal":true,"atype":"domain","local":"i1","domain":"ldap.dom.test","destinations":[{"dtype":"user","name":"u1"}]}
    Run task     module/${MID}/add-address      {"atype":"domain","local":"a4","domain":"ldap.dom.test","destinations":[{"dtype":"user","name":"u3"},{"dtype":"group","name":"g1"}]}

Remove aliases and domains
    Run task     module/${MID}/remove-address   {"atype":"domain","local":"i1","domain":"ldap.dom.test"}
    Run task     module/${MID}/remove-address   {"atype":"domain","local":"a4","domain":"ldap.dom.test"}
    Run task     module/${MID}/remove-domain    {"domain":"ldap.dom.test"}
