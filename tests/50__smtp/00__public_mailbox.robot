*** Settings ***
Documentation    Message is delivered to public mailbox
Resource    smtp.resource
Suite Setup       Create public mailboxes
Suite Teardown    Remove public mailboxes
Test Tags    delivery    public mailbox

*** Variables ***
${spaced_name}    pub 2, x

*** Test Cases ***
Public mailbox destination
    Send SMTP message to    pub1@inbound.test
    Should be delivered via LMTP to  vmail+pub1

Address of public mailbox with spaces and comma
    Send SMTP message to    pub2@inbound.test
    Should be delivered via LMTP to  "vmail+${spaced_name}"

Quoted public mailbox name address
    Send SMTP message to    '"${spaced_name}"@inbound.test'
    Should be delivered via LMTP to  "vmail+${spaced_name}"

User forward to public mailbox with spaces
    [Setup]    Run task    module/${MID}/alter-user-mailbox    {"user":"u3","forward":{"destinations":[{"dtype":"public","name":"${spaced_name}"}]}}
    [Teardown]    Run task    module/${MID}/alter-user-mailbox    {"user":"u3","forward":{"destinations":[]}}
    Send SMTP message to    u3@inbound.test
    Should be delivered via LMTP to  "vmail+${spaced_name}"
    Should not be delivered via LMTP to  u3

Catchall to public mailbox with spaces
    [Setup]    Run task    module/${MID}/alter-domain    {"domain":"inbound.test","catchall":{"dtype":"public","name":"${spaced_name}"}}
    [Teardown]    Run task    module/${MID}/alter-domain    {"domain":"inbound.test","catchall":null}
    Send SMTP message to    unknown@inbound.test
    Should be delivered via LMTP to  "vmail+${spaced_name}"

*** Keywords ***
Create public mailboxes
    Run task    module/${MID}/add-public-mailbox    {"mailbox":"pub1","acls":[]}
    Run task    module/${MID}/add-public-mailbox    {"mailbox":"${spaced_name}","acls":[]}
    Run task    module/${MID}/add-address    {"atype":"domain","local":"pub2","domain":"inbound.test","destinations":[{"dtype":"public","name":"${spaced_name}"}]}

Remove public mailboxes
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"pub2","domain":"inbound.test"}
    Run task    module/${MID}/remove-public-mailbox    {"mailbox":"${spaced_name}"}
    Run task    module/${MID}/remove-public-mailbox    {"mailbox":"pub1"}
