*** Settings ***
Documentation    Postfix notices sent to the bare "postmaster" address reach
...              the postmaster public mailbox (NethServer/dev#8186)
Resource    smtp.resource
Test Tags    postmaster    notice

*** Test Cases ***
Notice to bare postmaster reaches the public mailbox
    Send local message to postmaster
    Wait Until Keyword Succeeds    3    1s
    ...    Postmaster notice should be delivered

Internal postmaster address is not reachable from outside
    Send SMTP message to    postmaster@mail.domain.test.localhost
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <postmaster@mail.domain.test.localhost>: Recipient address rejected: access denied

*** Keywords ***
Send local message to postmaster
    [Documentation]    Postfix qualifies the bare address with myorigin, like its own notices
    ${LAST_TIMESTAMP} =    Get Current Date
    Set Test Variable    ${LAST_TIMESTAMP}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    runagent -m ${MID} podman exec postfix sh -c 'printf "Subject: notice test\\n\\nprobe\\n" | sendmail postmaster'
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    sendmail failed: ${err}

Postmaster notice should be delivered
    ${out} =    Execute Command
    ...    journalctl -o cat -t postfix/lmtp -S '${LAST_TIMESTAMP}'
    Should Match    ${out}    *to\=<vmail+postmaster@*>, orig_to\=<postmaster>, *status\=sent (250 2.0.0 * Saved)*
    ...    postmaster notice was not delivered to the postmaster public mailbox: ${out}
