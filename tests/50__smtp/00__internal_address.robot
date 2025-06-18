*** Settings ***
Documentation    Test doc
Resource    smtp.resource
Suite Setup        Create aliases and domains
Suite Teardown     Remove aliases and domains
Test Tags    address

*** Test Cases ***
No access to internal address from public
    Skip    not implemented

Access to internal address from trusted IP
    Skip    not implemented

Access to internal address with SASL login
    Skip    not implemented

Internal user domain is not accessible
    Skip    not implemented

Internal user domain override is accessible
    [Setup]        Create mail domain for user domain
    [Teardown]     Remove mail domain for user domain
    [Documentation]    If a mail domain with the same name of the user domain exists,
    ...                it is accessible like any other domain
    Skip    not implemented

*** Keywords ***
Create aliases and domains
    Skip    not implemented

Remove aliases and domains
    Skip    not implemented

Create mail domain for user domain
    Skip    not implemented

Remove mail domain for user domain
    Skip    not implemented
