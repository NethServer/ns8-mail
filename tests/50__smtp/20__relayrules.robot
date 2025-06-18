*** Settings ***
Documentation    Test relay rules
Resource    senddeliver.resource
Resource    ../api.resource
Library     SSHLibrary

Suite Setup     Run Keywords
                ...  Cleanup relay rules
                ...  Increase Postfix verbosity
Suite Teardown  Run Keywords
                ...  Cleanup relay rules
                ...  Reset Postfix verbosity
                ...  Reset sender/login policy

*** Keywords ***
Increase Postfix verbosity
    [Documentation]  Set POSTFIX_DEBUG=4 to write in journal a detailed trace of relay credentials
    Execute Command  runagent -m ${MID} python3 -c 'import agent ; agent.set_env("POSTFIX_DEBUG", "5")'
    Execute Command  runagent -m ${MID} systemctl --user postfix reload

Reset Postfix verbosity
    Execute Command  runagent -m ${MID} python3 -c 'import agent ; agent.unset_env("POSTFIX_DEBUG")'
    Execute Command  runagent -m ${MID} systemctl --user postfix reload

Add relay rule
    [Arguments]    ${rtype}    ${rsubject}    ${rhost}    ${rport}    ${rusername}
    Run task    module/${MID}/add-relay-rule    {"rule_type":"${rtype}","rule_subject":"${rsubject}","host":"${rhost}","port":${rport},"mandatory_tls":false,"username":"","password":"","enabled":true}
    IF    r'$rusername' != ""
        Execute Command    runagent -m ${MID} podman exec -w /srv postfix sqlite3 pcdb.sqlite "UPDATE relayrules SET username='${rusername}', password='rpass' WHERE rule_subject LIKE '${rsubject}' AND rule_type == '${rtype}'"
    END

Cleanup relay rules
    Execute Command    runagent -m ${MID} podman exec -w /srv postfix sqlite3 pcdb.sqlite 'DELETE FROM relayrules;'

Reset sender/login policy
    Run task    module/${MID}/set-relay-configuration    {"postfix_restricted_sender":false}

*** Test Cases ***
Configure relay rules
    [Template]    Add relay rule
    wildcard    *                    127.0.0.1    10001    ${EMPTY}
    sender      u1@mta-ug.test       127.0.0.1    10002    usr_u1
    sender      u3@mta-ug.test       127.0.0.1    10002    usr_u3
    recipient   rcptrule.test        127.0.0.1    10003    ${EMPTY}
    sender      g1@mta-ug.test       127.0.0.1    10002    usr_g1
    recipient   dude@rcptrule.test   127.0.0.1    10004    usr_relay

Relay is restricted on port 25
    Should be relay access denied    u1@mta-ug.test    somebody@relaydenied.test

Relay is allowed from trusted IP
    ${queue_id}=    Send SMTP message    dude@mta-ug.test    somebody@relaytrusted.test    mail_server=127.0.0.1:25
    Should Not Be Empty    ${queue_id}

Untrusted client cannot use known sender addresses on submission port
    [Template]    Should fail because not logged in
    u3@mta-ug.test    dude@rcptrule.test             :    ${MAIL_SERVER}:587
    a1@mta-ug.test    somebody@rcptrule.test         :    ${MAIL_SERVER}:587
    g1@mta-ug.test    somebody@relaywildcard.test    :    ${MAIL_SERVER}:587

Trusted IP can use known sender addresses on submission port
    [Template]    Should be sent via
    usr_relay  10004  u1@mta-ug.test    dude@rcptrule.test             :    127.0.0.1:587
    ${EMPTY}   10003  u3@mta-ug.test    other@rcptrule.test            :    127.0.0.1:587
    usr_relay  10004  g1@mta-ug.test    dude@rcptrule.test             :    127.0.0.1:587
    ${EMPTY}   10001  a1@mta-ug.test    somebody@relaywildcard.test    :    127.0.0.1:587

External recipient goes to wildcard
    [Template]    Should be sent via
    ${EMPTY}   10001  dude@mta-ug.test    somebody@relaywildcard.test  u1:Nethesis,1234

Specific recipient domain uses expected relay host
    [Template]    Should be sent via
    ${EMPTY}   10003  dude@mta-ug.test    somebody@rcptrule.test       u1:Nethesis,1234
    usr_relay  10004  dude@mta-ug.test    dude@rcptrule.test           u1:Nethesis,1234

Known sender uses the expected relay rule without login match
    [Template]    Should be sent via
    # User exact match
    usr_relay  10004  u1@mta-ug.test  dude@rcptrule.test      u3:Nethesis,1234
    ${EMPTY}   10003  u1@mta-ug.test  somebody@rcptrule.test  u3:Nethesis,1234
    usr_u3  10002  u3@mta-ug.test  dude@relaywildcard.test      u1:Nethesis,1234
    usr_u3  10002  u3@mta-ug.test  somebody@relaywildcard.test  u1:Nethesis,1234
    # Group member
    usr_g1  10002  g1@mta-ug.test  dude@relaywildcard.test      u3:Nethesis,1234
    usr_g1  10002  g1@mta-ug.test  somebody@relaywildcard.test  u3:Nethesis,1234
    # Alias
    ${EMPTY}  10001  a1@mta-ug.test  dude@relaywildcard.test      u3:Nethesis,1234
    ${EMPTY}  10001  a1@mta-ug.test  somebody@relaywildcard.test  u3:Nethesis,1234

Unknown sender goes to recipient rule with any login
    [Template]    Should be sent via
    ${EMPTY}   10001  somealias@mta-ug.test  somebody@relaywildcard.test  u1:Nethesis,1234
    ${EMPTY}   10003  somealias@mta-ug.test  somebody@rcptrule.test       u3:Nethesis,1234
    usr_relay  10004  somealias@mta-ug.test  dude@rcptrule.test           u1:Nethesis,1234

Enforce sender/login strict match
    Run task    module/${MID}/set-relay-configuration    {"postfix_restricted_sender":true}

Known sender fails with login mismatch
    [Template]    Should fail sender/login policy
    u1@mta-ug.test    u3:Nethesis,1234
    u3@mta-ug.test    u1:Nethesis,1234
    a1@mta-ug.test    u3:Nethesis,1234
    g1@mta-ug.test    u3:Nethesis,1234

Unknown sender is not allowed with strict sender/login match
    [Template]    Should fail sender/login policy
    somealias@mta-ug.test           u3:Nethesis,1234
    somebody@rcptrule.test          u1:Nethesis,1234

If login matches the sender, host is selected by rule
    [Template]    Should be sent via
    # User exact match
    usr_u1  10002  u1@mta-ug.test  dude@rcptrule.test      u1:Nethesis,1234
    usr_u1  10002  u1@mta-ug.test  somebody@rcptrule.test  u1:Nethesis,1234
    usr_u3  10002  u3@mta-ug.test  dude@rcptrule.test      u3:Nethesis,1234
    usr_u3  10002  u3@mta-ug.test  somebody@rcptrule.test  u3:Nethesis,1234
    # Group member
    usr_g1  10002  g1@mta-ug.test  dude@rcptrule.test      u1:Nethesis,1234
    usr_g1  10002  g1@mta-ug.test  somebody@rcptrule.test  u1:Nethesis,1234
    # Alias
    ${EMPTY}  10004  a1@mta-ug.test  dude@rcptrule.test      u1:Nethesis,1234
    ${EMPTY}  10003  a1@mta-ug.test  somebody@rcptrule.test  u1:Nethesis,1234
