*** Settings ***
Documentation    Test SMTP port 25 (MTA)
Resource    senddeliver.resource
Suite Setup        Switch user domain    ldap.dom.test
Test Tags    ldap    mta

*** Test Cases ***
Message to domain with add users flag is delivered
    [Template]    Send message as MTA and check delivery
    dude@senderdomain.test    u1@mta-users.test    INBOX    ${U1CREDS}    delivered    ${U3CREDS}    not delivered
    dude@senderdomain.test    u3@mta-users.test    INBOX    ${U3CREDS}    delivered    ${U1CREDS}    not delivered

Message to unknown address is rejected
    [Template]    Should be user unknown
    dude@senderdomain.test    u1@mta-groups.test
    dude@senderdomain.test    u2@mta-groups.test
    dude@senderdomain.test    u3@mta-groups.test
    dude@senderdomain.test    g1@mta-users.test
    dude@senderdomain.test    g2@mta-users.test

Message to unknown address is delivered to catchall user
    [Template]    Send message as MTA and check delivery
    dude@senderdomain.test    unknown@mta-ug.test   INBOX   ucatchall:Nethesis,1234    delivered    ${U1CREDS}    not delivered

Message to domain with add groups flag is delivered
    [Template]    Send message as MTA and check delivery
    dude@senderdomain.test    g1@mta-groups.test   INBOX    ${U1CREDS}    delivered    ${U3CREDS}    not delivered
    dude@senderdomain.test    g2@mta-groups.test   INBOX    ${U3CREDS}    delivered    ${U1CREDS}    not delivered

Message to domain with add users/groups flags and catchall is delivered
    [Template]    Send message as MTA and check delivery
    dude@senderdomain.test    u1@mta-ug.test       INBOX    ${U1CREDS}    delivered    ucatchall:Nethesis,1234    not delivered
    dude@senderdomain.test    u3@mta-ug.test       INBOX    ${U3CREDS}    delivered
    dude@senderdomain.test    g1@mta-ug.test       INBOX    ${U1CREDS}    delivered    ${U3CREDS}    not delivered
    dude@senderdomain.test    g2@mta-ug.test       INBOX    ${U3CREDS}    delivered    ${U1CREDS}    not delivered

Message to domain with aliases is delivered
    [Template]    Send message as MTA and check delivery
    dude@senderdomain.test    a1@mta-ug.test       INBOX    ${U1CREDS}    delivered    ucatchall:Nethesis,1234    not delivered    ${U3CREDS}    not delivered
    dude@senderdomain.test    a2@mta-ug.test       INBOX    ${U1CREDS}    delivered    ucatchall:Nethesis,1234    not delivered    ${U3CREDS}    delivered
