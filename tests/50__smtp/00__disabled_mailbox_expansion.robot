*** Settings ***
Documentation    When an address expands to several mailboxes, the copy for a
...              disabled mailbox is dropped and no bounce goes back to the
...              sender (NethServer/dev#8205)
Resource    smtp.resource
Suite Setup       Run keywords
...                    Set mailbox u2 enabled    false
...                    AND    Set mailbox MixedCaseUser enabled    false
...                    AND    Create aliases with a disabled destination
Suite Teardown    Run keywords
...                    Remove aliases with a disabled destination
...                    AND    Set mailbox MixedCaseUser enabled    true
...                    AND    Set mailbox u2 enabled    true
...                    AND    Delete leftover bounces
Test Tags    disabled    mailbox    group

*** Test Cases ***
Group with a disabled member
    Send SMTP message to    g1@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  u2
    Should not send bounce

Alias with a disabled destination
    Send SMTP message to    d3@inbound.test
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

Disabled destination with a mixed case name
    Send SMTP message to    d4@inbound.test
    Should be delivered via LMTP to  u1
    Should not be delivered via LMTP to  MixedCaseUser
    Should not send bounce

Group whose members are all disabled is rejected
    [Setup]       Set mailbox u3 enabled    false
    [Teardown]    Set mailbox u3 enabled    true
    Send SMTP message to  g2@inbound.test
    ...                   expect_curl_exitcode=
    Should return SMTP error    550 5.1.1 <g2@inbound.test>: Recipient address rejected

*** Keywords ***
Create aliases with a disabled destination
    Run task    module/${MID}/add-address    {"atype":"domain","local":"d3","domain":"inbound.test","destinations":[{"dtype":"user","name":"u1"},{"dtype":"user","name":"u2"}]}
    Run task    module/${MID}/add-address    {"atype":"domain","local":"d4","domain":"inbound.test","destinations":[{"dtype":"user","name":"u1"},{"dtype":"user","name":"MixedCaseUser"}]}

Remove aliases with a disabled destination
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"d3","domain":"inbound.test"}
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"d4","domain":"inbound.test"}

Delete leftover bounces
    [Documentation]    Bounces to the test sender cannot be delivered and would stay in the queue
    Execute Command    runagent -m ${MID} podman exec postfix postsuper -d ALL deferred
