*** Settings ***
Documentation    Message for user with forward address is sent
Resource    smtp.resource
Test Tags    userforward    outbound

*** Test Cases ***
Forward to user
    [Setup]            Configure forward for user u3 to user u1
    [Teardown]         Cleanup forward for u3
    Skip    not implemented

Forward to user with copy
    [Setup]            Configure forward for user u3 to user u1
    [Teardown]         Cleanup forward for u3
    Skip    not implemented

Forward to group
    [Setup]            Configure forward for user u3 to group g1
    [Teardown]         Cleanup forward for u3
    Skip    not implemented

Forward to external address
    [Setup]            Configure forward for user u3 to address external@wildcard.test
    [Teardown]         Cleanup forward for u3
    Skip    not implemented

*** Keywords ***
Configure forward for user ${user} to user ${dest}
    Skip    not implemented

Configure forward for user ${user} to group ${dest}
    Skip    not implemented

Configure forward for user ${user} to address ${dest}
    Skip    not implemented

Cleanup forward for ${user}
    Skip    not implemented
