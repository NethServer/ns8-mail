*** Settings ***
Documentation    Only trusted clients are allowed to send outbound messages
Resource    smtp.resource
Suite Setup        Enable wildcard relay rule
Suite Teardown     Cleanup relay rules
Test Tags    relay    policy

*** Test Cases ***
Relay denied with public IP
    Send SMTP message to  somebody@wildcard.test
    ...                   from=u1@addusers.test
    ...                   expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <somebody@wildcard.test>: Relay access denied

Relay allowed with trusted IP
    Send SMTP message to  somebody@wildcard.test
    ...                   from=u1@addusers.test
    ...                   mail_server=127.0.0.1
    Should be relayed via SMTP

Relay allowed with SASL login
    Send SMTP message to  somebody@wildcard.test
    ...                   from=someaddress@wildcard.test
    ...                   credentials=u3:Nethesis,1234
    Should be relayed via SMTP

Relay denied with wrong SASL credentials
    Send SMTP message to  somebody@wildcard.test
    ...                   from=someaddress@wildcard.test
    ...                   credentials=u1:BadPassword
    ...                   expect_curl_exitcode=67
    Should return SMTP error    535 5.7.8 Error: authentication failed

*** Keywords ***
Enable wildcard relay rule
    Add relay rule    wildcard    *    127.0.0.1    10001    ${EMPTY}
