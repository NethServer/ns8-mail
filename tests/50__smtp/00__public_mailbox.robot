*** Settings ***
Documentation    Message is delivered to public mailbox
Resource    smtp.resource
Suite Setup       Create public mailbox
Suite Teardown    Remove public mailbox
Test Tags    delivery    public mailbox

*** Test Cases ***
Public mailbox destination
    Send SMTP message to    pub1@inbound.test
    Should be delivered via LMTP to  vmail+pub1

*** Keywords ***
Create public mailbox
    Run task    module/${MID}/add-public-mailbox    {"mailbox":"pub1","acls":[]}

Remove public mailbox
    Run task    module/${MID}/remove-public-mailbox    {"mailbox":"pub1"}
