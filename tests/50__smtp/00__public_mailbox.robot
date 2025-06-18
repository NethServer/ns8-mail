*** Settings ***
Documentation    Message is delivered to public mailbox
Resource    smtp.resource
Suite Setup       Create public mailbox
Suite Teardown    Remove public mailbox
Test Tags    delivery    public mailbox

*** Test Cases ***
Public mailbox destination
    Skip    not implemented

*** Keywords ***
Create public mailbox
    Skip    not implemented

Remove public mailbox
    Skip    not implemented

