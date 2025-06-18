*** Settings ***
Documentation    A message copy for any domain recipient is sent to the given address
Resource    smtp.resource
Suite Setup        No Operation
Suite Teardown     Reset domain bccaddr
Test Tags    relay    policy

*** Test Cases ***
Bcc sent without local copy
    [Setup]    Set domain bccaddr
    Skip    not implemented

Bcc sent with local copy
    [Setup]    Set domain bccaddr
    Skip    not implemented

Bcc not sent
    [Setup]    Set domain bccaddr
    Skip    not implemented

*** Keywords ***
Set domain bccaddr
    Skip    not implemented

Reset domain bccaddr
    Skip    not implemented
