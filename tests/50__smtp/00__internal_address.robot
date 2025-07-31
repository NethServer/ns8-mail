*** Settings ***
Documentation    An address with "internal" flag is accessible only from trusted clients
Resource    smtp.resource
Suite Setup        Create aliases and domains
Suite Teardown     Remove aliases and domains
Test Tags    internal    address    domain

*** Test Cases ***
User domain wildcard address is internal
    Send SMTP message to    i2@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <i2@ldap.dom.test>: Relay access denied

User domain user is internal
    Send SMTP message to    u1@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <u1@ldap.dom.test>: Relay access denied

User domain group is internal
    Send SMTP message to    g1@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <g1@ldap.dom.test>: Relay access denied

Vmail is internal
    Send SMTP message to    vmail@ldap.dom.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <vmail@ldap.dom.test>: Relay access denied

User alias internal address
    Send SMTP message to    i1@internal.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <i1@internal.test>: Recipient address rejected: access denied

Group alias internal address
    Send SMTP message to    i2@internal.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <i2@internal.test>: Recipient address rejected: access denied

User name internal address
    Send SMTP message to    u1@internal.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <u1@internal.test>: Recipient address rejected: access denied

Group name internal address
    Send SMTP message to    g1@internal.test
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <g1@internal.test>: Recipient address rejected: access denied

Accessible from trusted IP
    Send SMTP message to    i1@internal.test
    ...    mail_server=127.0.0.1
    Should be delivered via LMTP to  u1

Accessible with SASL login
    Send SMTP message to    i1@internal.test
    ...    credentials=u1:Nethesis,1234
    Should be delivered via LMTP to  u1

*** Keywords ***
Create aliases and domains
    Run task    module/${MID}/add-domain     {"domain":"internal.test","addusers":true,"addgroups":true}
    Run task    module/${MID}/alter-address  {"internal":true,"atype":"adduser","local":"u1"}
    Run task    module/${MID}/alter-address  {"internal":true,"atype":"addgroup","local":"g1"}
    Run task    module/${MID}/add-address    {"internal":true,"atype":"domain","local":"i1","domain":"internal.test","destinations":[{"dtype":"user","name":"u1"}]}
    Run task    module/${MID}/add-address    {"internal":true,"atype":"wildcard","local":"i2","destinations":[{"dtype":"group","name":"g1"}]}

Remove aliases and domains
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"i1","domain":"internal.test"}
    Run task    module/${MID}/remove-address    {"atype":"wildcard","local":"i2"}
    Run task    module/${MID}/alter-address     {"internal":false,"atype":"adduser","local":"u1"}
    Run task    module/${MID}/alter-address     {"internal":false,"atype":"addgroup","local":"g1"}
    Run task    module/${MID}/remove-domain     {"domain":"internal.test"}
