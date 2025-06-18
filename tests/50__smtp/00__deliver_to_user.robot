*** Settings ***
Documentation    Message is delivered to LDAP users with both AD and OpenLDAP user databases
Resource    smtp.resource
Test Template    Inbound Delivery Should Work
Test Tags    delivery    user

*** Test Cases ***
With AD        ad.dom.test
With OpenLDAP  ldap.dom.test

*** Keywords ***
Inbound Delivery Should Work
    [Documentation]    LDAP groups are correctly expanded and user delivery works
    [Arguments]    ${udom}
    Switch user domain    ${udom}
    Send SMTP message to  u1@inbound.test
    Should be delivered via LMTP to  u1
    Send SMTP message to  g1@inbound.test
    Should be delivered via LMTP to  u1
    Should be delivered via LMTP to  u2

Switch user domain
    [Arguments]     ${udom}
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"${udom}"}
