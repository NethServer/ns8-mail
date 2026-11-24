*** Settings ***
Resource    api.resource
Resource    user_domain.resource
Resource    keywords.resource
Library     SSHLibrary

*** Variables ***
${SCENARIO}              install
${acl_group}             Public Readers
${acl_mailbox}           groupacl

*** Test Cases ***
Bind to LDAP user domain
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"ldap.dom.test","mail_domain":"domain.test"}

Check module update
    Log  Scenario ${SCENARIO} with ${IMAGE_URL}  console=${True}
    IF    r'${SCENARIO}' == 'update'
        ${out}  ${rc} =  Execute Command  api-cli run update-module --data '{"force":true,"module_url":"${IMAGE_URL}","instances":["${MID}"]}'  return_rc=${True}
        Should Be Equal As Integers  ${rc}  0  action update-module ${IMAGE_URL} failed
    END

TCP ports are open
    [Template]    Retry until TCP port is open
    110
    143
    # 587
    993
    995
    # 465
    9288
    9289
    2000
    4190

API HTTP endpoint
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 10 curl -f http://127.0.0.1:9288/doveadm/v1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  22
    Should Contain    ${err}    : 401

Metrics HTTP endpoint (stats)
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 10 curl -f http://127.0.0.1:9289/metrics
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0

Login TLS policy
    [Template]    Retry test
    TLS required on non-secure IMAP connections
    IMAPs endpoint login

LDAP Login checks
    [Template]    Retry test
    IMAP login good credentials
    IMAP login bad credentials
    AD user credentials are bad with LDAP

Public folder shared with a group is visible with LDAP
    [Setup]       Share a public folder with a group    ldap.dom.test
    [Teardown]    Remove the group public folder
    Wait Until Keyword Succeeds    20 seconds    1 second
    ...    Group public folder is visible to group members
    Group public folder is hidden to other users

Switch to AD user domain
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"ad.dom.test","mail_domain":"domain.test"}

Active Directory Login checks
    [Template]    Retry test
    IMAP login good credentials
    IMAP login bad credentials
    LDAP user credentials are bad with AD

Public folder shared with a group is visible with AD
    [Setup]       Share a public folder with a group    ad.dom.test
    [Teardown]    Remove the group public folder
    Wait Until Keyword Succeeds    20 seconds    1 second
    ...    Group public folder is visible to group members
    Group public folder is hidden to other users

*** Keywords ***
LDAP user credentials are bad with AD
    [Documentation]    When bad credentials are issued the server replies with
    ...                a few seconds of delay.
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 9 curl -v -f -u u2:LdapPass,1234 imap://127.0.0.1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  67
    Should Contain    ${err}    AUTHENTICATIONFAILED

AD user credentials are bad with LDAP
    [Documentation]    When bad credentials are issued the server replies with
    ...                a few seconds of delay.
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout 9 curl -v -f -u u2:AdPass,1234 imap://127.0.0.1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  67
    Should Contain    ${err}    AUTHENTICATIONFAILED

Share a public folder with a group
    [Documentation]    Create a group whose name has a space and mixed
    ...                case, with u1 as only member, and grant it rw access
    ...                to a new public folder. Mail stores the group ACL
    ...                in lowercase, as the UI does.
    [Arguments]    ${domain}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    runagent python3 -c 'import agent ; print(agent.list_service_providers(agent.redis_connect(), "ldap", "tcp", filters={"domain":"${domain}"})[0]["module_id"])'
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    Failed to look up the provider of ${domain}: ${err}
    VAR    ${mid_provider}    ${out}    scope=TEST
    Run task    module/${mid_provider}/add-group    {"group":"${acl_group}","description":"Public folder readers","users":["u1"]}
    Run task    module/${MID}/add-public-mailbox    {"mailbox":"${acl_mailbox}","acls":[{"stype":"group","subject":{"dtype":"group","name":"${acl_group.lower()}"},"rights":{"rtype":"rw"}}]}

Remove the group public folder
    Run task    module/${MID}/remove-public-mailbox    {"mailbox":"${acl_mailbox}"}
    Run task    module/${mid_provider}/remove-group    {"group":"${acl_group}"}

Group public folder is visible to group members
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout ${curl_timeout} curl -s -f -u u1:Nethesis,1234 -X 'MYRIGHTS Public/${acl_mailbox}' imap://127.0.0.1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0    MYRIGHTS failed:${\n}${err}
    # The group grants rw rights: at least lookup, read and write
    Should Match Regexp    ${out}    MYRIGHTS Public/${acl_mailbox} (?=\\S*l)(?=\\S*r)(?=\\S*w)
    ${out} =    Execute Command    timeout ${curl_timeout} curl -s -f -u u1:Nethesis,1234 imap://127.0.0.1
    Should Contain    ${out}    "/" Public/${acl_mailbox}

Group public folder is hidden to other users
    ${out}  ${err}  ${rc} =    Execute Command
    ...    timeout ${curl_timeout} curl -s -f -u u3:Nethesis,1234 imap://127.0.0.1
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0    IMAP LIST failed:${\n}${err}
    Should Contain        ${out}    "/" INBOX
    Should Not Contain    ${out}    Public/${acl_mailbox}
