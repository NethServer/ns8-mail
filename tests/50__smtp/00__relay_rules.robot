*** Settings ***
Documentation    Relay rules must respect the documented priority.
...              Remote host credentials are correctly selected and used for each rule.
...              These tests expect unrestricted sender policy.

Resource    smtp.resource
Suite Setup        Add relay rules
Suite Teardown     Cleanup relay rules
Test Tags    relayrules

*** Test Cases ***
Wildcard rule has the lowest priority
    Send SMTP message to    somebody@wildcard.test
    ...                     from=someone@otherdomain.test
    ...                     credentials=u3:Nethesis,1234
    Should be relayed via SMTP  port=10001

Sender address rule has medium priority
    Send SMTP message to    somebody@wildcard.test
    ...                     from=u3@inbound.test
    ...                     credentials=u3:Nethesis,1234
    Should be relayed via SMTP  port=10002  smtp_user=usr_u3

Sender address rule honors TLS encryption
    [Tags]    bug    bug-7626
    Skip  "Not implemented"

Sender domain rule has less priority than address match
    Send SMTP message to    somebody@wildcard.test
    ...                     from=noreply@inbound.test
    ...                     credentials=u3:Nethesis,1234
    Should be relayed via SMTP  port=10002  smtp_user=${EMPTY}

Sender domain rule honors TLS encryption
    [Tags]    bug    bug-7626
    Skip  "Not implemented"

Sender domain rule provides the correct credentials
    [Tags]    bug    bug-7551
    Send SMTP message to    somebody@wildcard.test
    ...                     from=noreply@addusers.test
    ...                     credentials=u3:Nethesis,1234
    Should be relayed via SMTP  port=10002  smtp_user=usr_bug7551

Recipient domain rule has less priority than address match
    Send SMTP message to    someone@rcptrule.test
    ...                     from=u1@inbound.test
    ...                     credentials=u1:Nethesis,1234
    Should be relayed via SMTP  port=10003  smtp_user=${EMPTY}

Recipient address rule has the highest priority
    Send SMTP message to    dude@rcptrule.test
    ...                     from=u3@inbound.test
    ...                     credentials=u3:Nethesis,1234
    Should be relayed via SMTP  port=10004  smtp_user=usr_relay

*** Keywords ***
Add relay rules
    Add relay rule    wildcard    *                    127.0.0.1    10001    ${EMPTY}
    Add relay rule    sender      inbound.test         127.0.0.1    10002    ${EMPTY}
    Add relay rule    sender      u1@inbound.test      127.0.0.1    10002    usr_u1
    Add relay rule    sender      u3@inbound.test      127.0.0.1    10002    usr_u3
    Add relay rule    recipient   rcptrule.test        127.0.0.1    10003    ${EMPTY}
    Add relay rule    sender      addusers.test        127.0.0.1    10002    usr_bug7551
    Add relay rule    sender      g1@inbound.test      127.0.0.1    10002    usr_g1
    Add relay rule    recipient   dude@rcptrule.test   127.0.0.1    10004    usr_relay
