*** Settings ***
Resource    api.resource
Resource    user_domain.resource
Resource    keywords.resource

*** Test Cases ***
TCP ports are open
    [Template]    Retry until TCP port is open
    25
    587
    465

Login TLS policy
    [Template]    Retry test
    SMTP STARTTLS offered on port 25
    SMTP AUTH local login
    SMTP AUTH submissions login

*** Keywords ***
SMTP STARTTLS offered on port 25
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 5 curl -v --mail-rcpt postmaster@domain.test smtp://127.0.0.1:25
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0
    Should Contain    ${err}    ESMTP Postfix
    Should Contain    ${err}    250-STARTTLS
    Should Not Contain    ${err}    250-AUTH PLAIN LOGIN
    Should Contain    ${out}    252 2.0.0 postmaster@domain.test
