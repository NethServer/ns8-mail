*** Settings ***
Documentation    Test SMTP port 25 (MTA)
Resource    senddeliver.resource
Suite Setup        Switch user domain    ldap.dom.test

*** Test Cases ***
Send messages as a MTA to AD domain mailboxes
    [Template]    Send message as MTA and check delivery
    dude@example.org    u1@mta-users.test    ${U1CREDS}    delivered
    dude@example.org    u3@mta-users.test    ${U1CREDS}    delivered
    dude@example.org    g1@mta-users.test    ${U1CREDS}    not delivered
    dude@example.org    g2@mta-users.test    ${U1CREDS}    not delivered
    dude@example.org    g1@mta-groups.test   ${U1CREDS}    delivered
    dude@example.org    g1@mta-groups.test   ${U3CREDS}    not delivered
    dude@example.org    g2@mta-groups.test   ${U1CREDS}    not delivered
    dude@example.org    g2@mta-groups.test   ${U3CREDS}    delivered
    dude@example.org    u1@mta-ug.test       ${U1CREDS}    delivered
    dude@example.org    u3@mta-ug.test       ${U1CREDS}    delivered
    dude@example.org    g1@mta-ug.test       ${U1CREDS}    delivered
    dude@example.org    g2@mta-ug.test       ${U1CREDS}    not delivered
    dude@example.org    g1@mta-ug.test       ${U1CREDS}    delivered
    dude@example.org    g1@mta-ug.test       ${U3CREDS}    delivered
    dude@example.org    g2@mta-ug.test       ${U1CREDS}    not delivered
    dude@example.org    g2@mta-ug.test       ${U3CREDS}    delivered
