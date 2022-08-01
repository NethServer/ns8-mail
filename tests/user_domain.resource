*** Settings ***
Resource    api.resource
Library     SSHLibrary

*** Keywords ***
IMAP login good credentials
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 2 curl -v -f -u u1:Nethesis,1234 imap://127.0.0.1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0
    Should Contain    ${err}    QUOTA
    Should Contain    ${err}    STARTTLS
    Should Contain    ${out}    * LIST (\\HasNoChildren) "/" INBOX

IMAP login bad credentials
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 9 curl -v -f -u u1:badpass imap://127.0.0.1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  67
    Should Contain    ${err}    AUTHENTICATIONFAILED

TLS required on non-secure IMAP connections
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 2 curl -v -f -u u1:Nethesis,1234 imap://127.0.0.2
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  67
    Should Contain    ${err}    No known authentication mechanisms supported!

IMAPs endpoint login
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 2 curl -k -v -f -u u1:Nethesis,1234 imaps://127.0.0.2
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0
    Should Contain    ${out}    * LIST (\\HasNoChildren) "/" INBOX

SMTP AUTH local login
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 5 curl -v --mail-rcpt postmaster@domain.test smtp://127.0.0.1:587
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0
    Should Contain    ${err}    ESMTP Postfix
    Should Contain    ${err}    250-STARTTLS
    Should Not Contain    ${err}    250-AUTH PLAIN LOGIN

SMTP AUTH submissions login
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 5 curl -k -v -u u1:Nethesis,1234 --mail-rcpt postmaster@domain.test smtps://127.0.0.1:465
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0
    Should Contain    ${err}    ESMTP Postfix
    Should Contain    ${err}    subject: CN=nethserver.test
    Should Not Contain    ${err}    250-STARTTLS
    Should Contain    ${err}    235 2.7.0 Authentication successful
    Should Contain    ${out}    252 2.0.0 postmaster@domain.test
