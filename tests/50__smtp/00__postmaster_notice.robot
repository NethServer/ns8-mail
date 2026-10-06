*** Settings ***
Documentation    Postfix notices sent to the bare "postmaster" address follow
...              the postmaster@* address, with the postmaster public
...              mailbox as fallback (NethServer/dev#8186)
Resource    smtp.resource
Test Tags    postmaster    notice

*** Test Cases ***
Notice to bare postmaster reaches the public mailbox
    Send local message to postmaster
    Wait Until Keyword Succeeds    3    1s
    ...    Postmaster notice should be delivered to    vmail+postmaster

Notice follows the postmaster address destination
    [Setup]       Set postmaster destination    user    u1
    [Teardown]    Set postmaster destination    public    postmaster
    Send local message to postmaster
    Wait Until Keyword Succeeds    3    1s
    ...    Postmaster notice should be delivered to    u1

Notice falls back to the public mailbox if the destination is disabled
    [Setup]       Run Keywords
    ...           Set postmaster destination    user    u1
    ...           AND    Set mailbox u1 enabled    false
    [Teardown]    Run Keywords
    ...           Set mailbox u1 enabled    true
    ...           AND    Set postmaster destination    public    postmaster
    Send local message to postmaster
    Wait Until Keyword Succeeds    3    1s
    ...    Postmaster notice should be delivered to    vmail+postmaster

Internal postmaster address is not reachable from outside
    Send SMTP message to    postmaster@mail.domain.test.localhost
    ...                     expect_curl_exitcode=55
    Should return SMTP error    554 5.7.1 <postmaster@mail.domain.test.localhost>: Recipient address rejected: access denied

*** Keywords ***
Set postmaster destination
    [Arguments]    ${dtype}    ${name}
    Run task    module/${MID}/alter-address    {"atype":"wildcard","local":"postmaster","destinations":[{"dtype":"${dtype}","name":"${name}"}]}

Set mailbox ${user} enabled
    [Arguments]    ${enabled}
    Run task    module/${MID}/set-mailbox-enabled    {"user":"${user}","enabled":${enabled}}

Send local message to postmaster
    [Documentation]    Postfix qualifies the bare address with myorigin, like its own notices
    ${LAST_TIMESTAMP} =    Get Current Date
    Set Test Variable    ${LAST_TIMESTAMP}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    runagent -m ${MID} podman exec postfix sh -c 'printf "Subject: notice test\\n\\nprobe\\n" | sendmail postmaster'
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    sendmail failed: ${err}

Postmaster notice should be delivered to
    [Arguments]    ${rcpt}
    ${out} =    Execute Command
    ...    journalctl -o cat -t postfix/lmtp -S '${LAST_TIMESTAMP}'
    Should Match    ${out}    *to\=<${rcpt}@*>, orig_to\=<postmaster>, *status\=sent (250 2.0.0 * Saved)*
    ...    postmaster notice was not delivered to ${rcpt}: ${out}
